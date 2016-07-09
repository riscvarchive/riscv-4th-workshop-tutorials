/*
  (C) COPYRIGHT 2016 TECHNOLUTION B.V., GOUDA NL and others
  =======          I                   ==          I    =
     I             I                    I          I
|    I   ===   === I ===  I ===   ===   I  I    I ====  I   ===  I ===
|    I  /   \ I    I/   I I/   I I   I  I  I    I  I    I  I   I I/   I
|    I  ===== I    I    I I    I I   I  I  I    I  I    I  I   I I    I
|    I  \     I    I    I I    I I   I  I  I   /I  \    I  I   I I    I
|    I   ===   === I    I I    I  ===  ===  === I   ==  I   ===  I    I
|                 +---------------------------------------------------+
+----+            |  +++++++++++++++++++++++++++++++++++++++++++++++++|
     |            |             ++++++++++++++++++++++++++++++++++++++|
     +------------+                          +++++++++++++++++++++++++|
                                                        ++++++++++++++|
                                                                 +++++|
 */
/**
 * @file
 * @author  Jonathan Hofman <jonathan.hofman@technolution.nl>
 *
 * @brief   This file is based on code examples from diverse RISC-V projects
 *
 */

#include "encoding.h"

#ifdef __riscv64
# define STORE    sd
# define LOAD     ld
# define REGBYTES 8
#else
# define STORE    sw
# define LOAD     lw
# define REGBYTES 4
#endif

#ifdef __riscv64
# define LREG ld
# define SREG sd
# define REGBYTES 8
#else
# define LREG lw
# define SREG sw
# define REGBYTES 4
#endif

  .text
  .globl _start
_start:
  j _mstart

nmi_vector:
  j nmi_vector

trap_vector:
  j trap_entry
 
/** Startup code (entry point)
 *
 * The following code initializes the C environment and calls the C-init
 * function
 */
_mstart:
    li	x1, 0
    li	x2, 0
    li	x3, 0
    li	x4, 0
    li	x5, 0
	li	x6, 0
    li	x7, 0
    li	x8, 0
    li	x9, 0
    li	x10, 0
    li	x11, 0
    li	x12, 0
    li	x13, 0
    li	x14, 0
    li	x15, 0
    li	x16, 0
    li	x17, 0
    li	x18, 0
    li	x19, 0
    li	x20, 0
    li	x21, 0
    li	x22, 0
    li	x23, 0
    li	x24, 0
    li	x25, 0
    li	x26, 0
    li	x27, 0
    li	x28, 0
    li	x29, 0
    li	x30, 0
    li	x31, 0

    la t0, trap_entry
    csrw mtvec, t0
    csrwi mstatus, 0
    csrwi mideleg, 0
    csrwi medeleg, 0
    csrwi mie, 0

    /* initialize global pointer */
    la	gp, _gp


init_bss:    
    /* init bss section */
    la      a0, __bss_data_start
    la      a1, __bss_data_end
    li      a2, 0x0
    jal     fill_block
    
init_data:    
    /* copy data section from flash */
    la      a0, __data_start
    la      a1, __data_end
    la      a2, __flash_data_start
    jal     copy_block

    /* initialize stack pointer */
    la sp, _stack

    j	_init
    
/** fill_block
 * fills the memery from start_address to end_address
 * with a value. Asumes (start < end)
 *
 * a0 - start address
 * a1 - end address
 * a2 - fill value
 *
 */
fill_block:
    sw      a2, 0(a0)
    addi    a0, a0, 4
    blt     a0, a1, fill_block
    ret    
    
/** copy block
 * copies data segments word by word
 * assumes blocks are word aligned (asumes start < end)
 *
 * a0 - dest start address
 * a1 - dest end address
 * a2 - src start address
 * t0 - data value to transport
 */
copy_block:
    lw      t0, 0(a2)
    sw      t0, 0(a0)
    addi    a0, a0, 4
    addi    a2, a2, 4
    blt     a0, a1, copy_block
    ret

/** trap entry
 * basic trap handler
 *
 * This function is called when a trap or interrupt is detected and taken
 * by the processor.
 */
trap_entry:
	/* Check for interrupt */
  addi	sp, sp, -REGBYTES
  STORE	t0, 0x0(sp)
  csrr	t0, mcause
  slli	t0,t0,1
  xori	t0,t0,22
  bne	t0,x0,return_trap

  LOAD	t0, 0x0(sp)
  addi	sp, sp, REGBYTES

	/* Interupt is timer interrupt */
  j		handle_interrupt			/* jump to the freertos handlling function */

return_trap:
  LOAD	t0, 0x0(sp)
  addi	sp, sp, REGBYTES

  addi sp, sp, -32*REGBYTES

  SREG x1, 1*REGBYTES(sp)
  SREG x2, 2*REGBYTES(sp)
  SREG x3, 3*REGBYTES(sp)
  SREG x4, 4*REGBYTES(sp)
  SREG x5, 5*REGBYTES(sp)
  SREG x6, 6*REGBYTES(sp)
  SREG x7, 7*REGBYTES(sp)
  SREG x8, 8*REGBYTES(sp)
  SREG x9, 9*REGBYTES(sp)
  SREG x10, 10*REGBYTES(sp)
  SREG x11, 11*REGBYTES(sp)
  SREG x12, 12*REGBYTES(sp)
  SREG x13, 13*REGBYTES(sp)
  SREG x14, 14*REGBYTES(sp)
  SREG x15, 15*REGBYTES(sp)
  SREG x16, 16*REGBYTES(sp)
  SREG x17, 17*REGBYTES(sp)
  SREG x18, 18*REGBYTES(sp)
  SREG x19, 19*REGBYTES(sp)
  SREG x20, 20*REGBYTES(sp)
  SREG x21, 21*REGBYTES(sp)
  SREG x22, 22*REGBYTES(sp)
  SREG x23, 23*REGBYTES(sp)
  SREG x24, 24*REGBYTES(sp)
  SREG x25, 25*REGBYTES(sp)
  SREG x26, 26*REGBYTES(sp)
  SREG x27, 27*REGBYTES(sp)
  SREG x28, 28*REGBYTES(sp)
  SREG x29, 29*REGBYTES(sp)
  SREG x30, 30*REGBYTES(sp)
  SREG x31, 31*REGBYTES(sp)

  csrr a0, mcause
  csrr a1, mepc
  mv a2, sp
  jal handle_trap
  csrw mepc, a0

  # Remain in M-mode after mret
  li t0, MSTATUS_MPP
  csrs mstatus, t0

  LREG x1, 1*REGBYTES(sp)
  LREG x2, 2*REGBYTES(sp)
  LREG x3, 3*REGBYTES(sp)
  LREG x4, 4*REGBYTES(sp)
  LREG x5, 5*REGBYTES(sp)
  LREG x6, 6*REGBYTES(sp)
  LREG x7, 7*REGBYTES(sp)
  LREG x8, 8*REGBYTES(sp)
  LREG x9, 9*REGBYTES(sp)
  LREG x10, 10*REGBYTES(sp)
  LREG x11, 11*REGBYTES(sp)
  LREG x12, 12*REGBYTES(sp)
  LREG x13, 13*REGBYTES(sp)
  LREG x14, 14*REGBYTES(sp)
  LREG x15, 15*REGBYTES(sp)
  LREG x16, 16*REGBYTES(sp)
  LREG x17, 17*REGBYTES(sp)
  LREG x18, 18*REGBYTES(sp)
  LREG x19, 19*REGBYTES(sp)
  LREG x20, 20*REGBYTES(sp)
  LREG x21, 21*REGBYTES(sp)
  LREG x22, 22*REGBYTES(sp)
  LREG x23, 23*REGBYTES(sp)
  LREG x24, 24*REGBYTES(sp)
  LREG x25, 25*REGBYTES(sp)
  LREG x26, 26*REGBYTES(sp)
  LREG x27, 27*REGBYTES(sp)
  LREG x28, 28*REGBYTES(sp)
  LREG x29, 29*REGBYTES(sp)
  LREG x30, 30*REGBYTES(sp)
  LREG x31, 31*REGBYTES(sp)

  addi sp, sp, 32*REGBYTES
  mret

     
