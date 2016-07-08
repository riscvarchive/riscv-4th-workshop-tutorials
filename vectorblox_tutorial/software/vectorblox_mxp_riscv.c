#include "vbx.h"
static vbx_mxp_t the_mxp;

int VectorBlox_MXP_Initialize()
{
	the_mxp.scratchpad_size =  MXP_DATA_SPAN;
	the_mxp.scratchpad_addr = (void*) MXP_SCRATCHPAD_BASE;
	the_mxp.scratchpad_end  = (void*) (the_mxp.scratchpad_size + the_mxp.scratchpad_addr + 1 );

	//M_AXI_DATA_WIDTH is in bits, convert to bytes
	the_mxp.dma_alignment_bytes =  8 * 4;
	the_mxp.vector_lanes =  8;
	the_mxp.scratchpad_alignment_bytes = the_mxp.vector_lanes * 4;

	the_mxp.fxp_word_frac_bits =  MXP_WORD_FXP_BITS;
	the_mxp.fxp_half_frac_bits =  MXP_HALF_FXP_BITS;
	the_mxp.fxp_byte_frac_bits =  MXP_BYTE_FXP_BITS;
	the_mxp.core_freq =  20000000;
//	the_mxp.instr_port_addr = (void*) VECTORBLOX_MXP_0_AXI_INSTR_SLAVE_BASE;

	the_mxp.init = 0;

	the_mxp.sp = the_mxp.scratchpad_addr;

	the_mxp.spstack = (vbx_void_t **) NULL;
	the_mxp.spstack_top = (int) 0;
	the_mxp.spstack_max = (int) 0;

	_vbx_init(&the_mxp);

	return 0;
}
