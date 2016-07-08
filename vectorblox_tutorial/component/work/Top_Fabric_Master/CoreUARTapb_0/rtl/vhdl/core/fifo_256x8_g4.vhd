-- ********************************************************************
-- Actel Corporation Proprietary and Confidential
--  Copyright 2008 Actel Corporation.  All rights reserved.
--
-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.
--
-- Description: COREUART/ CoreUARTapb UART core
--
--
--  Revision Information:
-- Date     Description
-- Jun09    Revision 4.1
-- Aug10    Revision 4.2

-- SVN Revision Information:
-- SVN $Revision: 8508 $
-- SVN $Date: 2009-06-15 16:49:49 -0700 (Mon, 15 Jun 2009) $
--
-- Resolved SARs
-- SAR      Date     Who   Description
-- 20741    2Sep10   AS    Increased baud rate by ensuring fifo ctrl runs off
--                         sys clk (not baud clock).  See note below.

-- Notes:
-- best viewed with tabstops set to "4"                    
library ieee;                                          
use ieee.std_logic_1164.all;                        
library smartfusion2;
                                                    
                                                        
                                                         
--smartfusion2 uses a fifo_128x8 
ENTITY Top_Fabric_Master_CoreUARTapb_0_fifo_256x8 IS
   GENERIC ( SYNC_RESET :  integer := 0);
   PORT (
      DO                      : OUT std_logic_vector(7 DOWNTO 0);   
      RCLOCK                  : IN std_logic;   
      WCLOCK                  : IN std_logic;   
      DI                      : IN std_logic_vector(7 DOWNTO 0);   
      WRB                     : IN std_logic;   
      RDB                     : IN std_logic;   
      RESET                   : IN std_logic;   
      FULL                    : OUT std_logic;   
      EMPTY                   : OUT std_logic);   
END ENTITY Top_Fabric_Master_CoreUARTapb_0_fifo_256x8;

ARCHITECTURE translated OF Top_Fabric_Master_CoreUARTapb_0_fifo_256x8 IS

   COMPONENT Top_Fabric_Master_CoreUARTapb_0_fifo_ctrl_128
      GENERIC (
          SYNC_RESET                     :  integer := 0;
          FIFO_BITS                      :  integer := 7;    --  Number of bits required to
          FIFO_WIDTH                     :  integer := 8;    --  Width of FIFO data
          FIFO_DEPTH                     :  integer := 128);    --  Depth of FIFO (number of bytes)
      PORT (
         clock                   : IN  std_logic;
         reset_n                 : IN  std_logic;
         data_in                 : IN  std_logic_vector(FIFO_WIDTH - 1 DOWNTO 0);
         read_n                  : IN  std_logic;
         write_n                 : IN  std_logic;
         LEVEL                   : IN  std_logic_vector(FIFO_BITS - 1 DOWNTO 0);
         data_out                : OUT std_logic_vector(FIFO_WIDTH - 1 DOWNTO 0);
         full                    : OUT std_logic;
         empty                   : OUT std_logic;
         half                    : OUT std_logic);
   END COMPONENT;


   CONSTANT  LEVEL                 :  std_logic_vector(6 DOWNTO 0) := "0100000";    
   SIGNAL AEMPTY                   :  std_logic;   
   SIGNAL AFULL                    :  std_logic;   
   SIGNAL DO_xhdl1                 :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL FULL_xhdl2               :  std_logic;   
   SIGNAL EMPTY_xhdl3              :  std_logic;   
   SIGNAL GEQTH                    :  std_logic;   

BEGIN
   DO <= DO_xhdl1;
   FULL <= FULL_xhdl2;
   EMPTY <= EMPTY_xhdl3;
   Top_Fabric_Master_CoreUARTapb_0_fifo_128x8_pa4 : Top_Fabric_Master_CoreUARTapb_0_fifo_ctrl_128
      GENERIC MAP(SYNC_RESET => SYNC_RESET)
      PORT MAP (
         data_in => DI,
         data_out => DO_xhdl1,
         write_n => WRB,
         read_n => RDB,
         clock => WCLOCK,
         full => FULL_xhdl2,
         empty => EMPTY_xhdl3,
         half => GEQTH,
         reset_n => RESET,
         LEVEL => LEVEL);   
   

END ARCHITECTURE translated;

--*******************************************************-- MODULE:		Synchronous FIFO
--
-- FILE NAME:	fifo_ctl.v
-- 
-- CODE TYPE:	Register Transfer Level
--
-- DESCRIPTION:	This module defines a Synchronous FIFO. The
-- FIFO memory is implemented as a ring buffer. The read
-- pointer points to the beginning of the buffer, while the
-- write pointer points to the end of the buffer. Note that
-- in this RTL version, the memory has one more location than
-- the FIFO needs in order to calculate the FIFO count
-- correctly.
--
--*******************************************************-- fifo control logic 
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;                          
library smartfusion2;
                       

ENTITY Top_Fabric_Master_CoreUARTapb_0_fifo_ctrl_128 IS
   GENERIC (
      SYNC_RESET                     :  integer := 0;
      FIFO_DEPTH                     :  integer := 128;    --  Depth of FIFO (number of bytes)
      FIFO_BITS                      :  integer := 7;    --  Number of bits required to
      FIFO_WIDTH                     :  integer := 8);    --  Width of FIFO data
   PORT (
      -- INPUTS

      clock                   : IN std_logic;   --  Clock input
      reset_n                 : IN std_logic;   --  Active low reset
      data_in                 : IN std_logic_vector(FIFO_WIDTH - 1 DOWNTO 0);   --  Data input to FIFO
      read_n                  : IN std_logic;   --  Read FIFO (active low)
      write_n                 : IN std_logic;   --  Write FIFO (active low)
      LEVEL                   : IN std_logic_vector(FIFO_BITS - 1 DOWNTO 0);   
      -- OUTPUTS

      data_out                : OUT std_logic_vector(FIFO_WIDTH - 1 DOWNTO 0);   --  FIFO output data
      full                    : OUT std_logic;   --  FIFO is full
      empty                   : OUT std_logic;   --  FIFO is empty
      half                    : OUT std_logic);   --  FIFO is half full
END ENTITY Top_Fabric_Master_CoreUARTapb_0_fifo_ctrl_128;

ARCHITECTURE translated OF Top_Fabric_Master_CoreUARTapb_0_fifo_ctrl_128 IS

   COMPONENT Top_Fabric_Master_CoreUARTapb_0_ram128x8_pa4
      PORT (
         Data                    : IN  std_logic_vector(7 DOWNTO 0);
         Q                       : OUT std_logic_vector(7 DOWNTO 0);
         WAddress                : IN  std_logic_vector(6 DOWNTO 0);
         RAddress                : IN  std_logic_vector(6 DOWNTO 0);
         WE                      : IN  std_logic;
         WClock                  : IN  std_logic;
         reset_n                 : IN  std_logic;
         RClock                  : IN  std_logic);
   END COMPONENT;


   -- or more
   -- INOUTS
   -- SIGNAL DECLARATIONS
   SIGNAL data_out_0               :  std_logic_vector(FIFO_WIDTH - 1 DOWNTO 0);   
   SIGNAL read_n_hold              :  std_logic;   
   -- How many locations in the FIFO
   -- are occupied?
   SIGNAL counter                  :  std_logic_vector(FIFO_BITS - 1 DOWNTO 0);   
   -- FIFO read pointer points to
   -- the location in the FIFO to
   -- read from next
   SIGNAL rd_pointer               :  std_logic_vector(FIFO_BITS - 1 DOWNTO 0);   
   -- FIFO write pointer points to
   -- the location in the FIFO to
   -- write to next
   SIGNAL wr_pointer               :  std_logic_vector(FIFO_BITS - 1 DOWNTO 0);   
   -- PARAMETERS
   -- ASSIGN STATEMENTS
   SIGNAL temp_xhdl5               :  std_logic;   
   SIGNAL temp_xhdl6               :  std_logic;   
   SIGNAL temp_xhdl7               :  std_logic;   
   SIGNAL data_out_xhdl1           :  std_logic_vector(FIFO_WIDTH - 1 DOWNTO 0);   
   SIGNAL full_xhdl2               :  std_logic;   
   SIGNAL empty_xhdl3              :  std_logic;   
   SIGNAL half_xhdl4               :  std_logic;   
   SIGNAL aresetn                  :  std_logic;
   SIGNAL sresetn                  :  std_logic;

BEGIN
   aresetn <= '1' WHEN (SYNC_RESET=1) ELSE reset_n;
   sresetn <= reset_n WHEN (SYNC_RESET=1) ELSE '1';
   data_out <= data_out_xhdl1;
   full <= full_xhdl2;
   empty <= empty_xhdl3;
   half <= half_xhdl4;
   temp_xhdl5 <= '1' WHEN (counter = CONV_STD_LOGIC_VECTOR(FIFO_DEPTH - 1, 7)) ELSE '0';
   full_xhdl2 <= temp_xhdl5 ;
   temp_xhdl6 <= '1' WHEN (counter = "0000000") ELSE '0';
   empty_xhdl3 <= temp_xhdl6 ;
   temp_xhdl7 <= '1' WHEN (counter >= LEVEL) ELSE '0';
   half_xhdl4 <= temp_xhdl7 ;

   -- MAIN CODE
   -- This block contains all devices affected by the clock 
   -- and reset inputs
   
   PROCESS (clock, aresetn)
   BEGIN
      IF (NOT aresetn = '1') THEN
         -- Reset the FIFO pointer
         rd_pointer <= (OTHERS => '0');    
         wr_pointer <= (OTHERS => '0');    
         counter <= (OTHERS => '0');    
      ELSIF (clock'EVENT AND clock = '1') THEN
        IF (NOT sresetn = '1') THEN
           -- Reset the FIFO pointer
           rd_pointer <= (OTHERS => '0');    
           wr_pointer <= (OTHERS => '0');    
           counter <= (OTHERS => '0');    
	    ELSE
	    
           IF (NOT read_n = '1') THEN
              -- If we are doing a simultaneous read and write,
              -- there is no change to the counter
              
              IF (write_n = '1') THEN
                 -- Decrement the FIFO counter
                 
                 counter <= counter - "0000001";    
              END IF;
              -- Increment the read pointer
              -- Check if the read pointer has gone beyond the
              -- depth of the FIFO. If so, set it back to the
              -- beginning of the FIFO
              
              IF (rd_pointer = CONV_STD_LOGIC_VECTOR(FIFO_DEPTH - 1, 7)) 
              THEN
                 rd_pointer <= (OTHERS => '0');    
              ELSE
                 rd_pointer <= rd_pointer + "0000001";    
              END IF;
           END IF;
           IF (NOT write_n = '1') THEN
              -- If we are doing a simultaneous read and write,
              -- there is no change to the counter
              
              IF (read_n = '1') THEN
                 -- Increment the FIFO counter
                 
                 counter <= counter + "0000001";    
              END IF;
              -- Increment the write pointer
              -- Check if the write pointer has gone beyond the
              -- depth of the FIFO. If so, set it back to the
              -- beginning of the FIFO
              
              IF (wr_pointer = CONV_STD_LOGIC_VECTOR(FIFO_DEPTH - 1, 7)) 
              THEN
                 wr_pointer <= (OTHERS => '0');    
              ELSE
                 wr_pointer <= wr_pointer + "0000001";    
              END IF;
           END IF;
        END IF;
      END IF;
   END PROCESS;

   PROCESS (clock, aresetn)
   BEGIN
      IF (NOT aresetn = '1') THEN
         read_n_hold <= '0';    
      ELSIF (clock'EVENT AND clock = '1') THEN
         IF (NOT sresetn = '1') THEN
            read_n_hold <= '0';    
	     ELSE
            read_n_hold <= read_n;    
            IF (read_n_hold = '0') THEN
               data_out_xhdl1 <= data_out_0;    
            ELSE
               data_out_xhdl1 <= data_out_xhdl1;    
            END IF;
         END IF;
      END IF;
   END PROCESS;
   ram128_8_pa4 : Top_Fabric_Master_CoreUARTapb_0_ram128x8_pa4 
      PORT MAP (
         Data => data_in,
         Q => data_out_0,
         WAddress => wr_pointer,
         RAddress => rd_pointer,
         WE => write_n,
         reset_n => reset_n,
         WClock => clock,
         RClock => clock);   
   

END ARCHITECTURE translated;


library ieee;
use ieee.std_logic_1164.all;
library smartfusion2;        

ENTITY Top_Fabric_Master_CoreUARTapb_0_ram128x8_pa4 IS
   PORT (
      Data                    : IN std_logic_vector(7 DOWNTO 0);   
      Q                       : OUT std_logic_vector(7 DOWNTO 0);   
      WAddress                : IN std_logic_vector(6 DOWNTO 0);   
      RAddress                : IN std_logic_vector(6 DOWNTO 0);   
      WE                      : IN std_logic;    
      reset_n                 : IN  std_logic;  
      WClock                  : IN std_logic;   
      RClock                  : IN std_logic);   
END ENTITY Top_Fabric_Master_CoreUARTapb_0_ram128x8_pa4;

ARCHITECTURE translated OF Top_Fabric_Master_CoreUARTapb_0_ram128x8_pa4 IS

    component INV
        port(A : in std_logic := 'U'; Y : out std_logic) ;
    end component;

COMPONENT RAM64x18
  port(
                             A_DOUT : out   STD_LOGIC_VECTOR(17 downto 0);
                             B_DOUT : out   STD_LOGIC_VECTOR(17 downto 0);
                               BUSY : out   STD_LOGIC;
                         A_ADDR_CLK : in    STD_LOGIC;
                         A_DOUT_CLK : in    STD_LOGIC;
                      A_ADDR_SRST_N : in    STD_LOGIC;
                      A_DOUT_SRST_N : in    STD_LOGIC;
                      A_ADDR_ARST_N : in    STD_LOGIC;
                      A_DOUT_ARST_N : in    STD_LOGIC;
                          A_ADDR_EN : in    STD_LOGIC;
                          A_DOUT_EN : in    STD_LOGIC;
                              A_BLK : in    STD_LOGIC_VECTOR(1 downto 0);
                             A_ADDR : in    STD_LOGIC_VECTOR(9 downto 0);
                         B_ADDR_CLK : in    STD_LOGIC;
                         B_DOUT_CLK : in    STD_LOGIC;
                      B_ADDR_SRST_N : in    STD_LOGIC;
                      B_DOUT_SRST_N : in    STD_LOGIC;
                      B_ADDR_ARST_N : in    STD_LOGIC;
                      B_DOUT_ARST_N : in    STD_LOGIC;
                          B_ADDR_EN : in    STD_LOGIC;
                          B_DOUT_EN : in    STD_LOGIC;
                              B_BLK : in    STD_LOGIC_VECTOR(1 downto 0);
                             B_ADDR : in    STD_LOGIC_VECTOR(9 downto 0);
                              C_CLK : in    STD_LOGIC;
                             C_ADDR : in    STD_LOGIC_VECTOR(9 downto 0);
                              C_DIN : in    STD_LOGIC_VECTOR(17 downto 0);
                              C_WEN : in    STD_LOGIC;
                              C_BLK : in    STD_LOGIC_VECTOR(1 downto 0);
                               A_EN : in    STD_LOGIC;
                         A_ADDR_LAT : in    STD_LOGIC;
                         A_DOUT_LAT : in    STD_LOGIC;
                            A_WIDTH : in    STD_LOGIC_VECTOR(2 downto 0);
                               B_EN : in    STD_LOGIC;
                         B_ADDR_LAT : in    STD_LOGIC;
                         B_DOUT_LAT : in    STD_LOGIC;
                            B_WIDTH : in    STD_LOGIC_VECTOR(2 downto 0);
                               C_EN : in    STD_LOGIC;
                            C_WIDTH : in    STD_LOGIC_VECTOR(2 downto 0);
                           SII_LOCK : in    STD_LOGIC
  );
END COMPONENT;

    component VCC
        port( Y : out std_logic);
    end component;

    component GND
        port( Y : out std_logic);
    end component;

   SIGNAL INV_1_Y                  :  std_logic;   
   SIGNAL INV_0_Y                  :  std_logic;   
   SIGNAL VCC_0                    :  std_logic;   
   SIGNAL GND_0                    :  std_logic;   
   SIGNAL DOUT_RAM_0               :  std_LOGIC_vector(17 DOWNTO 0);
   SIGNAL A_ADDR_int               :  std_LOGIC_vector(9 DOWNTO 0);
   SIGNAL C_ADDR_int               :  std_LOGIC_vector(9 DOWNTO 0);
   SIGNAL C_DIN_int                :  std_LOGIC_vector(17 DOWNTO 0);

BEGIN
   VCC_1_net : VCC 
      PORT MAP (
         Y => VCC_0);   
   
   GND_1_net : GND 
      PORT MAP (
         Y => GND_0);   
    
   INV_0 : INV 
      PORT MAP (
         A => WE,
         Y => INV_0_Y); 
 
Q <= DOUT_RAM_0(7 downto 0);
A_ADDR_int <= RAddress & "000";
C_ADDR_int <= WAddress & "000";
C_DIN_int <= "0000000000" & Data;


RAM_128x8_Q_0_inst : RAM64x18  
    PORT MAP( 
                A_DOUT => DOUT_RAM_0,
                B_DOUT => open, 
                BUSY => open, 
                A_ADDR_CLK => RClock, 
                A_DOUT_CLK => VCC_0,
                A_ADDR_SRST_N => VCC_0,
                A_DOUT_SRST_N => VCC_0, 
                A_ADDR_ARST_N => VCC_0, 
                A_DOUT_ARST_N => VCC_0,
                A_ADDR_EN => VCC_0, 
                A_DOUT_EN => VCC_0,
                A_BLK => "11",
                A_ADDR => A_ADDR_int, 
                B_ADDR_CLK => VCC_0, 
                B_DOUT_CLK => VCC_0,
                B_ADDR_SRST_N => VCC_0, 
                B_DOUT_SRST_N => VCC_0, 
                B_ADDR_ARST_N => VCC_0, 
                B_DOUT_ARST_N => VCC_0, 
                B_ADDR_EN => VCC_0, 
                B_DOUT_EN => VCC_0, 
                B_BLK => "00",
                B_ADDR => "0000000000", 
                C_CLK => WClock,
                C_ADDR => C_ADDR_int,
                C_DIN => C_DIN_int,
                C_WEN => INV_0_Y,
                C_BLK => "11",
                A_EN => VCC_0,
                A_ADDR_LAT => GND_0, 
                A_DOUT_LAT => VCC_0,
                B_EN => GND_0, 
                B_ADDR_LAT => GND_0, 
                B_DOUT_LAT => VCC_0, 
                C_EN => VCC_0, 
                A_WIDTH => "011",
                B_WIDTH => "011",
                C_WIDTH => "011",
                SII_LOCK => GND_0);
   
END ARCHITECTURE translated;
