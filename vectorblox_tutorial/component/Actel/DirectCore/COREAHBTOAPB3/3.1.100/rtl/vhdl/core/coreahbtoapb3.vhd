-- ********************************************************************/
-- Actel Corporation Proprietary and Confidential
-- Copyright 2009 Actel Corporation. All rights reserved.
--
-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.
--
-- Description: AHB to APB3 Bridge
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
-- Notes:
--
-- *********************************************************************/

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.ahbtoapb3_pkg.all;

ENTITY COREAHBTOAPB3 IS
   GENERIC (

      -- ---------------------------------------------------------------------
      -- Parameters
      -- ---------------------------------------------------------------------
      -- Device Family parameter
      FAMILY               : INTEGER := 17
   );
   PORT (
      -- AHBL interface
      HCLK       : IN STD_LOGIC;
      HRESETN    : IN STD_LOGIC;
      HSEL       : IN STD_LOGIC;
      HADDR      : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      HWRITE     : IN STD_LOGIC;
      HREADY     : IN STD_LOGIC;
      HTRANS    : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      HWDATA     : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      HREADYOUT  : OUT STD_LOGIC;
      HRESP      : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      HRDATA     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      -- APB interface
      PADDR      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      PWRITE     : OUT STD_LOGIC;
      PENABLE    : OUT STD_LOGIC;
      PWDATA     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      PSEL       : OUT STD_LOGIC;
      PREADY     : IN STD_LOGIC;
      PSLVERR    : IN STD_LOGIC;
      PRDATA     : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
   );
END ENTITY COREAHBTOAPB3;

ARCHITECTURE trans OF COREAHBTOAPB3 IS

  COMPONENT CoreAHBtoAPB3_AhbToApbSM
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
END COMPONENT;

COMPONENT CoreAHBtoAPB3_ApbAddrData
   GENERIC( SYNC_RESET  : INTEGER := 0);
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
END COMPONENT;

COMPONENT CoreAHBtoAPB3_PenableScheduler
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
END COMPONENT;

   -------------------------------------------------------------------
   -- Constant declarartions
   -------------------------------------------------------------------
   CONSTANT SYNC_RESET : INTEGER := SYNC_MODE_SEL(FAMILY);

   -------------------------------------------------------------------
   -- Signals
   -------------------------------------------------------------------
   SIGNAL setPenable      : STD_LOGIC;
   SIGNAL clrPenable      : STD_LOGIC;
   SIGNAL latchAddr       : STD_LOGIC;
   SIGNAL latchWrData     : STD_LOGIC;
   SIGNAL latchRdData     : STD_LOGIC;
   SIGNAL latchNextAddr   : STD_LOGIC;
   SIGNAL selNextAddr     : STD_LOGIC;

   -- Declare intermediate signals for referenced outputs
   SIGNAL HREADYOUT_xhdl1 : STD_LOGIC;
   SIGNAL HRESP_xhdl2     : STD_LOGIC_VECTOR(1 DOWNTO 0);
   SIGNAL HRDATA_xhdl0    : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL PADDR_xhdl3     : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL PWRITE_xhdl7    : STD_LOGIC;
   SIGNAL PENABLE_xhdl4   : STD_LOGIC;
   SIGNAL PWDATA_xhdl6    : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL PSEL_xhdl5      : STD_LOGIC;
BEGIN
   -- Drive referenced outputs
   HREADYOUT <= HREADYOUT_xhdl1;
   HRESP <= HRESP_xhdl2;
   HRDATA <= HRDATA_xhdl0;
   PADDR <= PADDR_xhdl3;
   PWRITE <= PWRITE_xhdl7;
   PENABLE <= PENABLE_xhdl4;
   PWDATA <= PWDATA_xhdl6;
   PSEL <= PSEL_xhdl5;

   -------------------------------------------------------------------
   -- Main body of code
   -------------------------------------------------------------------

   -- Main state machine


   U_AhbToApbSM : CoreAHBtoAPB3_AhbToApbSM
      GENERIC MAP(SYNC_RESET => SYNC_RESET)
      PORT MAP (
         hclk           => HCLK,
         hresetn        => HRESETN,
         hsel           => HSEL,
         htrans1        => HTRANS(1),
         hwrite         => HWRITE,
         hready         => HREADY,
         hresp          => HRESP_xhdl2,
         hreadyout      => HREADYOUT_xhdl1,
         pready         => PREADY,
         pslverr        => PSLVERR,
         penable        => PENABLE_xhdl4,
         pwrite         => PWRITE_xhdl7,
         psel           => PSEL_xhdl5,
         latchaddr      => latchAddr,
         latchwrdata    => latchWrData,
         latchrddata    => latchRdData,
         latchnextaddr  => latchNextAddr,
         selnextaddr    => selNextAddr,
         setpenable     => setPenable,
         clrpenable     => clrPenable
      );

   -- Scheduler for PENABLE signal


   U_PenableScheduler : CoreAHBtoAPB3_PenableScheduler
      GENERIC MAP(SYNC_RESET => SYNC_RESET)
      PORT MAP (
         hclk        => HCLK,
         hresetn     => HRESETN,
         setpenable  => setPenable,
         clrpenable  => clrPenable,
         penable     => PENABLE_xhdl4
      );

   -- Block which registers address and data information


   U_ApbAddrData : CoreAHBtoAPB3_ApbAddrData
      GENERIC MAP(SYNC_RESET => SYNC_RESET)
      PORT MAP (
         hclk           => HCLK,
         hresetn        => HRESETN,
         latchaddr      => latchAddr,
         latchwrdata    => latchWrData,
         latchrddata    => latchRdData,
         latchnextaddr  => latchNextAddr,
         selnextaddr    => selNextAddr,
         haddr          => HADDR(31 DOWNTO 0),
         hwdata         => HWDATA(31 DOWNTO 0),
         hrdata         => HRDATA_xhdl0(31 DOWNTO 0),
         paddr          => PADDR_xhdl3(31 DOWNTO 0),
         pwdata         => PWDATA_xhdl6(31 DOWNTO 0),
         prdata         => PRDATA(31 DOWNTO 0)
      );

END ARCHITECTURE trans;
