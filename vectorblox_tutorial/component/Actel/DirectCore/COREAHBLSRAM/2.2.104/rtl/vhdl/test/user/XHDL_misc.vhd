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
-- Rev 2001.2026
--

LIBRARY ieee;
USE ieee.std_logic_1164.all;
LIBRARY std;
USE std.textio.all;

PACKAGE xhdl_misc IS

   PROCEDURE WRITE (
      val      : IN string);

   FUNCTION to_time (
      val : integer) RETURN time;
   
   FUNCTION to_string (
     val : integer) RETURN string;
      
   FUNCTION to_string (
      val : time) RETURN string;
      
   FUNCTION to_decstring (
      val      : IN integer) RETURN string;

END;

PACKAGE BODY xhdl_misc IS

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

   PROCEDURE WRITE (
      val      : IN string) IS
      VARIABLE ptr        : line;
   BEGIN
      WRITE(OUTPUT, val);
      WRITELINE(OUTPUT, ptr);
   END WRITE;

   FUNCTION to_time (
      val : integer) RETURN time IS
   
      VARIABLE rtn : time;
   BEGIN
      rtn := val * 1 ns;
      RETURN(rtn);
   END to_time;
   
   FUNCTION to_string (
      val : integer) RETURN string IS
      
      VARIABLE r       : integer := val;
      VARIABLE size     : integer := 0;
   BEGIN
     WHILE (r > 0) LOOP
         size := size + 1;
         r := r/10;
      END LOOP;
      RETURN(make_string(val, size));
   END to_string;
   
   FUNCTION to_string (
      val : time) RETURN string IS
      
      VARIABLE r       : integer;
      VARIABLE size     : integer := 0;  
   BEGIN
      r := val / 1 ns;
      RETURN(to_string(r));
   END to_string;
   

  FUNCTION to_decstring (
      val      : IN integer) RETURN string IS
   
   BEGIN
      return(to_string(val));
   END to_decstring;
    
END;
