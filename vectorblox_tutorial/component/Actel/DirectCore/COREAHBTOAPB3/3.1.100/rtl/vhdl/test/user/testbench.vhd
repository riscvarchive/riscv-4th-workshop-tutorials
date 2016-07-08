-- ********************************************************************/
-- Actel Corporation Proprietary and Confidential
-- Copyright 2009 Actel Corporation.  All rights reserved.
--
-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.
--
-- Description: COREAHBtoAPB3 Unit Testbench
--
-- Revision Information:
-- Date     Description
-- 3Nov09  Initial Release
--
-- SVN Revision Information:
-- SVN $Revision: $
-- SVN $Date:  $
--
-- Resolved SARs
-- SAR      Date     Who   Description
--
-- Notes:
--
-- *********************************************************************/
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE work.coreparameters.all;

ENTITY testbench IS
   GENERIC (

      SYSCLK_PERIOD    : INTEGER := 10;		-- 100MHz
      MASTER_VECTFILE  : STRING := "master.vec";
      -- propagation delay in ns
      TPD              : INTEGER := 3
   );
END ENTITY testbench;

ARCHITECTURE trans OF testbench IS

  component COREAHBTOAPB3
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
  end component;

  component BFM_AHBL
  generic ( VECTFILE         : string  := "test.vec";
            MAX_INSTRUCTIONS : integer := 16384;
            MAX_STACK        : integer := 1024;
            MAX_MEMTEST      : integer := 65536;
            TPD              : integer range 0 to 1000 := 1;
            DEBUGLEVEL       : integer range -1 to 5 := -1;
            ARGVALUE0        : integer :=0;
            ARGVALUE1        : integer :=0;
            ARGVALUE2        : integer :=0;
            ARGVALUE3        : integer :=0;
            ARGVALUE4        : integer :=0;
            ARGVALUE5        : integer :=0;
            ARGVALUE6        : integer :=0;
            ARGVALUE7        : integer :=0;
            ARGVALUE8        : integer :=0;
            ARGVALUE9        : integer :=0;
            ARGVALUE10       : integer :=0;
            ARGVALUE11       : integer :=0;
            ARGVALUE12       : integer :=0;
            ARGVALUE13       : integer :=0;
            ARGVALUE14       : integer :=0;
            ARGVALUE15       : integer :=0;
            ARGVALUE16       : integer :=0;
            ARGVALUE17       : integer :=0;
            ARGVALUE18       : integer :=0;
            ARGVALUE19       : integer :=0;
            ARGVALUE20       : integer :=0;
            ARGVALUE21       : integer :=0;
            ARGVALUE22       : integer :=0;
            ARGVALUE23       : integer :=0;
            ARGVALUE24       : integer :=0;
            ARGVALUE25       : integer :=0;
            ARGVALUE26       : integer :=0;
            ARGVALUE27       : integer :=0;
            ARGVALUE28       : integer :=0;
            ARGVALUE29       : integer :=0;
            ARGVALUE30       : integer :=0;
            ARGVALUE31       : integer :=0;
            ARGVALUE32       : integer :=0;
            ARGVALUE33       : integer :=0;
            ARGVALUE34       : integer :=0;
            ARGVALUE35       : integer :=0;
            ARGVALUE36       : integer :=0;
            ARGVALUE37       : integer :=0;
            ARGVALUE38       : integer :=0;
            ARGVALUE39       : integer :=0;
            ARGVALUE40       : integer :=0;
            ARGVALUE41       : integer :=0;
            ARGVALUE42       : integer :=0;
            ARGVALUE43       : integer :=0;
            ARGVALUE44       : integer :=0;
            ARGVALUE45       : integer :=0;
            ARGVALUE46       : integer :=0;
            ARGVALUE47       : integer :=0;
            ARGVALUE48       : integer :=0;
            ARGVALUE49       : integer :=0;
            ARGVALUE50       : integer :=0;
            ARGVALUE51       : integer :=0;
            ARGVALUE52       : integer :=0;
            ARGVALUE53       : integer :=0;
            ARGVALUE54       : integer :=0;
            ARGVALUE55       : integer :=0;
            ARGVALUE56       : integer :=0;
            ARGVALUE57       : integer :=0;
            ARGVALUE58       : integer :=0;
            ARGVALUE59       : integer :=0;
            ARGVALUE60       : integer :=0;
            ARGVALUE61       : integer :=0;
            ARGVALUE62       : integer :=0;
            ARGVALUE63       : integer :=0;
            ARGVALUE64       : integer :=0;
            ARGVALUE65       : integer :=0;
            ARGVALUE66       : integer :=0;
            ARGVALUE67       : integer :=0;
            ARGVALUE68       : integer :=0;
            ARGVALUE69       : integer :=0;
            ARGVALUE70       : integer :=0;
            ARGVALUE71       : integer :=0;
            ARGVALUE72       : integer :=0;
            ARGVALUE73       : integer :=0;
            ARGVALUE74       : integer :=0;
            ARGVALUE75       : integer :=0;
            ARGVALUE76       : integer :=0;
            ARGVALUE77       : integer :=0;
            ARGVALUE78       : integer :=0;
            ARGVALUE79       : integer :=0;
            ARGVALUE80       : integer :=0;
            ARGVALUE81       : integer :=0;
            ARGVALUE82       : integer :=0;
            ARGVALUE83       : integer :=0;
            ARGVALUE84       : integer :=0;
            ARGVALUE85       : integer :=0;
            ARGVALUE86       : integer :=0;
            ARGVALUE87       : integer :=0;
            ARGVALUE88       : integer :=0;
            ARGVALUE89       : integer :=0;
            ARGVALUE90       : integer :=0;
            ARGVALUE91       : integer :=0;
            ARGVALUE92       : integer :=0;
            ARGVALUE93       : integer :=0;
            ARGVALUE94       : integer :=0;
            ARGVALUE95       : integer :=0;
            ARGVALUE96       : integer :=0;
            ARGVALUE97       : integer :=0;
            ARGVALUE98       : integer :=0;
            ARGVALUE99       : integer :=0
           );
  port ( SYSCLK      : in    std_logic;
         SYSRSTN     : in    std_logic;
         HADDR       : out   std_logic_vector(31 downto 0);
         HCLK        : out   std_logic;
         HRESETN     : out   std_logic;
         -- AHB Interface
         HBURST      : out   std_logic_vector( 2 downto 0);
         HMASTLOCK   : out   std_logic;
         HPROT       : out   std_logic_vector( 3 downto 0);
         HSIZE       : out   std_logic_vector( 2 downto 0);
         HTRANS      : out   std_logic_vector( 1 downto 0);
         HWRITE      : out   std_logic;
         HWDATA      : out   std_logic_vector(31 downto 0);
         HRDATA      : in    std_logic_vector(31 downto 0);
         HREADY      : in    std_logic;
         HRESP       : in    std_logic;
         HSEL        : out   std_logic_vector(15 downto 0);
         INTERRUPT   : in    std_logic_vector(255 downto 0);
         --Control etc
         GP_OUT      : out   std_logic_vector(31 downto 0);
         GP_IN       : in    std_logic_vector(31 downto 0);
         EXT_WR      : out   std_logic;
         EXT_RD      : out   std_logic;
         EXT_ADDR    : out   std_logic_vector(31 downto 0);
         EXT_DATA    : inout std_logic_vector(31 downto 0);
         EXT_WAIT    : in    std_logic;
         FINISHED    : out   std_logic;
         FAILED      : out   std_logic
       );
  end component;

  component BFM_APBSLAVE
  generic ( AWIDTH    : integer range 1 to 32 := 16;
            DEPTH     : integer := 256;
            DWIDTH    : integer range 8 to 32 := 32;
            INITFILE  : string  := "";
            ID        : integer := 0;
            TPD       : integer range 0 to 1000 := 1;
            ENFUNC    : integer := 0;
            DEBUG     : integer range 0 to 1 :=0
          );
  port ( PCLK        : in  std_logic;
         PRESETN     : in  std_logic;
         PENABLE     : in  std_logic;
         PWRITE      : in  std_logic;
         PSEL        : in  std_logic;
         PADDR       : in  std_logic_vector( AWIDTH-1 downto 0);
         PWDATA      : in  std_logic_vector( DWIDTH-1 downto 0);
         PRDATA      : out std_logic_vector( DWIDTH-1 downto 0);
         PREADY      : out std_logic;
         PSLVERR     : out std_logic
       );
  end component;

   SIGNAL SYSCLK          : STD_LOGIC;
   SIGNAL SYSRSTN         : STD_LOGIC;

   SIGNAL HREADYIN        : STD_LOGIC;
   SIGNAL HREADYOUT       : STD_LOGIC;
   SIGNAL HRESP           : STD_LOGIC_VECTOR(1 DOWNTO 0);
   SIGNAL HRDATA          : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL HTRANS          : STD_LOGIC_VECTOR(1 DOWNTO 0);
   SIGNAL HWRITE          : STD_LOGIC;
   SIGNAL HADDR           : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL HWDATA          : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL HBURST          : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL HSIZE           : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL HPROT           : STD_LOGIC_VECTOR(3 DOWNTO 0);
   SIGNAL PRDATA          : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL PWDATA          : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL PADDR           : STD_LOGIC_VECTOR(31 DOWNTO 0);

   SIGNAL FINISHED_master : STD_LOGIC;
   SIGNAL HSEL            : STD_LOGIC_VECTOR(15 DOWNTO 0);

   -- Release system reset

   -- wait until both BFM's are finished

   -- SYSCLK signal

   -- Instantiate module to test
   -- AHB interface
   SIGNAL HCLK            : STD_LOGIC;
   SIGNAL HRESETN         : STD_LOGIC;
   SIGNAL STOP_SIM        : STD_LOGIC := '0';
   -- APB interface
   SIGNAL PENABLE         : STD_LOGIC;
   SIGNAL PSEL            : STD_LOGIC;
   SIGNAL PWRITE          : STD_LOGIC;
   SIGNAL PREADY          : STD_LOGIC;
   SIGNAL PSLVERR         : STD_LOGIC;
BEGIN
   PROCESS
   BEGIN
      SYSRSTN <= '0';
      WAIT FOR (SYSCLK_PERIOD * 4)*1 ns;
      SYSRSTN <= '1';
      WHILE (NOT((FINISHED_master = '1'))) LOOP
	 WAIT FOR (SYSCLK_PERIOD) * 1 ns;
         WAIT FOR (TPD)*1 ns;
      END LOOP;
      WAIT FOR 1 ns;
      STOP_SIM <= '1';
      WAIT;
   END PROCESS;

   HBURST <= "000";
   HPROT <= "0000";
   HREADYIN <= HREADYOUT AFTER 1 ns;

  PROCESS
   BEGIN
     SYSCLK <= '0';
     WAIT FOR (SYSCLK_PERIOD / 2)*1 ns;
     SYSCLK <= '1';
     WAIT FOR (SYSCLK_PERIOD / 2)*1 ns;
     IF (STOP_SIM = '1') THEN
      WAIT;
    END IF;
   END PROCESS;



   COREAHBTOAPB3_0 : COREAHBTOAPB3
      GENERIC MAP (
         FAMILY   => FAMILY
      )
      PORT MAP (
         hclk       => HCLK,
         hresetn    => HRESETN,
         haddr      => HADDR,
         htrans    =>  HTRANS,
         hwrite     => HWRITE,
         hwdata     => HWDATA,
         hsel       => HSEL(0),
         hready     => HREADYIN,
         hrdata     => HRDATA,
         hreadyout  => HREADYOUT,
         hresp      => HRESP,
         prdata     => PRDATA,
         penable    => PENABLE,
         pwdata     => PWDATA,
         psel       => PSEL,
         paddr      => PADDR,
         pwrite     => PWRITE,
         pready     => PREADY,
         pslverr    => PSLVERR
      );

   -- passing testbench parameters to BFM ARGVALUE* parameters


   master : BFM_AHBL
      GENERIC MAP (
         vectfile   => MASTER_VECTFILE,
         argvalue0  => FAMILY,
         argvalue1  => 1
      )
      PORT MAP (
         -- Inputs
         sysclk     => SYSCLK,
         sysrstn    => SYSRSTN,
         hready     => HREADYIN,
         hresp      => HRESP(0),
         hrdata     => HRDATA,
         -- Outputs
         hclk       => HCLK,
         hresetn    => HRESETN,
         htrans     => HTRANS,
         hburst     => OPEN,
         hsel       => HSEL,
         hprot      => OPEN,
         hsize      => HSIZE,
         hwrite     => HWRITE,
         hmastlock  => OPEN,
         haddr      => HADDR,
         hwdata     => HWDATA,
         interrupt  => "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
         gp_out     => OPEN,
         gp_in      => "00000000000000000000000000000000",
         ext_wr     => OPEN,
         ext_rd     => OPEN,
         ext_addr   => OPEN,
         ext_data   => OPEN,
         ext_wait   => '0',
         finished   => FINISHED_master,
         failed     => OPEN
      );



   slave : BFM_APBSLAVE
      PORT MAP (
         -- APB interface
         pclk     => HCLK,
         presetn  => HRESETN,
         penable  => PENABLE,
         pwrite   => PWRITE,
         psel     => PSEL,
         paddr    => PADDR(15 downto 0),
         pwdata   => PWDATA,
         prdata   => PRDATA,
         pready   => PREADY,
         pslverr  => PSLVERR
      );

END ARCHITECTURE trans;
