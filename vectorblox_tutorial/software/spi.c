#include "spi.h"
#include "printf.h"

void SPI_set_ss(int slave) {
  *SPI_CONTROL1 = CTRL_ENABLE_MASTER_MASK; 
  // Set SS to LOW
  *SPI_SSEL &= (~(0x00000001 << slave));
  //*SPI_SSEL |= (0x00000001 << slave);
}

void SPI_clear_ss(int slave) {
  *SPI_INTCLR |= TX_DONE_INT_MASK;
  // Set SS to HIGH
  *SPI_SSEL |= (0x00000001 << slave);
  //*SPI_SSEL &= (~(0x00000001 << slave));
}

void SPI_transfer_block(const uint8_t *cmd_buffer, uint16_t cmd_byte_size, uint8_t *rd_buffer, uint16_t rd_byte_size) {

  uint32_t frame_count;
  uint32_t transfer_size;
  uint32_t done_flag = 0;

  /* Compute number of bytes to transfer. */
  transfer_size = cmd_byte_size + rd_byte_size;

  /* Adjust to 1 byte transfer to cater for DMA transfers. */
  if (transfer_size == 0)
  {
      transfer_size = 1;
  }
  frame_count = 0;  /* Use this to keep track of bytes transferred */

  /* CORESPI doesn't handle automatic transfer size handling, need to write the last byte
   * to the aliased TX register to indicate it is the last frame of the transfer
   */

  /* Flush the TX and RX FIFOs */
  *SPI_COMMAND |= (RX_FIFO_RESET_MASK | TX_FIFO_RESET_MASK); 

  while(!((*SPI_STATUS) & RX_FIFO_EMPTY_MASK)) {
    (void)*SPI_RXDATA;
  }

  /* Send over the command bytes */
  while(frame_count < cmd_byte_size) {
    while((*SPI_STATUS) & TX_FIFO_FULL_MASK);
    if (frame_count == (transfer_size-1)) {
      *SPI_TXDATALAST = cmd_buffer[frame_count++];
//      printf("Tx Last\r\n");
      /* done_flag is to handle command-only transactions */
      done_flag = 1;
    }
    else {
      *SPI_TXDATA = cmd_buffer[frame_count++];
    }
    while((*SPI_STATUS) & RX_FIFO_EMPTY_MASK);
    (void)*SPI_RXDATA;
  }
  /* No need to read to receive buffer in this case */
  if (done_flag) {
    return;
  }

  /* Read the expected number of bytes into the read buffer. */
  frame_count = 0;
  while(frame_count < rd_byte_size) {
    while((*SPI_STATUS) & TX_FIFO_FULL_MASK);
    if (frame_count == (rd_byte_size-1)) {
      *SPI_TXDATALAST = 0x00;
//      printf("Rx Last\r\n");
    }
    else {
      *SPI_TXDATA = 0x00;
    }
    while((*SPI_STATUS & RX_FIFO_EMPTY_MASK));
    rd_buffer[frame_count++] = *SPI_RXDATA;
  }

  /* Wait until transmission is done */
  while(!((*SPI_INTRAW) & TX_DONE_MASK));

}
