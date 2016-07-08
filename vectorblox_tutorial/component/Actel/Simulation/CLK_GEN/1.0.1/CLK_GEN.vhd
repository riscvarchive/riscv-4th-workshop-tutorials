library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity CLK_GEN is
generic(CLK_PERIOD : integer := 10000 ;DUTY_CYCLE : integer := 50);

port( CLK : out std_logic := '0' );
end CLK_GEN;

architecture behave of CLK_GEN is
signal T1_time : time := 1 ps ;

begin

	process
	begin
	
		CLK <= '1';
		wait for (CLK_PERIOD*DUTY_CYCLE*T1_time/100.0);
		CLK <= '0';
		wait for ((CLK_PERIOD*T1_time)-(CLK_PERIOD*DUTY_CYCLE*T1_time/100.0));

	end process;
end behave;