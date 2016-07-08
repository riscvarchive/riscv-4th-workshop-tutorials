----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09/04/2009 
-- Design Name:    Analog Interface FPGA	
-- Module Name:    shared_clocks - Behavioral 
-- Project Name: 	 tbd
-- Target Devices: tbd
-- Tool versions:  ISE 11.2
-- Description: Creates the MCLK, BICK, and LRCK clocks used
--						by both the ADC and DAC.
--
-- Revision: 
-- Revision 0.01 - 
-- 	090904	File Created
-- 	tbddate	tbd modifications Made
--
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity shared_clocks is
    Port ( 
			RESET 	    : in  STD_LOGIC; 	--Board Reset (active TBD?)
			mclk_clk    : in  STD_LOGIC;	-- MCLK input.
			bick 		: out  STD_LOGIC;	-- Bit Clocks
			lrck 		: out  STD_LOGIC -- Left Right Sample Rate Clock
			);	
end shared_clocks;

architecture Behavioral of shared_clocks is

----------------------------------------------
-- Start Signal / Constant Declarations:
----------------------------------------------

signal mclk_clk_cnt : std_logic_vector(15 downto 0) := (others => '0'); -- counter of mclk_clk for calcualtion of LRCK and BICK

----------------------------------------------
-- End Signal / Constant Declarations:
----------------------------------------------

begin
----------------------------------------------
-- Start Asynchronous Signals
----------------------------------------------


----------------------------------------------
-- End Asynchronous Signals
----------------------------------------------

----------------------------------------------
-- Start Asynchronous Processes
----------------------------------------------

-- MCLKclks_proc Description
-- Creates LRCK and BICK from MCLK.  LRCK = MCLK/128. BICK = MCLK/2.
-- LRCK is basically bit(6) of a MCLK count (tbd = possibly inverted)
-- BICLK is basically bit(0) of a MCLK count (tbd = possibly inverted)
MCLKclks_proc: process(mclk_clk)
begin  
   if (mclk_clk'event and mclk_clk = '1') then
      if RESET = '0' then
         mclk_clk_cnt <= (others => '0');
         bick <= '0';
         lrck <= '0';
      else
			mclk_clk_cnt <= mclk_clk_cnt + 1;
      end if;
		bick <= mclk_clk_cnt(8); 
		lrck <= mclk_clk_cnt(13); 
   end if;
end process MCLKclks_proc; 

----------------------------------------------
-- End Asynchronous Processes
----------------------------------------------

----------------------------------------------
--Start Port Mapping
----------------------------------------------

----------------------------------------------
--End Port Mapping
----------------------------------------------


end Behavioral;

