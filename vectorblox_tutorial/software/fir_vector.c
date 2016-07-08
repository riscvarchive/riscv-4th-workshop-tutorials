#include  <stdint.h>

#define MXP_HALF_FXP_BITS    15
#define MXP_DATA_SPAN        (32*1024)
#define MXP_SCRATCHPAD_BASE  0x10000000
#define MXP_INSTRUCTION_BASE 0x20000000
#include "vbx.h"

#include "printf.h"

#define I2S_DATA      ((volatile int*) (0x50000008))
#define SPEAKER_DATA  ((volatile int*) (0x70000008))



// FILTER CODE

#define USE_SCALAR_FILTER 0
#define USE_VECTOR_FILTER 1

#define NTAPS 64		// NTAPS must be power of 2

static int16_t filter_taps[NTAPS] = {
  -11,
  9,
  46,
  100,
  143,
  136,
  55,
  -88,
  -227,
  -273,
  -159,
  99,
  384,
  521,
  369,
  -68,
  -600,
  -915,
  -743,
  -44,
  901,
  1567,
  1438,
  331,
  -1395,
  -2872,
  -3050,
  -1186,
  2723,
  7806,
  12563,
  15435,
  15435,
  12563,
  7806,
  2723,
  -1186,
  -3050,
  -2872,
  -1395,
  331,
  1438,
  1567,
  901,
  -44,
  -743,
  -915,
  -600,
  -68,
  369,
  521,
  384,
  99,
  -159,
  -273,
  -227,
  -88,
  55,
  136,
  143,
  100,
  46,
  9,
  -11
};

static int16_t buf[NTAPS];
static int idx;

static volatile vbx_half_t *v_buf;
static volatile vbx_half_t *v_taps;
static volatile vbx_word_t *v_out;

void filter_init() {
#if 1
  v_buf  = ((vbx_half_t*)MXP_SCRATCHPAD_BASE);
  v_taps = ((vbx_half_t*)MXP_SCRATCHPAD_BASE)+NTAPS;
  v_out  = ((vbx_word_t*)MXP_SCRATCHPAD_BASE)+(2*NTAPS);
  printf("%x %x %x\r\n",v_buf,v_taps,v_out);
#else
	v_buf  = vbx_sp_malloc( NTAPS * sizeof(int16_t) );
	v_taps = vbx_sp_malloc( NTAPS * sizeof(int16_t) );
	v_out  = vbx_sp_malloc( sizeof(int32_t) );
#endif
	vbx_set_vl( NTAPS );
	vbx( SVH, VMOV, v_buf, 0, 0 );

	for( idx=0; idx < NTAPS; idx++ ) {
		v_taps[idx] = filter_taps[idx];
		buf[idx] = 0;
	}
	idx = 0;
}

void scalar_filter_put( int16_t sample ) {
	buf[idx] = sample;
	idx = (idx+1) & (NTAPS-1); // NTAPS must be power of 2
}

int scalar_filter_get() {
	int acc = 0;
	int i, index;
	for( i=0, index=idx; i < NTAPS; i++ ) {
		const int sample = (int) buf[ (index--) & (NTAPS-1) ];
		const int tap    = (int) filter_taps[i];
		acc += sample*tap;
	};
	return acc >> 16;
}


void vector_filter_put( int16_t sample ) {
	vbx_set_vl( NTAPS-1 );
	vbx( VVH, VMOV, v_buf, v_buf+1, 0 );
	v_buf[NTAPS-1] = sample;
}

int vector_filter_get() {
	long long acc = 0;

	vbx_set_vl( NTAPS );
	vbx_acc( VVHW, VMUL, v_out, v_buf, v_taps );
	vbx_sync();
	*v_out= *v_out >> 16;
	return *v_out;
}



// SOUND SAMPLE RECORD AND PLAYBACK

void record( int16_t *sample )
{
	int16_t left, rght;
	uint32_t i2s_data = *I2S_DATA; // blocking read
	left = ((int16_t) ((i2s_data >> 16    ) & 0xFFFF));
	rght = ((int16_t) ( i2s_data & 0xFFFF));
	*sample = (left + rght);
}

void play( int16_t sample )
{
	uint32_t data = (((uint32_t)sample) << 16) | ((uint32_t)sample);
	*SPEAKER_DATA = data; // blocking write
}


int sound_filter_test()
{

	filter_init();
	for(int i=0;i<5;i++){
	  v_buf[i]=i+1;
	}
	vbx_set_vl(5);
	vbx(SVH,VADD,v_buf,2,v_buf);
	vbx_sync();
	printf("%d\r\n",v_buf[0]);
	printf("%d\r\n",v_buf[1]);
	printf("%d\r\n",v_buf[2]);
	while(1) {
		int16_t sample;
		record( &sample );

#if USE_SCALAR_FILTER
		scalar_filter_put( sample );
		sample = scalar_filter_get( buf );
#endif

#if USE_VECTOR_FILTER
		vector_filter_put( sample );
		sample = vector_filter_get( buf );
#endif

		play( sample );
	}

	return 1;
}
