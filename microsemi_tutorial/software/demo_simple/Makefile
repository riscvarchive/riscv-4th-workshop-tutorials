
C_DEFINES = -DUSE_PLIC

TARGET = demo_simple

ASM_SRCS += ./entry.S

C_SRCS += ./hal/hw_reg_access.c
C_SRCS += ./init.c
C_SRCS += ./syscall.c
C_SRCS += ./drivers/CoreGPIO/core_gpio.c
C_SRCS += ./drivers/CoreUARTapb/core_uart_apb.c
C_SRCS += ./drivers/CoreTimer/core_timer.c
C_SRCS += ./drivers_sifive/plic.c

LINKER_SCRIPT := ./link.lds
#LINKER_SCRIPT := ./all-ram.lds
#LINKER_SCRIPT := ./debug-link.lds

HEADERS += ./hal/*.h
HEADERS += ./drivers/*/*.h
HEADERS += ./*.h

C_SRCS += $(TARGET).c
INCLUDES += -I.
INCLUDES += -I./drivers/CoreGPIO
INCLUDES += -I./drivers/CoreUARTapb
INCLUDES += -I./drivers/CoreTimer
INCLUDES += -I./drivers_sifive/
INCLUDES += -I./hal

ASM_OBJS := $(patsubst %.S,%.o,$(ASM_SRCS))
C_OBJS := $(patsubst %.c,%.o,$(C_SRCS))

CC := riscv32-unknown-elf-gcc
CFLAGS := -Og -g -march=RV32IM -fno-common -fno-jump-tables $(INCLUDES) $(C_DEFINES)
LDFLAGS := -T $(LINKER_SCRIPT) -nostdlib -nostartfiles -lc -lgcc
LDFLAGS += -L$.
LDFLAGS += -L$./drivers
LDFLAGS += -L$./hal

#RUN := spike --isa=RV32IM

#run: $(TARGET)
#	$(RUN) $<

$(TARGET): $(ASM_OBJS) $(C_OBJS) $(LINKER_SCRIPT)
	$(CC) $(CFLAGS) $(C_OBJS) -o $@ $(LDFLAGS)

$(ASM_OBJS): %.o: %.S $(HEADERS)
	$(CC) $(CFLAGS) -c -o $@ $<

$(C_OBJS): %.o: %.c $(HEADERS)
	$(CC) $(CFLAGS) -c -o $@ $<

ELF_TO_IHEX = objcopy -O ihex --set-start 0

$(TARGET).ihx: $(TARGET)
	$(ELF_TO_IHEX) $(TARGET) $(TARGET).tmp
	tail -n +2 $(TARGET).tmp > $(TARGET).ihx

default: $(TARGET).ihx

all: default

clean:
	rm -f $(TARGET) *.o *.ihx ./*.o ./drivers/*/*.o ./hal/*.o  ./drivers_sifive/*.o

.PHONY: clean all default
