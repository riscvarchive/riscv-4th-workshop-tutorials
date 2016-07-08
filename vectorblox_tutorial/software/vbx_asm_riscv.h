//VBXCOPYRIGHTTAG

// RISC-V version - uses memory-mapped instruction port.

#ifndef __VBX_ASM_RISCV_H
#define __VBX_ASM_RISCV_H

#ifdef __cplusplus
extern "C" {
#endif

#ifndef __VBX_ASM_OR_SIM_H
#error "This header file should not be included directly. Instead, include \"vbx_asm_or_sim.h\""
#else

#if VBX_ASSEMBLER

#ifndef MXP_INSTRUCTION_BASE
#error "MXP_INSTRUCTION_BASE must be defined before including vbx_asm_riscv.h"
#endif

#include "vbx_macros.h"

#include "vbx_asm_enc32.h"


	// -------------------------------------
	// No cacheable memory currently
#define VBX_DMA_ADDR(x,len)											\
	((vbx_uword_t) (x))
#define VBX_UNCACHED_ADDR(x)										\
	((vbx_uword_t) (x))
#define VBX_CACHED_ADDR(x)											\
	((vbx_uword_t) (x))

	// -------------------------------------

	// Address of the memory-mapped instruction port.
#define VBX_INSTR_PORT_ADDR (MXP_INSTRUCTION_BASE)

	//Get/put macros for instructions
#define vbx_getw(val) VBX_S{												\
		val = *((volatile vbx_uword_t *)(VBX_INSTR_PORT_ADDR));	\
	}VBX_E

#define vbx_getw_dummy() VBX_S{											\
		unsigned long rval;															\
		rval = *((volatile vbx_uword_t *)(VBX_INSTR_PORT_ADDR));	\
	}VBX_E

#define vbx_putw(val) VBX_S{												\
		*((volatile vbx_uword_t *)(VBX_INSTR_PORT_ADDR)) = (vbx_uword_t)(val);	\
	}VBX_E

#define VBX_INSTR_QUAD(W0, W1, W2, W3)					\
	VBX_S{																				\
		vbx_putw((W0));															\
		vbx_putw((W1));															\
		vbx_putw((W2));															\
		vbx_putw((W3));															\
	}VBX_E

#define VBX_INSTR_DOUBLE(W0, W1)								\
	VBX_S{																				\
		vbx_putw((W0));															\
		vbx_putw((W1));															\
	}VBX_E

#define VBX_INSTR_SINGLE(W0, RETURN_VAR)				\
	VBX_S{																				\
		vbx_putw((W0));															\
		vbx_getw((RETURN_VAR));											\
	}VBX_E

#define VBX_ASM(MODIFIERS,VMODE,VINSTR,DEST,SRCA,SRCB)									\
	VBX_INSTR_QUAD((((VINSTR) << (VBX_OPCODE_SHIFT)) | (VMODE) | (MODIFIERS)), \
	               (SRCA), (SRCB), (DEST))

	// -------------------------------------

#endif // VBX_ASSEMBLER
#endif // __VBX_ASM_OR_SIM_H

#ifdef __cplusplus
}
#endif

#endif // __VBX_ASM_RISCV_H
