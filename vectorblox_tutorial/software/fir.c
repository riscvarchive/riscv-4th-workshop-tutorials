#include  <stdio.h>
#include  <stdint.h>

#include "vbx.h"
//#include "mxp_system.h"
#include "printf.h"
#include "main.h"

#define I2S_DATA      ((volatile uint32_t*) (0x50000008))
#define SPEAKER_DATA  ((volatile uint32_t*) (0x70000008))




//#include "taps32.c"
//#include "taps64.c"
#include "taps128.c"



static vbx_word_t *v_taps;
static vbx_word_t *v_inp;
static vbx_word_t *v_out;
static vbx_word_t *v_mac;

#define TAPS_LEN (NTAPS * sizeof(*v_taps) )
#define SND_LEN  (((MXP_DATA_SPAN - 2*TAPS_LEN - 2*sizeof(*v_mac) )>>2)>>1)

void filter_init() {
	v_inp  = vbx_sp_malloc( SND_LEN * sizeof(*v_inp)  );
	v_out  = vbx_sp_malloc( SND_LEN * sizeof(*v_out)  );
	v_taps = vbx_sp_malloc( NTAPS   * sizeof(*v_taps) );
	v_mac  = vbx_sp_malloc( sizeof(*v_mac) );

#if 0	// PRINT DIFFERENT VECTOR LENGTHS
	printf( "v_inp %d v_out %d v_taps %d v_mac %d\n",
		SND_LEN*sizeof(*v_inp), SND_LEN*sizeof(*v_out), NTAPS*sizeof(*v_taps), sizeof(*v_mac) );

	printf( "v_inp %08x v_out %08x v_taps %08x v_mac %08x\n",
		v_inp, v_out, v_taps, v_mac );
#endif
	int idx;
	for( idx=0; idx < NTAPS; idx++ ) {
		v_taps[idx] = filter_taps[idx];
	}
}


void scalar_filter( ) {
	int i, j, acc;
	for( i=0; i < SND_LEN-NTAPS; i++ ) {
		acc=0;
		for( j=0; j < NTAPS; j++ ) {
			const int sample = (int) v_inp[i+j];
			const int tap    = (int) v_taps[j];
			acc += (sample*tap);
		}
		v_out[i] = (vbx_half_t)(acc >> 16);
	}
}

void vector_filter() {
	int i;
	for( i=0; i < SND_LEN-NTAPS; i++ ) {
		vbx_set_vl( NTAPS );
		vbx_acc( VVW, VMUL, v_mac, (v_inp+i), v_taps );
#if 1
		// should be faster due to large NTAPS value and no stalls
		vbx_set_vl( 1 );
		vbx( SVW,  VSHR, v_mac,      16, v_mac );
		vbx( VVW, VMOV, v_out+i, v_mac,     0 );
#else
		// sync slows things down
		vbx_sync();
		v_out[i] = (vbx_half_t)( (*v_mac) >> 16 );
#endif
		vbx_sync();
	}
	vbx_sync();

}

#if 0
// 2D version doesn't work
void vector_filter() {
	vbx_set_vl( NTAPS );
	// this won't work, we need the 2 MS bytes of v_mac in v_out
	// but this will save the 2 LS bytes.
	vbx_set_2D( SND_LEN-NTAPS,  2,     2,      0 );
	vbx_acc_2D( VVHW, VMUL, v_out, v_inp, v_taps );
	vbx_sync();
}
#endif


// SOUND SAMPLE RECORD AND PLAYBACK

void record( int32_t *sample )
{
	int16_t left, rght;
	uint32_t i2s_data = *I2S_DATA; // blocking read
	left = ((int16_t) ((i2s_data >> 16    ) & 0xFFFF)) ;
	rght = ((int16_t) ( i2s_data & 0xFFFF));
	*sample = (left + rght);

	//volume bump
	*sample <<=1;
}

void playback( int16_t sample )
{
	uint32_t data = (((uint32_t)sample) << 16) | (0xffff&(uint32_t)sample);
	*SPEAKER_DATA = data; // blocking write
}


int sound_filter_test()
{

	filter_init();

	int i,j;
	while(1) {

		printf( "recording\r\n" );
		for( i=0; i<SND_LEN; i++ ) {
			record( v_inp+i );
		}

		// playback the same recording several times
		// compare original to filtered versions
		for( j=0; j < 2 ; j++ )  {

			int scalar_time=1, vector_time=-1;

			printf( "scalar processing\r\n" );
			scalar_time=get_time();
			scalar_filter();
			scalar_time=get_time()-scalar_time ;
			printf("scalar time = %d cycles\r\n",scalar_time);
			printf( "playback - original %d\r\n", j );
			for( i=0; i<SND_LEN-NTAPS; i++ ) {
				playback( v_inp[i] );
			}
			printf( "playback - filtered scalar %d\r\n", j );
			for( i=0; i<SND_LEN-NTAPS; i++ ) {
				playback( v_out[i] );
			}

#if 1 // RUN VECTOR CODE
			// vector code is fast, barely notice the delay
			printf( "vector processing\r\n" );
			vector_time= get_time();
			vector_filter();
			vector_time=get_time()-vector_time ;
			printf("vector time = %d cycles\r\n",vector_time);
			printf( "playback - filtered vector %d\r\n", j );
			for( i=0; i<SND_LEN-NTAPS; i++ ) {
				playback( v_out[i] );
			}
#endif

			printf("speedup = %d x \r\n",scalar_time/vector_time);

		}

	}

	vbx_sp_free();

	return 1;
}
