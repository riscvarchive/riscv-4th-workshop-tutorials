----------------------------------------------------------------------
-- Created by Microsemi SmartDesign Sat Jul  9 09:29:07 2016
-- Parameters for CLK_GEN
----------------------------------------------------------------------


LIBRARY ieee;
   USE ieee.std_logic_1164.all;
   USE ieee.std_logic_unsigned.all;
   USE ieee.numeric_std.all;

package coreparameters is
    constant CLK_PERIOD : integer := 32000000;
    constant DUTY_CYCLE : integer := 50;
end coreparameters;
