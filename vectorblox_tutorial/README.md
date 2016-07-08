# ORCA with MXP extensions

In this document ROOT shall represent the root of the archive provided.

## Memory Map

Since each peripheral does not actuall fill it's allotted space, it's address space is mirrorred as many times as necessary to fill the allotted space.

### Instruction
|Peripheral       | Address Range            |
|-----------------|---------------------------|
|instr BRAM       |0x0000 0000 - 0x0000 2000  |

### Data
|Peripheral        | Address Range            |
|-----------------|---------------------------|
|instr BRAM       |0x0000 0000 - 0x0000 2000  |
|eNVM*            |0x0000 2000 - 0x0FFF FFFF  |
|MXP Scratchpad   |0x1000 0000 - 0x1FFF FFFF  |
|MXP Instruction  |0x2000 0000 - 0x2FFF FFFF  |
|UART             |0x3000 0000 - 0x3FFF FFFF  |
|SPI              |0x4000 0000 - 0x4FFF FFFF  |
|i2s              |0x4500 0000 - 0x5FFF FFFF  |

\* Block Rams Hide the first 8kB of eNVM, and are initialized with the first 8kB of eNVM



## Sofware Generation

First set your path to use the correct risc-v toolchain. Run the command `source env.sh`

In ROOT/software you can run `make clean all`, this will eventually generate an intel-hex file named `test.hex`
that will be used to update the eNVM of the SmartFusion2 device.

## Programming Device

*Note to Guy: this part may be automated before we are done*

* Make sure your device is plugged in and your VM has control of the device.

* From the ROOT directory run `sh program.sh` to program the bitstream with the software.
