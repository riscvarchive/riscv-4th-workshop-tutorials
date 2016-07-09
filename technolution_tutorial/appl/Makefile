################################################################################
##
## (C) COPYRIGHT 2004 TECHNOLUTION BV, GOUDA NL
## | =======          I                   ==          I    =
## |    I             I                    I          I
## |    I   ===   === I ===  I ===   ===   I  I    I ====  I   ===  I ===
## |    I  /   \ I    I/   I I/   I I   I  I  I    I  I    I  I   I I/   I
## |    I  ===== I    I    I I    I I   I  I  I    I  I    I  I   I I    I
## |    I  \     I    I    I I    I I   I  I  I   /I  \    I  I   I I    I
## |    I   ===   === I    I I    I  ===  ===  === I   ==  I   ===  I    I
## |                 +---------------------------------------------------+
## +----+            |  +++++++++++++++++++++++++++++++++++++++++++++++++|
##      |            |             ++++++++++++++++++++++++++++++++++++++|
##      +------------+                          +++++++++++++++++++++++++|
##                                                         ++++++++++++++|
##              A U T O M A T I O N     T E C H N O L O G Y         +++++|
##
################################################################################
## RISC-V workshop elf gcc project file
################################################################################

################################################################################
## Global
################################################################################

CROSS	= riscv32-unknown-elf
ISA		= RV32IM 

TARGET_DIR 	    = microsemi
BUILD_DIR 		= build
SRC_DIR 		= src
COMMON_DIR 		= common

CONFIG			= Makefile

################################################################################
## Project variables
################################################################################
TARGET 		= main
CTARGET		= main

LINK_FILE = $(TARGET_DIR)/arch/link.lds

# flags to trigger warning generation
WFLAGS = -Wall -Wextra -Wshadow -Wpointer-arith -Wbad-function-cast \
         -Wcast-align -Wsign-compare -Waggregate-return \
         -Wstrict-prototypes -Wmissing-prototypes \
         -Wmissing-declarations -Wunused \
         -Wimplicit -Wswitch -Wreturn-type #-Wredundant-decls 

DBG_FLAGS = -O0

AFLAGS =  -march=$(ISA) $(WFLAGS) $(DBG_FLAGS) -x assembler-with-cpp -c
CFLAGS =  -march=$(ISA) -fno-common -fno-inline -fno-jump-tables $(WFLAGS) $(DBG_FLAGS) -c
LFLAGS =  -march=$(ISA) -nostdlib -nostartfiles

AFLAGS += -fno-strict-aliasing -fno-builtin -D__gracefulExit
CFLAGS += -fomit-frame-pointer -fno-strict-aliasing -fno-builtin \
	    -D__gracefulExit	    

# FreeRTOS
FREERTOS_SOURCE_DIR = $(COMMON_DIR)/FreeRTOS/Source
FREERTOS_SRC = \
	$(FREERTOS_SOURCE_DIR)/croutine.c \
	$(FREERTOS_SOURCE_DIR)/list.c \
	$(FREERTOS_SOURCE_DIR)/queue.c \
	$(FREERTOS_SOURCE_DIR)/tasks.c \
	$(FREERTOS_SOURCE_DIR)/timers.c \
	$(FREERTOS_SOURCE_DIR)/event_groups.c \
	$(FREERTOS_SOURCE_DIR)/portable/MemMang/heap_2.c 
	
PORT_SRC = $(FREERTOS_SOURCE_DIR)/portable/GCC/RISCV-MSC/port.c
PORT_ASM = $(FREERTOS_SOURCE_DIR)/portable/GCC/RISCV-MSC/portasm.S

# application
APP_SRC = $(SRC_DIR)/main.c \
	$(SRC_DIR)/cmd_handler.c \
	$(SRC_DIR)/freertos_hooks.c \
	$(SRC_DIR)/tunnel.c \
	$(SRC_DIR)/blink_pwm.c \
	$(TARGET_DIR)/arch/led.c \
	$(TARGET_DIR)/arch/serial.c \
	$(TARGET_DIR)/arch/clib.c \
	$(TARGET_DIR)/arch/syscall.c \
	$(TARGET_DIR)/arch/init.c \
	$(TARGET_DIR)/arch/drivers/CoreUARTapb/core_uart_apb.c \
	$(TARGET_DIR)/arch/drivers/CoreGPIO/core_gpio.c \
	$(TARGET_DIR)/arch/drivers/CoreTimer/core_timer.c \
	$(TARGET_DIR)/arch/drivers_sifive/plic.c \
	$(TARGET_DIR)/arch/hal/hw_reg_access.c 

# support files
ASM_SOURCES = $(TARGET_DIR)/arch/entry.S $(PORT_ASM)
C_SOURCES 	= $(FREERTOS_SRC) $(PORT_SRC) $(APP_SRC)

LIBS 		= 
STD_LIBS	= -lc -lgcc

INCLUDE_DIRS = 	src \
				$(FREERTOS_SOURCE_DIR) \
				$(FREERTOS_SOURCE_DIR)/portable/GCC/RISCV-MSC \
				$(FREERTOS_SOURCE_DIR)/include \
				$(TARGET_DIR)/conf \
				$(TARGET_DIR)/arch \
				$(TARGET_DIR)/arch/drivers/CoreGPIO \
				$(TARGET_DIR)/arch/drivers/CoreUARTapb \
				$(TARGET_DIR)/arch/drivers/CoreTimer \
				$(TARGET_DIR)/arch/drivers_sifive \
				$(TARGET_DIR)/arch/hal \
				$(COMMON_DIR)/include

BUILD_DIRS  = $(sort $(addprefix $(BUILD_DIR)/,$(dir $(OBJS))) $(BUILD_DIR)/)
OBJS 		= $(ASM_SOURCES:.S=.o) $(C_SOURCES:.c=.o)

################################################################################
#### Default rules
################################################################################

    ############################################################################
    ## Phony targets
    ############################################################################
.PHONY: clean all code binary run

all: $(TARGET).elf  $(TARGET).ihx $(TARGET).nm $(TARGET).dump

clean: 
	@$(call print_cmd_info,"CLEANUP",$@)
	@$(RM) -r $(BUILD_DIR)
	@$(RM) $(LINT_REPORT)

test:
	echo $(BUILD_DIRS)

    ############################################################################
    ## surpress warnings generated in external provided files
    ############################################################################
%/core_uart_apb.o: CFLAGS += -Wno-unused-but-set-variable
%/plic.o: CFLAGS += -Wno-missing-prototypes -Wno-missing-declarations
%/hw_reg_access.o: CFLAGS += -Wno-missing-prototypes -Wno-missing-declarations

################################################################################
#### RISC-V GCC toolchain
################################################################################

include riscv-toolchain.mk