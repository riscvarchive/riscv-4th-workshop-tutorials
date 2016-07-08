//VBXCOPYRIGHTTAG
/**
 * @file
 * @defgroup VBX_ASM_or_sim VBX_ASM_or_sim
 * @brief Included proper headers depending if running simulator or not
 *
 * @ingroup VBXapi
 */
/**@{*/

#ifndef __VBX_ASM_OR_SIM_H
#define __VBX_ASM_OR_SIM_H

#ifdef __cplusplus
extern "C" {
#endif


#if !VBX_SIMULATOR
# undef VBX_ASSEMBLER
# undef VBX_SIMULATOR
# define VBX_ASSEMBLER 1
# define VBX_SIMULATOR 0
#else
# undef VBX_ASSEMBLER
# undef VBX_SIMULATOR
# define VBX_ASSEMBLER 0
# define VBX_SIMULATOR 1
#endif

// NB: the assembler and the simulator are mutually exclusive
#if (VBX_ASSEMBLER && VBX_SIMULATOR)
#error "Configuration error. Cannot use both assembler and simulator at the same time."
#endif

// Include the assembler
#if VBX_ASSEMBLER
#if __NIOS2__
#include "vbx_asm_nios.h"
#elif __MICROBLAZE__
#include "vbx_asm_mb.h"
#elif __arm__
#include "vbx_asm_arm.h"
#else
#include "vbx_asm_riscv.h"
#endif
#endif

// Include the simulator
#if VBX_SIMULATOR
#include "vbx_sim.h"
#endif

#define __vbxx_setup_mask(TYPE,IS_SIGNED,VMODE,VINSTR,SRC,MASKED)	  \
	if(sizeof(src_t)==sizeof(TYPE) && (IS_SIGNED)){ \
		vbx_setup_mask##MASKED(VMODE,(VINSTR),(SRC)); \
	}
#define _vbxx_setup_mask(VINSTR,SRC,MASKED)	  \
	do{ \
		int is_signed=((typeof(*(SRC)))-1)<0; \
		typedef typeof(*SRC) src_t; \
		__vbxx_setup_mask(vbx_word_t,is_signed,SVWS,(VINSTR),(SRC)  ,MASKED); \
		__vbxx_setup_mask(vbx_half_t,is_signed,SVHS,(VINSTR),(SRC)  ,MASKED); \
		__vbxx_setup_mask(vbx_byte_t,is_signed,SVBS,(VINSTR),(SRC)  ,MASKED); \
		__vbxx_setup_mask(vbx_uword_t,!is_signed,SVWU,(VINSTR),(SRC),MASKED); \
		__vbxx_setup_mask(vbx_uhalf_t,!is_signed,SVHU,(VINSTR),(SRC),MASKED); \
		__vbxx_setup_mask(vbx_ubyte_t,!is_signed,SVBU,(VINSTR),(SRC),MASKED); \
	}while(0)


#ifdef __cplusplus
}
#endif

//define the simulator api to noops so code doesn't break
//when it gets moved to hardware
#if !VBX_SIMULATOR
#define vbxsim_init(...) ((void)0)
#define vbxsim_destroy() ((void)0)
#define vbxsim_set_dma_type(...) ((void)0)
#define vbxsim_reset_stats() ((void)0)
#define vbxsim_print_stats() ((void)0)
#define vbxsim_print_stats_extended() ((void)0)
#define vbxsim_disable_warnings() ((void)0)
#define vbxsim_enable_warnings() ((void)0)

#endif
#endif //__VBX_ASM_OR_SIM_H
/**@}*/
