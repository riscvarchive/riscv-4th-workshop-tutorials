all:
AS_SRCS=crt.S

C_SRCS=
C_SRCS+=main.c

C_SRCS+=spi.c
C_SRCS+=fir.c
C_SRCS+=mxp_test.c
C_SRCS+=vbx_api.c
C_SRCS+=vectorblox_mxp_riscv.c
C_SRCS+=arrow_zl380tw.c
C_SRCS+=arrow_zl380tw_firmware.c
C_SRCS+=arrow_zl380tw_config.c

PRINT_SRCS+=printf.c

C_OBJ_FILES=$(addprefix obj/,$(addsuffix .o, $(C_SRCS)))
PRINT_OBJ_FILES=$(addprefix obj/,$(addsuffix .o, $(PRINT_SRCS)))
S_OBJ_FILES=$(addprefix obj/,$(addsuffix .o, $(AS_SRCS)))

CROSS_COMPILE=riscv64-unknown-elf-
CC=$(CROSS_COMPILE)gcc
OBJCOPY=$(CROSS_COMPILE)objcopy
OBJDUMP=$(CROSS_COMPILE)objdump
ARCH=RV32IM
CFLAGS= -m32 -O2 -fno-delete-null-pointer-checks -g   -MD -Wall -std=gnu99
LD_FLAGS= -m32 -march=$(ARCH) -static -nostartfiles

TARGET=test

OBJS=$(C_OBJ_FILES) $(S_OBJ_FILES) $(PRINT_OBJ_FILES)
$(OBJS): | obj/

obj/:
	mkdir -p obj/
$(PRINT_OBJ_FILES): obj/%.c.o : %.c
	$(CC) $(CFLAGS) -march=RV32I -c $< -o $@

$(C_OBJ_FILES): obj/%.c.o : %.c
	$(CC) $(CFLAGS) -march=$(ARCH) -c $< -o $@

$(S_OBJ_FILES): obj/%.S.o : %.S
	$(CC) $(CFLAGS) -march=$(ARCH) -c $< -o $@

LD_SCRIPT=link.ld
LIBC=

$(TARGET).elf: $(OBJS) $(LD_SCRIPT)
	$(CC) -T $(LD_SCRIPT) $(OBJS)  -o $@ $(LD_FLAGS)
	$(OBJDUMP)   -D test.elf > test.dump
$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) -O binary $< $@
$(TARGET).hex: $(TARGET).elf
	$(OBJCOPY) -O ihex $< $@
$(TARGET).mem: $(TARGET).bin
	 head -c $$((0x100)) /dev/zero | cat - $< | xxd -g1 -c4 | awk '{print $$5$$4$$3$$2}' > $@

.phony:all clean
ifndef FORMAT
FORMAT=elf
endif
all: $(TARGET).$(FORMAT) $(TARGET).hex $(TARGET).mem

clean:
	rm -rf obj test.elf test.dump test.bin test.hex test.mif test.mem

-include $(wildcard obj/*.d)
