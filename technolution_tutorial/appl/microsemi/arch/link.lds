/******************************************************************************

 (C) COPYRIGHT 2016 TECHNOLUTION B.V., GOUDA NL
| =======          I                   ==          I    =
|    I             I                    I          I
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

 -----------------------------------------------------------------------------
  Title      :  linker file
  Author     :  Jonathan Hofman
 -----------------------------------------------------------------------------

  Description:  This linker file is used for the Microsemi SiFive example 
                system on the Smartfusion SOM060.

                This linker file asumes that the initialized data segment
                is located in flash and copied during init to the related 
                memory segement. All code is executed from flash directly.

******************************************************************************/

OUTPUT_ARCH( "riscv" )

_STACK_SIZE = DEFINED(_STACK_SIZE) ? _STACK_SIZE : 1024;
_HEAP_SIZE = DEFINED(_HEAP_SIZE) ? _HEAP_SIZE : 0;

/*****************************************************************************
 * Define memory layout
 ****************************************************************************/
MEMORY 
{
    flash (rx)  : ORIGIN = 0x60020000, LENGTH = 128K
    ram   (xrw) : ORIGIN = 0x80000000, LENGTH = 64K
}

/*****************************************************************************
 * Define the sections, and where they are mapped in memory 
 ****************************************************************************/
SECTIONS {
	/*****************************
	 * Flash located segments                                                             
     *****************************/

    /* text (code) segments */
    .text : {
        *entry.o(.text)
        *(.text)
        *(text.*)
    } > flash

    .init : {
        KEEP (*(.init))
    } > flash

    .fini : {
        KEEP (*(.fini))
    } > flash

    /* read only data segments */
    .rodata : {
        . = ALIGN(4);
        __rodata_start = .;
        *(.rodata)
        *(.rodata.*)
        *(.gnu.linkonce.r.*)
        __rodata_end = .;
    } > flash

    .srodata : {
       . = ALIGN(4);
        _gp = . + 0x800;
        __srodata_start = .;
        *(.srodata.cst16) 
        *(.srodata.cst8) 
        *(.srodata.cst4) 
        *(.srodata.cst2)
        *(.srodata*)
        __srodata_end = .;
    } > flash

    /* initialized data segment, moved from flash to ram at start */
    . = ALIGN(4);
    __flash_data_start = .;
    .data : { 
        . = ALIGN(4);
        __data_start = .; 
        *(.data) 
        *(.sdata)
        *(.sdata.*)
        *(.gnu.linkonce.s.*)
        . = ALIGN(4);
        __data_end = .;
    } > ram AT>flash 

    /*****************************
     * RAM located segments                                                             
     *****************************/

    __bss_data_start = .;
    .sbss : {
        __sbss_start = .;
        . = ALIGN(4);
        *(.sbss .sbss.* .gnu.linkonce.sb.*)
        *(.scommon)
        . = ALIGN(4);
        __sbss_end = .;
    } > ram

    .bss : { 
        __bss_start = .;
        . = ALIGN(4);
        *(.bss)
        *(.bss.*)
        *(.gnu.linkonce.b.*)
        *(COMMON)
        . = ALIGN(4);
        __bss_end = .; 
    } > ram
    __bss_data_end = .;

    /* Generate Stack and Heap definitions */
    .heap : {
       . = ALIGN(8);
       _heap = .;
       _heap_start = .;
       . += _HEAP_SIZE;
       _heap_end = .;
    } > ram

    .stack : {
       _stack_end = .;
       . += _STACK_SIZE;
       . = ALIGN(8);
       _stack = .;
       __stack = _stack;
    } > ram

    _end = .;
}

