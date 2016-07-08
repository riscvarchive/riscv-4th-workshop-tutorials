#ifndef SPI_H
#define SPI_H

#include <stdint.h>

/* SPI Register Addresses */
#define SPI             ((volatile int*) (0x40000000))
#define SPI_CONTROL1    ((volatile int*) (0x40000000))
#define SPI_CONTROL2    ((volatile int*) (0x40000018))
#define SPI_RXDATA      ((volatile int*) (0x40000008))
#define SPI_TXDATA      ((volatile int*) (0x4000000C))
#define SPI_TXDATALAST  ((volatile int*) (0x40000028))  
#define SPI_COMMAND     ((volatile int*) (0x4000001C))
//#define SPI_SSEL        ((volatile int*) (0x40000024)) 
#define SPI_SSEL        ((volatile int*) (0x600000A0)) // GPIO SSEL
#define SPI_STATUS      ((volatile int*) (0x40000020))
#define SPI_INTRAW      ((volatile int*) (0x40000014))
#define SPI_INTCLR      ((volatile int*) (0x40000004))

/* SPI Bit Masks */
/* Control 1 Register */
#define CTRL_ENABLE_MASTER_MASK 0x00000003U
/* Command Register */
#define RX_FIFO_RESET_MASK      0x00000001U
#define TX_FIFO_RESET_MASK      0x00000002U
/* Status Register */
#define RX_FIFO_EMPTY_MASK      0x00000004U
#define TX_FIFO_FULL_MASK       0x00000008U
/* Interrupt Raw Register */
#define TX_DONE_MASK            0x00000001U
/* Interrupt Clear Register */
#define TX_DONE_INT_MASK        0x00000001U

void SPI_set_ss(int slave);
void SPI_clear_ss(int slave);
void SPI_transfer_block(const uint8_t *buffer, uint16_t cmd_byte_size, uint8_t *rd_buffer, uint16_t rd_byte_size);



#endif
