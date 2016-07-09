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
## RISC-V gcc toolchain make include file
################################################################################


################################################################################
#### Environment setup
################################################################################
    ############################################################################
    ## variables
    ############################################################################

VPATH += $(BUILD_DIR)/ $(BUILD_DIRS)

HEX_DATE        := $(shell date +0x%Y%m%d)
HEX_TIME        := $(shell date +0x%H%M%S)

CFLAGS += -D_BUILD_HEX_TIME_=$(HEX_TIME) -D_BUILD_HEX_DATE_=$(HEX_DATE)

.SUFFIXES:		#delete all known suffixes
.NOTPARALLEL:
    ############################################################################
    ## includes
    ############################################################################

    ############################################################################
    ## Functions
    ############################################################################
print_cmd_info		= printf "[%s] - %-20s : %s\n" `date +%H:%M:%S` $(1) $(2)
print_cmd_info_nonl	= printf "[%s] - %-20s : %s " `date +%H:%M:%S` $(1) $(2)

    ############################################################################
    ## Rules
    ############################################################################
	
$(BUILD_DIRS)	:
	@$(call print_cmd_info,"MK WORK DIR",$@)
	@mkdir -p $@

################################################################################
#### RISC-V GCC toolchain
################################################################################

    ############################################################################
    ## variables
    ############################################################################

AS		= $(CROSS)-as
LD		= $(CROSS)-ld
CPP		= $(CROSS)-cpp
CC		= $(CROSS)-gcc
OBJDUMP	= $(CROSS)-objdump
OBJCOPY	= $(CROSS)-objcopy
NM		= $(CROSS)-nm

    ############################################################################
    ## includes
    ############################################################################

ifneq ($(MAKECMDGOALS),clean)
-include $(OBJS:%.o=$(BUILD_DIR)/%.d)
endif

    ############################################################################
    ## Rules
    ############################################################################

$(BUILD_DIR)/%.d: %.c $(CONFIG) | $(BUILD_DIRS)
	@$(call print_cmd_info,"DEPEND",$@)
	@$(CC) $(CFLAGS) $(INCLUDE_DIRS:%=-I%) -MT $(<:c=o) -MM $< > $(@) || ($(RM) $(BUILD_DIR)/$(@); false)

$(BUILD_DIR)/%.d: %.s $(CONFIG) | $(BUILD_DIRS)
	@$(call print_cmd_info,"DEPEND",$@)
	@$(CC) $(CFLAGS) $(INCLUDE_DIRS:%=-I%) -MT $(<:s=o) -MM $< > $(@) || ($(RM) $(BUILD_DIR)/$(@); false)

$(BUILD_DIR)/%.d: %.S $(CONFIG) | $(BUILD_DIRS)
	@$(call print_cmd_info,"DEPEND",$@)
	@$(CC) $(CFLAGS) $(INCLUDE_DIRS:%=-I%) -MT $(<:S=o) -MM $< > $(@) || ($(RM) $(BUILD_DIR)/$(@); false)

%.o: %.c %.d $(CONFIG) | $(BUILD_DIRS)
	@$(call print_cmd_info,"COMPILE",$@)
	@$(CC) -Wa,-adhlns=$(BUILD_DIR)/$(*).lst $(INCLUDE_DIRS:%=-I%) $(CFLAGS) $< -o $(BUILD_DIR)/$(@)

%.o: %.s %.d $(CONFIG) | $(BUILD_DIRS)
	@$(call print_cmd_info,"ASSEMBLE",$@)
	@$(CC) -Wa,-adhlns=$(BUILD_DIR)/$(*).lst $(INCLUDE_DIRS:%=-I%) $(AFLAGS) $< -o $(BUILD_DIR)/$(@)

%.o: %.S %.d $(CONFIG) | $(BUILD_DIRS)
	@$(call print_cmd_info,"ASSEMBLE",$@)
	@$(CC) -Wa,-adhlns=$(BUILD_DIR)/$(*).lst $(INCLUDE_DIRS:%=-I%) $(AFLAGS) $< -o $(BUILD_DIR)/$(@)

%.elf: $(OBJS) $(LIBS) $(CONFIG) $(LINK_FILE) | $(BUILD_DIRS)
	@$(call print_cmd_info,"LINKING",$@)
	@$(CC) $(LFLAGS) -Wl,-T -Wl,$(LINK_FILE) -Wl,-Map=$(BUILD_DIR)/$(*F).map $(OBJS:%=$(BUILD_DIR)/%) $(LIBS)  $(STD_LIBS) -o $(BUILD_DIR)/$(@)

%.hex: %.elf $(CONFIG) | $(BUILD_DIRS)
	@$(call print_cmd_info,"GEN HEX",$@)
	@$(OBJCOPY) -O ihex $(BUILD_DIR)/$(<F) $(BUILD_DIR)/$(@F)

%.ihx: %.hex $(CONFIG) | $(BUILD_DIRS)
	@$(call print_cmd_info,"GEN IHX",$@)
	@tail -n +2 $(BUILD_DIR)/$(<F) > $(BUILD_DIR)/$(@F)

%.nm: %.elf $(CONFIG) | $(BUILD_DIRS)
	@$(call print_cmd_info,"GEN NM",$@)
	@$(NM) $(BUILD_DIR)/$(<F) > $(BUILD_DIR)/$(@F)

%.srec: %.elf $(CONFIG) | $(BUILD_DIRS)
	@$(call print_cmd_info,"GEN HEX",$@)
	@$(OBJCOPY) -O srec $(BUILD_DIR)/$(<F) $(BUILD_DIR)/$(@F)

%.bin: %.elf $(CONFIG) | $(BUILD_DIRS)
	@$(call print_cmd_info,"GEN BIN",$@)
	@$(OBJCOPY) -O binary $(BUILD_DIR)/$(<F) $(BUILD_DIR)/$(@F)

%.dump: %.elf $(BUILD_DIR_DEP) $(CONFIG)
	@$(call print_cmd_info,"GEN DUMP",$@)
	@$(OBJDUMP) --disassemble-all --disassemble-zeroes --section=.text --section=.rodata --section=.sbss --section=.sbss2 --section=.data  $(BUILD_DIR)/$(<F) > $(BUILD_DIR)/$(@F)

