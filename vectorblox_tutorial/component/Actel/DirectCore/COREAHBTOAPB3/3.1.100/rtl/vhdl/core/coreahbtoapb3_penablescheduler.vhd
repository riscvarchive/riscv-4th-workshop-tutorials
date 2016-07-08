-- ********************************************************************/
-- Actel Corporation Proprietary and Confidential
-- Copyright 2009 Actel Corporation. All rights reserved.
--
-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.
--
-- Description: Takes care of asserting and deasserting PENABLE signal
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
-- SAR      Date    Who Description
--
-- Notes:
--
-- *********************************************************************/
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY CoreAHBtoAPB3_PenableScheduler IS
   GENERIC (

      -------------------------------------------------------------------
      -- Local parameters
      -------------------------------------------------------------------

      -------------------------------------------------------------------
      -- Constant declarartions
      -------------------------------------------------------------------
      -- State names
      IDLE        : INTEGER := 0;
      WAIT_xhdl0  : INTEGER := 1;
      WAITCLR     : INTEGER := 2;
      SYNC_RESET  : INTEGER := 0
   );
   PORT (
      HCLK        : IN STD_LOGIC;
      HRESETN     : IN STD_LOGIC;
      setPenable  : IN STD_LOGIC;
      clrPenable  : IN STD_LOGIC;
      PENABLE     : OUT STD_LOGIC
   );
END ENTITY CoreAHBtoAPB3_PenableScheduler;

ARCHITECTURE trans OF CoreAHBtoAPB3_PenableScheduler IS

   -------------------------------------------------------------------
   -- Signals
   -------------------------------------------------------------------
   SIGNAL penableSchedulerState     : STD_LOGIC_VECTOR(1 DOWNTO 0);
   SIGNAL nextPenableSchedulerState : STD_LOGIC_VECTOR(1 DOWNTO 0);
   SIGNAL d_PENABLE                 : STD_LOGIC;
   SIGNAL aresetn                   : STD_LOGIC;
   SIGNAL sresetn                   : STD_LOGIC;

    FUNCTION to_stdlogicvector (
      val      : IN integer;
      len      : IN integer) RETURN std_logic_vector IS

      VARIABLE rtn      : std_logic_vector(len-1 DOWNTO 0) := (OTHERS => '0');
      VARIABLE num      : integer := val;
      VARIABLE r        : integer;
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


BEGIN
   -------------------------------------------------------------------
   -- Signal assignments
   -------------------------------------------------------------------
   aresetn <= '1' WHEN (SYNC_RESET=1) ELSE HRESETN;
   sresetn <= HRESETN WHEN (SYNC_RESET=1) ELSE '1';

   -------------------------------------------------------------------
   -- Main body of code
   -------------------------------------------------------------------

   -- Asynchronous part of state machine
   PROCESS (penableSchedulerState, setPenable, clrPenable)
   BEGIN
      d_PENABLE <= '0';
      CASE penableSchedulerState IS

         WHEN to_stdlogicvector(IDLE, 2) =>
            IF (setPenable = '1') THEN
               nextPenableSchedulerState <= to_stdlogicvector(WAIT_xhdl0, 2);
            ELSE
               nextPenableSchedulerState <= to_stdlogicvector(IDLE, 2);
            END IF;

         WHEN to_stdlogicvector(WAIT_xhdl0, 2) =>
            d_PENABLE <= '1';
            nextPenableSchedulerState <= to_stdlogicvector(WAITCLR, 2);

         WHEN to_stdlogicvector(WAITCLR, 2) =>
            IF (clrPenable = '1') THEN
               nextPenableSchedulerState <= to_stdlogicvector(IDLE, 2);
            ELSE
               d_PENABLE <= '1';
               nextPenableSchedulerState <= to_stdlogicvector(WAITCLR, 2);
            END IF;
         WHEN OTHERS =>
            d_PENABLE <= '0';
            nextPenableSchedulerState <= to_stdlogicvector(IDLE, 2);
      END CASE;
   END PROCESS;


   -- Synchronous part of state machine
   PROCESS (HCLK, aresetn)
   BEGIN
      IF ((NOT(aresetn)) = '1') THEN
         penableSchedulerState <= to_stdlogicvector(IDLE, 2);
         PENABLE <= '0';
      ELSIF (HCLK'EVENT AND HCLK = '1') THEN
         IF ((NOT(sresetn)) = '1') THEN
            penableSchedulerState <= to_stdlogicvector(IDLE, 2);
            PENABLE <= '0';
	     ELSE
            penableSchedulerState <= nextPenableSchedulerState;
            PENABLE <= d_PENABLE;
         END IF;
      END IF;
   END PROCESS;


END ARCHITECTURE trans;

