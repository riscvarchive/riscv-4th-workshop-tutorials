--
-- Copyright Notice and Proprietary Information
--
-- Copyright (C) 1997-2000 X-Tek Corporation. All rights reserved. This Software 
-- and documentation are owned by X-Tek Corporation, and may be used only as 
-- authorized in the license agreement controlling such use. No part of this 
-- publication may be reproduced, transmitted, or translated, in any form or by 
-- any means, electronic, mechanical, manual, optical, or otherwise, without prior 
-- written permission of X-Tek Corporation, or as expressly provided by the license 
-- agreement.
--
-- Disclaimer
--
-- X-Tek Corporation makes no warranty of any kind, express or implied, with regard 
-- to this material, including, but not limited to, the implied warranties of 
-- merchantability and fitness for a particular purpose.
--
-- X-Tek Corporation reserves the right to make changes without further notice to 
-- the products described herein. X-Tek Corporation does not assume any liability 
-- arising out of the application or use of any product or circuit described 
-- herein. The X-Tek products described herein are not authorized for use as 
-- components in life-support devices.
--
--
-- Rev 2001.0226
--
-- Rev 2001.0324
--    a) Added function    
--          FUNCTION conv_std_logic_vector (
--             val      : IN boolean;
--             len      : IN integer) RETURN std_logic_vector;
--
--

LIBRARY ieee;
USE ieee.std_logic_1164.all;
LIBRARY std;
USE std.textio.all;

PACKAGE xhdl_std_logic IS

   FUNCTION to_stdlogic (
      val      : IN boolean) RETURN std_logic;
      
   FUNCTION conv_std_logic (
      val      : IN boolean) RETURN std_logic;
      
   FUNCTION conv_std_logic (
      val      : IN integer) RETURN std_logic;
      
   FUNCTION conv_std_logic_vector (
      val      : IN boolean;
      len      : IN integer) RETURN std_logic_vector;
     
   FUNCTION conv_std_logic_vector (
      val      : IN integer;
      len      : IN integer) RETURN std_logic_vector;
     
   FUNCTION to_stdlogicvector (
      val      : IN integer;
      len      : IN integer) RETURN std_logic_vector;

   FUNCTION to_stdlogicvector (
      val      : IN boolean;
      len      : IN integer) RETURN std_logic_vector;

   FUNCTION to_integer (
      val      : std_logic_vector) RETURN integer;
      
   FUNCTION "SRL" (
      l        : std_logic_vector;
      r        : integer) RETURN std_logic_vector;
   
   FUNCTION ShiftRight (
      val      : std_logic_vector;
      shft     : integer) RETURN std_logic_vector;
   
   FUNCTION "SLL" (
      l        : std_logic_vector;
      r        : integer) RETURN std_logic_vector;
   
   FUNCTION ShiftLeft (
      val      : std_logic_vector;
      shft     : integer) RETURN std_logic_vector;
   
   FUNCTION "+" (
      l        : std_logic;
      r        : std_logic) RETURN std_logic_vector;
   
   --    
   FUNCTION or_br (
      val : std_logic_vector) RETURN std_logic;
   
   FUNCTION and_br (
      val : std_logic_vector) RETURN std_logic;

   FUNCTION xor_br (
      val : std_logic_vector) RETURN std_logic;

   FUNCTION xnor_br (
      val : std_logic_vector) RETURN std_logic;

   FUNCTION nor_br (
      val : std_logic_vector) RETURN std_logic;

   FUNCTION nand_br (
      val : std_logic_vector) RETURN std_logic;

   FUNCTION to_time (
      val : std_logic_vector) RETURN time;
   
   FUNCTION to_string (
       val : std_logic_vector) RETURN string;

   FUNCTION to_octstring (
      val      : IN std_logic_vector) RETURN string;

   FUNCTION to_decstring (
      val      : IN std_logic_vector) RETURN string;

   FUNCTION to_hexstring (
      val      : IN std_logic_vector) RETURN string;
END;

PACKAGE BODY xhdl_std_logic IS

   --
   -- internally used functions
   --
   FUNCTION make_string (
      val      : integer;
      size     : integer) RETURN string is
     
      VARIABLE r     : integer := val;
      VARIABLE digit   : integer;
      VARIABLE rtn   : string(size DOWNTO 1);
   BEGIN
      FOR index IN 1 TO size LOOP
         digit := r REM 10;
         r := r/10;
         CASE digit IS
            WHEN 0   => rtn(index) := '0';
            WHEN 1   => rtn(index) := '1';
            WHEN 2   => rtn(index) := '2';
            WHEN 3   => rtn(index) := '3';
            WHEN 4   => rtn(index) := '4';
            WHEN 5   => rtn(index) := '5';
            WHEN 6   => rtn(index) := '6';
            WHEN 7   => rtn(index) := '7';
            WHEN 8   => rtn(index) := '8';
            WHEN 9   => rtn(index) := '9';
            WHEN OTHERS => rtn(index) := 'X';
         END CASE;
      END LOOP;
      RETURN(rtn);
   END make_string;

   --
   --
   --

   FUNCTION to_stdlogic (
      val      : IN boolean) RETURN std_logic IS
   BEGIN
      IF (val) THEN
         RETURN('1');
      ELSE
         RETURN('0');
      END IF;
   END to_stdlogic;
   
   FUNCTION conv_std_logic (
      val      : IN boolean) RETURN std_logic IS
   BEGIN
      RETURN(to_stdlogic(val));
   END conv_std_logic;

   FUNCTION conv_std_logic (
      val      : IN integer) RETURN std_logic IS
   BEGIN
      IF (val = 1) THEN
         RETURN('1');
      ELSE
         RETURN('0');
      END IF;
   END conv_std_logic;

   FUNCTION conv_std_logic_vector (
      val      : IN boolean;
      len      : IN integer) RETURN std_logic_vector IS
      
      VARIABLE rtn      : std_logic_vector(len-1 DOWNTO 0) := (OTHERS => '0');
      VARIABLE b        : std_logic;
   BEGIN
      IF (val) THEN
         b := '1';
      ELSE
         b := '0';
      END IF;
      FOR index IN 0 TO len-1 LOOP
         rtn(index) := b;
      END LOOP;
	   RETURN(rtn);
	END conv_std_logic_vector;

   FUNCTION conv_std_logic_vector (
      val      : IN integer;
      len      : IN integer) RETURN std_logic_vector IS
   BEGIN
	   RETURN(to_stdlogicvector(val, len));
	END conv_std_logic_vector;

   --
   
   FUNCTION to_stdlogicvector (
      val      : IN integer;
      len      : IN integer) RETURN std_logic_vector IS
      
      VARIABLE rtn      : std_logic_vector(len-1 DOWNTO 0) := (OTHERS => '0');
      VARIABLE num  : integer := val;
      VARIABLE r       : integer;
   BEGIN
      FOR index IN 0 TO len-1 LOOP
         r := num rem 2;
         num := num/2;
         IF (r = 1) THEN
            rtn(index) := '1';
         ELSE
            rtn(index) := '0';
         END IF;
      END LOOP;
      RETURN(rtn);
   END to_stdlogicvector;
         
   --   
         
   FUNCTION to_stdlogicvector (
      val      : IN boolean;
      len      : IN integer) RETURN std_logic_vector IS
      
      VARIABLE rtn      : std_logic_vector(len-1 DOWNTO 0) := (OTHERS => '0');
   BEGIN
      rtn(0) := to_stdlogic(val);
      RETURN(rtn);
   END to_stdlogicvector;

   --
         
      
  FUNCTION to_integer (
      val      : std_logic_vector) RETURN integer IS

      CONSTANT vec      : std_logic_vector(val'high-val'low DOWNTO 0) := val;      
      VARIABLE rtn      : integer := 0;
   BEGIN
      FOR index IN vec'RANGE LOOP
         IF (vec(index) = '1') THEN
            rtn := rtn + (2**index);
         END IF;
      END LOOP;
      RETURN(rtn);
   END to_integer;
                  
   --
   FUNCTION "SRL" (
      l        : std_logic_vector;
      r        : integer) RETURN std_logic_vector IS
   BEGIN
      RETURN(ShiftRight(l, r));
   END "SRL";
   
   FUNCTION ShiftRight (
      val      : std_logic_vector;
      shft     : integer) RETURN std_logic_vector IS
      
      VARIABLE int      : std_logic_vector(val'LENGTH+shft-1 DOWNTO 0);
      VARIABLE rtn      : std_logic_vector(val'RANGE);
      VARIABLE fill     : std_logic_vector(shft-1 DOWNTO 0) := (others => '0');
   BEGIN
      int := fill & val;
      rtn := int(val'LENGTH+shft-1 DOWNTO shft);
      RETURN(rtn);
   END ShiftRight;            
      
   --

   FUNCTION "SLL" (
      l        : std_logic_vector;
      r        : integer) RETURN std_logic_vector IS
   BEGIN
      RETURN(ShiftLeft(l, r));
   END "SLL";
   
   FUNCTION ShiftLeft (
      val      : std_logic_vector;
      shft     : integer) RETURN std_logic_vector IS
      
      VARIABLE int      : std_logic_vector(val'LENGTH+shft-1 DOWNTO 0);
      VARIABLE rtn      : std_logic_vector(val'RANGE);
      VARIABLE fill     : std_logic_vector(shft-1 DOWNTO 0) := (others => '0');
   BEGIN
      int := val & fill;
      rtn := int(val'LENGTH-1 DOWNTO 0);
      RETURN(rtn);
   END ShiftLeft;            
   
   FUNCTION "+" (
      l        : std_logic;
      r        : std_logic) RETURN std_logic_vector IS
      
      VARIABLE rtn      : std_logic_vector(1 downto 0);
      VARIABLE tmp      : std_logic_vector(1 downto 0);
   BEGIN
      tmp := l & r;
      CASE tmp IS
         WHEN "00"   => rtn := "00";
         WHEN "01"   => rtn := "01";
         WHEN "10"   => rtn := "01";
         WHEN "11"   => rtn := "10";
         WHEN OTHERS => rtn := "XX";
      END CASE;
      RETURN(rtn);
   END "+";
      
   --   

 FUNCTION or_br (
      val : std_logic_vector) RETURN std_logic IS
   
      VARIABLE rtn : std_logic := '0';
   BEGIN
      FOR index IN val'RANGE LOOP
         rtn := rtn OR val(index);
      END LOOP;
      RETURN(rtn);
   END or_br;

   --
   
   FUNCTION and_br (
      val : std_logic_vector) RETURN std_logic IS

      VARIABLE rtn : std_logic := '1';
   BEGIN
      FOR index IN val'RANGE LOOP
         rtn := rtn AND val(index);
      END LOOP;
      RETURN(rtn);
   END and_br;

   --
   
   FUNCTION xor_br (
      val : std_logic_vector) RETURN std_logic IS

      VARIABLE rtn : std_logic := '0';
   BEGIN
      FOR index IN val'RANGE LOOP
         rtn := rtn XOR val(index);
      END LOOP;
      RETURN(rtn);
   END xor_br;

   --
   
   FUNCTION xnor_br (
      val : std_logic_vector) RETURN std_logic IS

      VARIABLE rtn : std_logic := '0';
   BEGIN
      FOR index IN val'RANGE LOOP
         rtn := rtn XOR val(index);
      END LOOP;
      RETURN(NOT rtn);
   END xnor_br;

   --

   FUNCTION nor_br (
      val : std_logic_vector) RETURN std_logic IS

      VARIABLE rtn : std_logic := '0';
   BEGIN
      FOR index IN val'RANGE LOOP
         rtn := rtn OR val(index);
      END LOOP;
      RETURN(NOT rtn);
   END nor_br;

   --

   FUNCTION nand_br (
      val : std_logic_vector) RETURN std_logic IS

      VARIABLE rtn : std_logic := '0';
   BEGIN
      FOR index IN val'RANGE LOOP
         rtn := rtn AND val(index);
      END LOOP;
      RETURN(NOT rtn);
   END nand_br;

   --
   
   FUNCTION to_time (
      val : std_logic_vector) RETURN time IS
   
      VARIABLE rtn : time;
   BEGIN
      rtn := to_integer(val) * 1 ns;
      RETURN(rtn);
   END to_time;
   
   --

   FUNCTION to_string (
       val : std_logic_vector) RETURN string IS

      VARIABLE rtn   : string(1 TO val'LENGTH);
      ALIAS normal    : std_logic_vector(1 to val'LENGTH) IS val;
  BEGIN
       FOR index IN normal'RANGE LOOP
        CASE normal(index) IS
            WHEN '0' => rtn(index) := '0';
            WHEN 'L' => rtn(index) := 'L';
            WHEN '1' => rtn(index) := '1';
            WHEN 'H' => rtn(index) := 'H';
            WHEN 'U' => rtn(index) := 'U';
            WHEN 'Z' => rtn(index) := 'Z';
            WHEN 'W' => rtn(index) := 'W';
            WHEN OTHERS => rtn(index) := 'X';
         END CASE;
      END LOOP;
      RETURN rtn;
   END to_string;

    --

   FUNCTION to_octstring (
      val      : IN std_logic_vector) RETURN string IS
   
      constant extra : integer := val'length rem 3;
      constant len    : integer := ((val'length-1)/3)+1;
      variable rtn  : string(1 to len);
      variable vec   : std_logic_vector((extra + val'length-1) downto 0);
      
   BEGIN
      case extra is
         when 0      => vec := val;
         when 1      => vec := '0' & val;
         when 2      => vec := "00" & val;
         when others => vec := val;
      end case;
      for x in len downto 1 loop
         case vec(2 downto 0) is
            when "000"     => rtn(x) := '0';
            when "001"     => rtn(x) := '1';
            when "010"     => rtn(x) := '2';
            when "011"     => rtn(x) := '3';
            when "100"     => rtn(x) := '4';
            when "101"     => rtn(x) := '5';
            when "110"     => rtn(x) := '6';
            when "111"     => rtn(x) := '7';
            when "UUU"     => rtn(x) := 'U';
            when "ZZZ"     => rtn(x) := 'Z';
            when "XXX"     => rtn(x) := 'X';
            when others      => rtn(x) := '?';
         end case;
         vec := "000" & vec(val'length-1 downto 3);
      end loop;
      return(rtn);
   END to_octstring;
  
  FUNCTION to_decstring (
      val      : IN std_logic_vector) RETURN string IS
   
      variable int   : integer;
   BEGIN
      int := to_integer(val);
      return(to_string(val));
   END to_decstring;
    

  FUNCTION to_hexstring (
      val      : IN std_logic_vector) RETURN string IS
   
      constant extra : integer := val'length rem 4;
      constant len    : integer := ((val'length-1)/4)+1;
      variable rtn  : string(1 to len);
      variable vec   : std_logic_vector((extra + val'length-1) downto 0);
      
   BEGIN
      case extra is
         when 0      => vec := val;
         when 1      => vec := '0' & val;
         when 2      => vec := "00" & val;
         when 3      => vec := "000" & val;
         when others => vec := val;
      end case;
      for x in len downto 1 loop
         case vec(3 downto 0) is
            when "0000"    => rtn(x) := '0';
            when "0001"     => rtn(x) := '1';
            when "0010"      => rtn(x) := '2';
            when "0011"    => rtn(x) := '3';
            when "0100"     => rtn(x) := '4';
            when "0101"      => rtn(x) := '5';
            when "0110"    => rtn(x) := '6';
            when "0111"     => rtn(x) := '7';
            when "1000"      => rtn(x) := '8';
            when "1001"    => rtn(x) := '9';
            when "1010"     => rtn(x) := 'A';
            when "1011"      => rtn(x) := 'B';
            when "1100"    => rtn(x) := 'C';
            when "1101"     => rtn(x) := 'D';
            when "1110"      => rtn(x) := 'E';
            when "1111"    => rtn(x) := 'F';
            when "UUUU"     => rtn(x) := 'U';
            when "ZZZZ"      => rtn(x) := 'Z';
            when "XXXX"    => rtn(x) := 'X';
            when others     => rtn(x) := '?';
         end case;
         vec := "0000" & vec(val'length-1 downto 4);
      end loop;
      return(rtn);
   END to_hexstring;
   
END;
