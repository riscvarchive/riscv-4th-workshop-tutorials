all:
AS_SRCS=crt.S

C_SRCS=
C_SRCS+=main.c
C_SRCS+=printf.c
C_SRCS+=mxp_test.c


C_OBJ_FILES=$(addprefix obj/,$(addsuffix .o, $(C_SRCS)))
S_OBJ_FILES=$(addprefix obj/,$(addsuffix .o, $(AS_SRCS)))

CROSS_COMPILE=riscv64-unknown-elf-
CC=$(CROSS_COMPILE)gcc
OBJCOPY=$(CROSS_COMPILE)objcopy
OBJDUMP=$(CROSS_COMPILE)objdump
ARCH=RV32IXmxp
CFLAGS= -m32 -O2 -fno-delete-null-pointer-checks -g -march=$(ARCH)  -MD -Wall -std=gnu99
LD_FLAGS= -m32 -march=$(ARCH) -static -nostartfiles

TARGET=test

$(C_OBJ_FILES) $(S_OBJ_FILES) : | obj/
obj/:
	mkdir -p obj/

$(C_OBJ_FILES): obj/%.c.o : %.c
	$(CC) $(CFLAGS) -c $< -o $@

$(S_OBJ_FILES): obj/%.S.o : %.S
	$(CC) $(CFLAGS) -c $< -o $@

LD_SCRIPT=link.ld
LIBC=

$(TARGET).elf: $(C_OBJ_FILES) $(S_OBJ_FILES) $(LD_SCRIPT)
	$(CC) -T $(LD_SCRIPT) $(S_OBJ_FILES)  $(C_OBJ_FILES)  -o $@ $(LD_FLAGS)
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
