//VBXCOPYRIGHTTAG
/**
 * @file
 * @defgroup VBX Main include file
 * @brief Main file to include in programs
 *
 * @ingroup VBXapi
 *
 * ####Includes
 * * @ref vbx_types.h
 * * @ref vbx_extern.h
 * * @ref vbx_macros.h
 * * @ref vbx_asm_or_sim.h
 * * @ref vbx_api.h
 * * @ref vbx_lib.h
 * * @ref vbx_cproto.h
 * * @ref vbxx.hpp
 *
 */
/**@{*/

#ifndef __VBX_H
#define __VBX_H

#ifdef __cplusplus
extern "C" {
#endif
#if defined(_MSC_VER)
	//Visual studio doesn't have __attribute__s
#define __attribute__(...)
#endif
#include "vendor.h"
//figure out target from builtin compilier defines
#if defined(__nios2__)
#  define NIOS_STANDALONE 1
#elif defined(__arm__)
#  if defined(linux)
#    define ARM_LINUX 1
#  elif !defined(XILINX)
#    define ARM_ALT_STANDALONE 1
#  else
#    define ARM_XIL_STANDALONE 1
#  endif
#elif defined(__microblaze__)
#  define MB_STANDALONE 1
#endif

#ifndef ARM_XIL_STANDALONE
#define ARM_XIL_STANDALONE 0
#endif
#ifndef ARM_LINUX
#define ARM_LINUX 0
#endif
#ifndef ARM_ALT_STANDALONE
#define ARM_ALT_STANDALONE 0
#endif
#ifndef MB_STANDALONE
#define MB_STANDALONE 0
#endif
#ifndef NIOS_STANDALONE
#define NIOS_STANDALONE 0
#endif
#ifndef VBX_SIMULATOR
#define VBX_SIMULATOR 0
#endif

#if (ARM_XIL_STANDALONE +	  \
     ARM_LINUX +	  \
     ARM_ALT_STANDALONE +	  \
     MB_STANDALONE +	  \
     NIOS_STANDALONE + \
     RISCV_STANDALONE + \
     VBX_SIMULATOR) == 0
#error Must define one of ARM_XIL_STANDALONE, ARM_LINUX, ARM_ALT_STANDALONE, MB_STANDALONE, NIOS_STANDALONE, RISCV_STANDALONE, VBX_SIMULATOR
#endif
#if (ARM_XIL_STANDALONE +	  \
     ARM_LINUX +	  \
     ARM_ALT_STANDALONE +	  \
     MB_STANDALONE +	  \
     NIOS_STANDALONE +	  \
     RISCV_STANDALONE + \
     VBX_SIMULATOR ) > 1
#error May only define one of ARM_XIL_STANDALONE, ARM_LINUX, ARM_ALT_STANDALONE, MB_STANDALONE, NIOS_STANDALONE, RISCV_STANDALONE, VBX_SIMULATOR
#endif

#if !RISCV_STANDALONE
#include <assert.h>
#else
#define assert(SOMETHING) do{}while(0)
#endif


#include <stddef.h>


// The order below must not be altered
#include "mxp_system.h"
#include "vbx_types.h"
#include "vbx_extern.h"
#include "vbx_macros.h"

#include "vbx_asm_or_sim.h"

#include "vbx_api.h"
#include "vbx_lib.h"

#include "vbx_cproto.h"

#if ARM_XIL_STANDALONE || MB_STANDALONE
#include "vectorblox_mxp_xil.h"
#endif
#if ARM_ALT_STANDALONE

#include "vectorblox_mxp_hps.h"
#endif

#ifdef __cplusplus
}
#endif

#ifdef __cplusplus
#include "vbxx.hpp"
#endif


#endif //__VBX_H
/**@}*/
