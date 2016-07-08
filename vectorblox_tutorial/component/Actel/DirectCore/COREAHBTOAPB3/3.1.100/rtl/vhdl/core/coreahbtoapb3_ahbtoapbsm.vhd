-- ********************************************************************/
-- Actel Corporation Proprietary and Confidential
-- Copyright 2009 Actel Corporation. All rights reserved.
--
-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.
--
-- Description: State machine for AHB to APB bridge.
--
-- Revision Information:
-- Date     Description
-- 26Oct09  Initial version.
--
-- SVN Revision Information:
-- SVN $Revision: $
-- SVN $Date: $
--
-- Resolved SARs:
-- SAR      Date    Who Description
--
-- Notes:
--
-- *********************************************************************/
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY CoreAHBtoAPB3_AhbToApbSM IS
   GENERIC (

      -------------------------------------------------------------------
      -- Local parameters
      -------------------------------------------------------------------

      -------------------------------------------------------------------
      -- Constant declarartions
      -------------------------------------------------------------------

      -- AHB HRESP constant definitions
      RSP_OKAY       : INTEGER := 0;
      RSP_ERROR      : INTEGER := 1;

      -- State names
      IDLE           : INTEGER := 0;
      WRITE0         : INTEGER := 1;
      WRITE1         : INTEGER := 2;
      READ0          : INTEGER := 3;
      WAIT_xhdl0     : INTEGER := 4;
	  SYNC_RESET     : INTEGER := 0
   );
   PORT (
      HCLK           : IN STD_LOGIC;
      HRESETN        : IN STD_LOGIC;
      HSEL           : IN STD_LOGIC;
      HTRANS1        : IN STD_LOGIC;
      HWRITE         : IN STD_LOGIC;
      HREADY         : IN STD_LOGIC;
      HRESP          : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      HREADYOUT      : OUT STD_LOGIC;
      PREADY         : IN STD_LOGIC;
      PSLVERR        : IN STD_LOGIC;
      PENABLE        : IN STD_LOGIC;
      PWRITE         : OUT STD_LOGIC;
      PSEL           : OUT STD_LOGIC;
      latchAddr      : OUT STD_LOGIC;
      latchWrData    : OUT STD_LOGIC;
      latchRdData    : OUT STD_LOGIC;
      latchNextAddr  : OUT STD_LOGIC;
      selNextAddr    : OUT STD_LOGIC;
      setPenable     : OUT STD_LOGIC;
      clrPenable     : OUT STD_LOGIC
   );
END ENTITY CoreAHBtoAPB3_AhbToApbSM;

ARCHITECTURE trans OF CoreAHBtoAPB3_AhbToApbSM IS

   -------------------------------------------------------------------
   -- Signals
   -------------------------------------------------------------------
   SIGNAL ahbToApbSMState           : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL nextAhbToApbSMState       : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL latchNextWrite            : STD_LOGIC;
   SIGNAL nextWrite                 : STD_LOGIC;
   SIGNAL pending                   : STD_LOGIC;
   SIGNAL setPending                : STD_LOGIC;
   SIGNAL clrPending                : STD_LOGIC;
   SIGNAL d_psel                    : STD_LOGIC;
   SIGNAL d_PWRITE                  : STD_LOGIC;
   SIGNAL d_HREADYOUT               : STD_LOGIC;
   SIGNAL errorRespState            : STD_LOGIC;
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
   PROCESS (ahbToApbSMState, HSEL, HREADY, HTRANS1, HWRITE, PENABLE, PREADY, pending, nextWrite)
   BEGIN
      latchAddr <= '0';
      latchWrData <= '0';
      latchRdData <= '0';
      latchNextAddr <= '0';
      latchNextWrite <= '0';
      selNextAddr <= '0';
      setPending <= '0';
      clrPending <= '0';
      setPenable <= '0';
      clrPenable <= '0';
      d_psel <= '0';
      d_PWRITE <= '0';

      d_HREADYOUT <= '1';
      CASE ahbToApbSMState IS
         WHEN to_stdlogicvector(IDLE, 3) =>
            IF ((HSEL AND HREADY AND HTRANS1) = '1') THEN
               latchAddr <= '1';
               IF (HWRITE = '1') THEN
                  nextAhbToApbSMState <= to_stdlogicvector(WRITE0, 3);
               ELSE
                  setPenable <= '1';
                  d_psel <= '1';
                  d_HREADYOUT <= '0';
                  nextAhbToApbSMState <= to_stdlogicvector(READ0, 3);
               END IF;
            ELSE
               nextAhbToApbSMState <= to_stdlogicvector(IDLE, 3);
            END IF;
         -- If another valid transfer occurs while processing a posted write,
         -- latch new HWRITE and set HREADYOUT low in following cycle.
         WHEN to_stdlogicvector(WRITE0, 3) =>
            IF ((HSEL AND HREADY AND HTRANS1) = '1') THEN
               d_HREADYOUT <= '0';
               latchNextAddr <= '1';
               latchNextWrite <= '1';
               setPending <= '1';
            END IF;
            latchWrData <= '1';
            setPenable <= '1';
            d_psel <= '1';
            d_PWRITE <= '1';
            nextAhbToApbSMState <= to_stdlogicvector(WRITE1, 3);
         -- If another valid transfer occurs during last cycle of posted write,
         -- go on to next read/write based on HWRITE
         -- WAIT state allows a cycle between posted write and
         -- immediately following read. This allows PENABLE
         -- output to be deasserted between the write and read.
         -- WAIT state allows a cycle between posted write and
         -- immediately following read. This allows PENABLE
         -- output to be deasserted between the write and read.
         -- If another valid transfer occurs while processing a posted write,
         -- latch new HWRITE and set HREADYOUT low in following cycle.
         --
         -- SM remains in READ0 state until latchRdData control signal
         -- can be asserted. This is indicated by PENABLE and PREADY
         -- both being asserted. The read data can be safely registered
         -- at this time because the APB peripherals and busses have
         -- been synthesized to operate at the HCLK frequency. This
         -- means that no path is longer than the period of HCLK.
         --
         --
         WHEN to_stdlogicvector(WRITE1, 3) =>
            IF ((PENABLE AND PREADY) = '1') THEN
               clrPenable <= '1';
               IF ((HSEL AND HREADY AND HTRANS1) = '1') THEN
                  latchAddr <= '1';
                  IF (HWRITE = '1') THEN
                     nextAhbToApbSMState <= to_stdlogicvector(WRITE0, 3);
                  ELSE
                     d_HREADYOUT <= '0';
                     nextAhbToApbSMState <= to_stdlogicvector(WAIT_xhdl0, 3);
                  END IF;
               ELSE
                  IF (pending = '1') THEN
                     selNextAddr <= '1';
                     clrPending <= '1';
                     IF (nextWrite = '1') THEN
                        nextAhbToApbSMState <= to_stdlogicvector(WRITE0, 3);
                     ELSE
                        d_HREADYOUT <= '0';
                        nextAhbToApbSMState <= to_stdlogicvector(WAIT_xhdl0, 3);
                     END IF;
                  ELSE
                     nextAhbToApbSMState <= to_stdlogicvector(IDLE, 3);
                  END IF;
               END IF;
            ELSE
               d_psel <= '1';
               d_PWRITE <= '1';
               IF (pending = '1') THEN
                  d_HREADYOUT <= '0';
                  nextAhbToApbSMState <= to_stdlogicvector(WRITE1, 3);
               ELSE
                  IF ((HSEL AND HREADY AND HTRANS1) = '1') THEN
                     latchNextAddr <= '1';
                     latchNextWrite <= '1';
                     setPending <= '1';
                     d_HREADYOUT <= '0';
                     nextAhbToApbSMState <= to_stdlogicvector(WRITE1, 3);
                  ELSE
                     nextAhbToApbSMState <= to_stdlogicvector(WRITE1, 3);
                  END IF;
               END IF;
            END IF;
         WHEN to_stdlogicvector(READ0, 3) =>
            IF ((PENABLE AND PREADY) = '1') THEN
               latchRdData <= '1';
               clrPenable <= '1';
               nextAhbToApbSMState <= to_stdlogicvector(IDLE, 3);
            ELSE
               d_psel <= '1';
               d_HREADYOUT <= '0';
               nextAhbToApbSMState <= to_stdlogicvector(READ0, 3);
            END IF;
         WHEN to_stdlogicvector(WAIT_xhdl0, 3) =>
            setPenable <= '1';
            d_psel <= '1';
            d_HREADYOUT <= '0';
            nextAhbToApbSMState <= to_stdlogicvector(READ0, 3);
         WHEN OTHERS =>
            nextAhbToApbSMState <= to_stdlogicvector(IDLE, 3);
      END CASE;
   END PROCESS;


   -- Synchronous part of state machine
   PROCESS (HCLK, aresetn)
   BEGIN
      IF ((NOT(aresetn)) = '1') THEN
         ahbToApbSMState <= to_stdlogicvector(IDLE, 3);
         PSEL <= '0';
         PWRITE <= '0';
      ELSIF (HCLK'EVENT AND HCLK = '1') THEN
         IF ((NOT(sresetn)) = '1') THEN
            ahbToApbSMState <= to_stdlogicvector(IDLE, 3);
            PSEL <= '0';
            PWRITE <= '0';
	     ELSE
            ahbToApbSMState <= nextAhbToApbSMState;
            PSEL <= d_psel;
            PWRITE <= d_PWRITE;
         END IF;
      END IF;
   END PROCESS;


   -- pending flag
   PROCESS (HCLK, aresetn)
   BEGIN
      IF ((NOT(aresetn)) = '1') THEN
         pending <= '0';
      ELSIF (HCLK'EVENT AND HCLK = '1') THEN
         IF ((NOT(sresetn)) = '1') THEN
            pending <= '0';
	     ELSE
            IF (setPending = '1') THEN
               pending <= '1';
            ELSE
               IF (clrPending = '1') THEN
                  pending <= '0';
               END IF;
            END IF;
         END IF;
      END IF;
   END PROCESS;


   -- Register to hold value of HWRITE for a pending transfer
   PROCESS (HCLK, aresetn)
   BEGIN
      IF ((NOT(aresetn)) = '1') THEN
         nextWrite <= '0';
      ELSIF (HCLK'EVENT AND HCLK = '1') THEN
         IF ((NOT(sresetn)) = '1') THEN
            nextWrite <= '0';
	     ELSE
            IF (latchNextWrite = '1') THEN
               nextWrite <= HWRITE;
            END IF;
         END IF;
      END IF;
   END PROCESS;


   -- HRESP handler
   -- Takes care of providing a two cycle error response if necessary
   PROCESS (HCLK, aresetn)
   BEGIN
      IF ((NOT(aresetn)) = '1') THEN
         errorRespState <= '0';
         HRESP <= to_stdlogicvector(RSP_OKAY, 2);
         HREADYOUT <= '1';
      ELSIF (HCLK'EVENT AND HCLK = '1') THEN
         IF ((NOT(sresetn)) = '1') THEN
            errorRespState <= '0';
            HRESP <= to_stdlogicvector(RSP_OKAY, 2);
            HREADYOUT <= '1';
	     ELSE
            CASE errorRespState IS
               WHEN '0' =>
                  IF (PSLVERR = '1') THEN
                     errorRespState <= '1';
                     HRESP <= to_stdlogicvector(RSP_ERROR, 2);
                     HREADYOUT <= '0';
                  ELSE
                     errorRespState <= '0';
                     HRESP <= to_stdlogicvector(RSP_OKAY, 2);
                     HREADYOUT <= d_HREADYOUT;
                  END IF;
               WHEN '1' =>
                  errorRespState <= '0';
                  HRESP <= to_stdlogicvector(RSP_ERROR, 2);
                  HREADYOUT <= '1';
               WHEN OTHERS =>
                  errorRespState <= '0';
            END CASE;
         END IF;
      END IF;
   END PROCESS;


END ARCHITECTURE trans;

