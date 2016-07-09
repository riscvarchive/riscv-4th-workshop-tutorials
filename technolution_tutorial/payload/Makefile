################################################################################
##
## (C) COPYRIGHT 2016 TECHNOLUTION BV, GOUDA NL
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
##                                                                  +++++|
##
################################################################################
## RISC-V workshop elf gcc project file
################################################################################

################################################################################
## Global
################################################################################

CROSS	= riscv32-unknown-elf
ISA		= RV32IM 

BUILD_DIR 		= build

CONFIG			= Makefile

EXPLOIT_BUILDER	= ../tools/exploit_tools/exploit_builder.py
LINK_GENERATOR 	= ../tools/exploit_tools/link_generator.py

################################################################################
## Project variables
################################################################################
TARGET 		= payload
CTARGET		= payload

LINK_FILE = link.ld

# flags to trigger warning generation
WFLAGS = -Wall -Wextra -Wshadow -Wpointer-arith -Wbad-function-cast \
         -Wcast-align -Wsign-compare -Waggregate-return \
         -Wstrict-prototypes -Wno-implicit-function-declaration \
         -Wmissing-declarations -Wunused \
         -Wimplicit -Wswitch -Wreturn-type #-Wredundant-decls  -Wmissing-prototypes 

DBG_FLAGS = -O0

AFLAGS =  -march=$(ISA) $(WFLAGS) $(DBG_FLAGS) -x assembler-with-cpp -c
CFLAGS =  -march=$(ISA) $(WFLAGS) $(DBG_FLAGS) -c
LFLAGS =  -march=$(ISA) -nostartfiles -static

AFLAGS += -fno-strict-aliasing -fno-builtin -D__gracefulExit
CFLAGS += -fomit-frame-pointer -fno-strict-aliasing -fno-builtin \
	    -D__gracefulExit	    

# application
# support files
ASM_SOURCES = 
C_SOURCES   = c_payload.c
			  

LIBS 		=
STD_LIBS	=

INCLUDE_DIRS 	= 	

BUILD_DIRS  = $(sort $(addprefix $(BUILD_DIR)/,$(dir $(OBJS))) $(BUILD_DIR)/)
OBJS 		= $(ASM_SOURCES:.S=.o) $(C_SOURCES:.c=.o)

################################################################################
#### Rules
################################################################################

    ############################################################################
    ## Phony targets
    ############################################################################
.PHONY: clean all code binary

all: $(TARGET).elf $(TARGET).bin $(TARGET).dump

clean: 
	@$(call print_cmd_info,"CLEANUP",$@)
	@$(RM) -r $(BUILD_DIR)
	@$(RM) $(LINT_REPORT)

test:
	echo $(BUILD_DIRS)

    ############################################################################
    ## file based targets
    ############################################################################
$(LINK_FILE): $(BUILD_DIR)/exploit.ld

$(BUILD_DIR)/exploit.ld: $(BUILD_DIR)/main.nm $(LINK_GENERATOR)
	@$(call print_cmd_info,"MK LINKER SCRIPT", $@)
	@$(LINK_GENERATOR) -n $< -o $@
	
$(BUILD_DIR)/main.nm: ../appl/build/main.elf 
	@$(call print_cmd_info,"MK SYMBOL FILE", $@)
	@$(NM) $(<) > $(@)
	
../appl/build/main.elf:
	

################################################################################
#### RISC-V GCC toolchain
################################################################################

include ../appl/riscv-toolchain.mk


