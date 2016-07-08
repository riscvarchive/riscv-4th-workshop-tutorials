-- ********************************************************************/
-- Actel Corporation Proprietary and Confidential
-- Copyright 2009 Actel Corporation. All rights reserved.
--
-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.
--
-- Description: This module is part of the AHB to APB
--              Bridge and performs the following tasks:
--                  - Latches AHB address and data
--
-- Revision Information:
-- Date     Description
-- 26Oct09  Initial version.
--
-- SVN Revision Information:
-- SVN $Revision: $
-- SVN $Date:  $
--
-- Resolved SARs:
--
-- Notes:
--
-- *********************************************************************/
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY CoreAHBtoAPB3_ApbAddrData IS
   GENERIC (SYNC_RESET  : INTEGER := 0);
   PORT (
      HCLK           : IN STD_LOGIC;
      HRESETN        : IN STD_LOGIC;
      latchAddr      : IN STD_LOGIC;
      latchWrData    : IN STD_LOGIC;
      latchRdData    : IN STD_LOGIC;
      latchNextAddr  : IN STD_LOGIC;
      selNextAddr    : IN STD_LOGIC;
      HADDR          : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      HWDATA         : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      HRDATA         : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      PADDR          : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      PWDATA         : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      PRDATA         : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
   );
END ENTITY CoreAHBtoAPB3_ApbAddrData;

ARCHITECTURE trans OF CoreAHBtoAPB3_ApbAddrData IS

   -------------------------------------------------------------------
   -- Constant declarartions
   -------------------------------------------------------------------

   -------------------------------------------------------------------
   -- Signals
   -------------------------------------------------------------------
   SIGNAL haddrReg                  : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL nextHaddrReg              : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL hwdataReg                 : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL aresetn                   : STD_LOGIC;
   SIGNAL sresetn                   : STD_LOGIC;
BEGIN
   -------------------------------------------------------------------
   -- Signal assignments
   -------------------------------------------------------------------
   aresetn <= '1' WHEN (SYNC_RESET=1) ELSE HRESETN;
   sresetn <= HRESETN WHEN (SYNC_RESET=1) ELSE '1';

   -------------------------------------------------------------------
   -- Main body of code
   -------------------------------------------------------------------

   -- HADDR register
   PROCESS (HCLK, aresetn)
   BEGIN
      IF ((NOT(aresetn)) = '1') THEN
         haddrReg <= "00000000000000000000000000000000";
      ELSIF (HCLK'EVENT AND HCLK = '1') THEN
         IF ((NOT(sresetn)) = '1') THEN
            haddrReg <= "00000000000000000000000000000000";
	     ELSE
            IF (latchAddr = '1') THEN
               haddrReg <= HADDR(31 DOWNTO 0);
            ELSE
               IF (selNextAddr = '1') THEN
                  haddrReg <= nextHaddrReg(31 DOWNTO 0);
               END IF;
            END IF;
         END IF;
      END IF;
   END PROCESS;


   -- Drive PADDR output
   PROCESS (haddrReg)
   BEGIN
      PADDR <= haddrReg(31 DOWNTO 0);
   END PROCESS;


   -- Latch HADDR of pending transaction
   PROCESS (HCLK, aresetn)
   BEGIN
      IF ((NOT(aresetn)) = '1') THEN
         nextHaddrReg <= "00000000000000000000000000000000";
      ELSIF (HCLK'EVENT AND HCLK = '1') THEN
         IF ((NOT(sresetn)) = '1') THEN
            nextHaddrReg <= "00000000000000000000000000000000";
	     ELSE
            IF (latchNextAddr = '1') THEN
               nextHaddrReg <= HADDR(31 DOWNTO 0);
            END IF;
         END IF;
      END IF;
   END PROCESS;


   -- Latch HWDATA
   PROCESS (HCLK, aresetn)
   BEGIN
      IF ((NOT(aresetn)) = '1') THEN
         hwdataReg <= "00000000000000000000000000000000";
      ELSIF (HCLK'EVENT AND HCLK = '1') THEN
         IF ((NOT(sresetn)) = '1') THEN
            hwdataReg <= "00000000000000000000000000000000";
	     ELSE
            IF (latchWrData = '1') THEN
               hwdataReg(31 DOWNTO 0) <= HWDATA(31 DOWNTO 0);
            END IF;
         END IF;
      END IF;
   END PROCESS;


   -- Drive PWDATA output
   PROCESS (hwdataReg)
   BEGIN
      PWDATA(31 DOWNTO 0) <= hwdataReg(31 DOWNTO 0);
   END PROCESS;


   -- Latch read data back from APB slave to drive HRDATA
   -- output
   PROCESS (HCLK, aresetn)
   BEGIN
      IF ((NOT(aresetn)) = '1') THEN
         HRDATA(31 DOWNTO 0) <= "00000000000000000000000000000000";
      ELSIF (HCLK'EVENT AND HCLK = '1') THEN
         IF ((NOT(sresetn)) = '1') THEN
            HRDATA(31 DOWNTO 0) <= "00000000000000000000000000000000";
	     ELSE
            IF (latchRdData = '1') THEN
               HRDATA(31 DOWNTO 0) <= PRDATA(31 DOWNTO 0);
            END IF;
         END IF;
      END IF;
   END PROCESS;


END ARCHITECTURE trans;
