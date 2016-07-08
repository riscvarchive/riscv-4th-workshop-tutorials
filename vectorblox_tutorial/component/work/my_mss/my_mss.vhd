----------------------------------------------------------------------
-- Created by SmartDesign Sat Jul  9 11:11:38 2016
-- Version: v11.7 11.7.0.119
----------------------------------------------------------------------

----------------------------------------------------------------------
-- Libraries
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library smartfusion2;
use smartfusion2.all;
library COREAHBLITE_LIB;
use COREAHBLITE_LIB.all;
use COREAHBLITE_LIB.components.all;
library COREAHBTOAPB3_LIB;
use COREAHBTOAPB3_LIB.all;
use COREAHBTOAPB3_LIB.components.all;
library COREAPB3_LIB;
use COREAPB3_LIB.all;
use COREAPB3_LIB.components.all;
----------------------------------------------------------------------
-- my_mss entity declaration
----------------------------------------------------------------------
entity my_mss is
    -- Port list
    port(
        -- Inputs
        AMBA_MASTER_0_HADDR_M0     : in  std_logic_vector(31 downto 0);
        AMBA_MASTER_0_HBURST_M0    : in  std_logic_vector(2 downto 0);
        AMBA_MASTER_0_HMASTLOCK_M0 : in  std_logic;
        AMBA_MASTER_0_HPROT_M0     : in  std_logic_vector(3 downto 0);
        AMBA_MASTER_0_HSIZE_M0     : in  std_logic_vector(2 downto 0);
        AMBA_MASTER_0_HTRANS_M0    : in  std_logic_vector(1 downto 0);
        AMBA_MASTER_0_HWDATA_M0    : in  std_logic_vector(31 downto 0);
        AMBA_MASTER_0_HWRITE_M0    : in  std_logic;
        DEVRST_N                   : in  std_logic;
        FAB_RESET_N                : in  std_logic;
        M3_RESET_N                 : in  std_logic;
        MMUART_0_RXD_F2M           : in  std_logic;
        PRDATAS1                   : in  std_logic_vector(31 downto 0);
        PREADYS1                   : in  std_logic;
        PSLVERRS1                  : in  std_logic;
        -- Outputs
        AMBA_MASTER_0_HRDATA_M0    : out std_logic_vector(31 downto 0);
        AMBA_MASTER_0_HREADY_M0    : out std_logic;
        AMBA_MASTER_0_HRESP_M0     : out std_logic_vector(1 downto 0);
        FIC_0_CLK                  : out std_logic;
        FIC_0_LOCK                 : out std_logic;
        GL1                        : out std_logic;
        INIT_DONE                  : out std_logic;
        MMUART_0_TXD_M2F           : out std_logic;
        MSS_READY                  : out std_logic;
        PADDRS                     : out std_logic_vector(31 downto 0);
        PENABLES                   : out std_logic;
        POWER_ON_RESET_N           : out std_logic;
        PSELS1                     : out std_logic;
        PWDATAS                    : out std_logic_vector(31 downto 0);
        PWRITES                    : out std_logic
        );
end my_mss;
----------------------------------------------------------------------
-- my_mss architecture body
----------------------------------------------------------------------
architecture RTL of my_mss is
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------
-- my_mss_CCC_0_FCCC   -   Actel:SgCore:FCCC:2.0.200
component my_mss_CCC_0_FCCC
    -- Port list
    port(
        -- Inputs
        RCOSC_25_50MHZ : in  std_logic;
        -- Outputs
        GL0            : out std_logic;
        GL1            : out std_logic;
        LOCK           : out std_logic
        );
end component;
-- CoreAHBLite   -   Actel:DirectCore:CoreAHBLite:5.2.100
-- using entity instantiation for component CoreAHBLite
-- COREAHBTOAPB3   -   Actel:DirectCore:COREAHBTOAPB3:3.1.100
-- using entity instantiation for component COREAHBTOAPB3
-- CoreAPB3   -   Actel:DirectCore:CoreAPB3:4.1.100
-- using entity instantiation for component CoreAPB3
-- CoreResetP   -   Actel:DirectCore:CoreResetP:7.0.104
component CoreResetP
    generic( 
        DDR_WAIT            : integer := 200 ;
        DEVICE_090          : integer := 0 ;
        DEVICE_VOLTAGE      : integer := 2 ;
        ENABLE_SOFT_RESETS  : integer := 0 ;
        EXT_RESET_CFG       : integer := 0 ;
        FDDR_IN_USE         : integer := 0 ;
        MDDR_IN_USE         : integer := 0 ;
        SDIF0_IN_USE        : integer := 0 ;
        SDIF0_PCIE          : integer := 0 ;
        SDIF0_PCIE_HOTRESET : integer := 1 ;
        SDIF0_PCIE_L2P2     : integer := 1 ;
        SDIF1_IN_USE        : integer := 0 ;
        SDIF1_PCIE          : integer := 0 ;
        SDIF1_PCIE_HOTRESET : integer := 1 ;
        SDIF1_PCIE_L2P2     : integer := 1 ;
        SDIF2_IN_USE        : integer := 0 ;
        SDIF2_PCIE          : integer := 0 ;
        SDIF2_PCIE_HOTRESET : integer := 1 ;
        SDIF2_PCIE_L2P2     : integer := 1 ;
        SDIF3_IN_USE        : integer := 0 ;
        SDIF3_PCIE          : integer := 0 ;
        SDIF3_PCIE_HOTRESET : integer := 1 ;
        SDIF3_PCIE_L2P2     : integer := 1 
        );
    -- Port list
    port(
        -- Inputs
        CLK_BASE                       : in  std_logic;
        CLK_LTSSM                      : in  std_logic;
        CONFIG1_DONE                   : in  std_logic;
        CONFIG2_DONE                   : in  std_logic;
        FAB_RESET_N                    : in  std_logic;
        FIC_2_APB_M_PRESET_N           : in  std_logic;
        FPLL_LOCK                      : in  std_logic;
        POWER_ON_RESET_N               : in  std_logic;
        RCOSC_25_50MHZ                 : in  std_logic;
        RESET_N_M2F                    : in  std_logic;
        SDIF0_PERST_N                  : in  std_logic;
        SDIF0_PRDATA                   : in  std_logic_vector(31 downto 0);
        SDIF0_PSEL                     : in  std_logic;
        SDIF0_PWRITE                   : in  std_logic;
        SDIF0_SPLL_LOCK                : in  std_logic;
        SDIF1_PERST_N                  : in  std_logic;
        SDIF1_PRDATA                   : in  std_logic_vector(31 downto 0);
        SDIF1_PSEL                     : in  std_logic;
        SDIF1_PWRITE                   : in  std_logic;
        SDIF1_SPLL_LOCK                : in  std_logic;
        SDIF2_PERST_N                  : in  std_logic;
        SDIF2_PRDATA                   : in  std_logic_vector(31 downto 0);
        SDIF2_PSEL                     : in  std_logic;
        SDIF2_PWRITE                   : in  std_logic;
        SDIF2_SPLL_LOCK                : in  std_logic;
        SDIF3_PERST_N                  : in  std_logic;
        SDIF3_PRDATA                   : in  std_logic_vector(31 downto 0);
        SDIF3_PSEL                     : in  std_logic;
        SDIF3_PWRITE                   : in  std_logic;
        SDIF3_SPLL_LOCK                : in  std_logic;
        SOFT_EXT_RESET_OUT             : in  std_logic;
        SOFT_FDDR_CORE_RESET           : in  std_logic;
        SOFT_M3_RESET                  : in  std_logic;
        SOFT_MDDR_DDR_AXI_S_CORE_RESET : in  std_logic;
        SOFT_RESET_F2M                 : in  std_logic;
        SOFT_SDIF0_0_CORE_RESET        : in  std_logic;
        SOFT_SDIF0_1_CORE_RESET        : in  std_logic;
        SOFT_SDIF0_CORE_RESET          : in  std_logic;
        SOFT_SDIF0_PHY_RESET           : in  std_logic;
        SOFT_SDIF1_CORE_RESET          : in  std_logic;
        SOFT_SDIF1_PHY_RESET           : in  std_logic;
        SOFT_SDIF2_CORE_RESET          : in  std_logic;
        SOFT_SDIF2_PHY_RESET           : in  std_logic;
        SOFT_SDIF3_CORE_RESET          : in  std_logic;
        SOFT_SDIF3_PHY_RESET           : in  std_logic;
        -- Outputs
        DDR_READY                      : out std_logic;
        EXT_RESET_OUT                  : out std_logic;
        FDDR_CORE_RESET_N              : out std_logic;
        INIT_DONE                      : out std_logic;
        M3_RESET_N                     : out std_logic;
        MDDR_DDR_AXI_S_CORE_RESET_N    : out std_logic;
        MSS_HPMS_READY                 : out std_logic;
        RESET_N_F2M                    : out std_logic;
        SDIF0_0_CORE_RESET_N           : out std_logic;
        SDIF0_1_CORE_RESET_N           : out std_logic;
        SDIF0_CORE_RESET_N             : out std_logic;
        SDIF0_PHY_RESET_N              : out std_logic;
        SDIF1_CORE_RESET_N             : out std_logic;
        SDIF1_PHY_RESET_N              : out std_logic;
        SDIF2_CORE_RESET_N             : out std_logic;
        SDIF2_PHY_RESET_N              : out std_logic;
        SDIF3_CORE_RESET_N             : out std_logic;
        SDIF3_PHY_RESET_N              : out std_logic;
        SDIF_READY                     : out std_logic;
        SDIF_RELEASED                  : out std_logic
        );
end component;
-- CoreSF2Config   -   Actel:DirectCore:CoreSF2Config:3.0.100
component CoreSF2Config
    -- Port list
    port(
        -- Inputs
        FDDR_PRDATA          : in  std_logic_vector(31 downto 0);
        FDDR_PREADY          : in  std_logic;
        FDDR_PSLVERR         : in  std_logic;
        FIC_2_APB_M_PADDR    : in  std_logic_vector(16 downto 2);
        FIC_2_APB_M_PCLK     : in  std_logic;
        FIC_2_APB_M_PENABLE  : in  std_logic;
        FIC_2_APB_M_PRESET_N : in  std_logic;
        FIC_2_APB_M_PSEL     : in  std_logic;
        FIC_2_APB_M_PWDATA   : in  std_logic_vector(31 downto 0);
        FIC_2_APB_M_PWRITE   : in  std_logic;
        INIT_DONE            : in  std_logic;
        MDDR_PRDATA          : in  std_logic_vector(31 downto 0);
        MDDR_PREADY          : in  std_logic;
        MDDR_PSLVERR         : in  std_logic;
        SDIF0_PRDATA         : in  std_logic_vector(31 downto 0);
        SDIF0_PREADY         : in  std_logic;
        SDIF0_PSLVERR        : in  std_logic;
        SDIF1_PRDATA         : in  std_logic_vector(31 downto 0);
        SDIF1_PREADY         : in  std_logic;
        SDIF1_PSLVERR        : in  std_logic;
        SDIF2_PRDATA         : in  std_logic_vector(31 downto 0);
        SDIF2_PREADY         : in  std_logic;
        SDIF2_PSLVERR        : in  std_logic;
        SDIF3_PRDATA         : in  std_logic_vector(31 downto 0);
        SDIF3_PREADY         : in  std_logic;
        SDIF3_PSLVERR        : in  std_logic;
        -- Outputs
        APB_S_PCLK           : out std_logic;
        APB_S_PRESET_N       : out std_logic;
        CLR_INIT_DONE        : out std_logic;
        CONFIG_DONE          : out std_logic;
        FDDR_PADDR           : out std_logic_vector(15 downto 2);
        FDDR_PENABLE         : out std_logic;
        FDDR_PSEL            : out std_logic;
        FDDR_PWDATA          : out std_logic_vector(31 downto 0);
        FDDR_PWRITE          : out std_logic;
        FIC_2_APB_M_PRDATA   : out std_logic_vector(31 downto 0);
        FIC_2_APB_M_PREADY   : out std_logic;
        FIC_2_APB_M_PSLVERR  : out std_logic;
        MDDR_PADDR           : out std_logic_vector(15 downto 2);
        MDDR_PENABLE         : out std_logic;
        MDDR_PSEL            : out std_logic;
        MDDR_PWDATA          : out std_logic_vector(31 downto 0);
        MDDR_PWRITE          : out std_logic;
        SDIF0_PADDR          : out std_logic_vector(15 downto 2);
        SDIF0_PENABLE        : out std_logic;
        SDIF0_PSEL           : out std_logic;
        SDIF0_PWDATA         : out std_logic_vector(31 downto 0);
        SDIF0_PWRITE         : out std_logic;
        SDIF1_PADDR          : out std_logic_vector(15 downto 2);
        SDIF1_PENABLE        : out std_logic;
        SDIF1_PSEL           : out std_logic;
        SDIF1_PWDATA         : out std_logic_vector(31 downto 0);
        SDIF1_PWRITE         : out std_logic;
        SDIF2_PADDR          : out std_logic_vector(15 downto 2);
        SDIF2_PENABLE        : out std_logic;
        SDIF2_PSEL           : out std_logic;
        SDIF2_PWDATA         : out std_logic_vector(31 downto 0);
        SDIF2_PWRITE         : out std_logic;
        SDIF3_PADDR          : out std_logic_vector(15 downto 2);
        SDIF3_PENABLE        : out std_logic;
        SDIF3_PSEL           : out std_logic;
        SDIF3_PWDATA         : out std_logic_vector(31 downto 0);
        SDIF3_PWRITE         : out std_logic
        );
end component;
-- my_mss_FABOSC_0_OSC   -   Actel:SgCore:OSC:2.0.101
component my_mss_FABOSC_0_OSC
    -- Port list
    port(
        -- Inputs
        XTL                : in  std_logic;
        -- Outputs
        RCOSC_1MHZ_CCC     : out std_logic;
        RCOSC_1MHZ_O2F     : out std_logic;
        RCOSC_25_50MHZ_CCC : out std_logic;
        RCOSC_25_50MHZ_O2F : out std_logic;
        XTLOSC_CCC         : out std_logic;
        XTLOSC_O2F         : out std_logic
        );
end component;
-- my_mss_MSS
component my_mss_MSS
    -- Port list
    port(
        -- Inputs
        FIC_0_AHB_S_HADDR      : in  std_logic_vector(31 downto 0);
        FIC_0_AHB_S_HMASTLOCK  : in  std_logic;
        FIC_0_AHB_S_HREADY     : in  std_logic;
        FIC_0_AHB_S_HSEL       : in  std_logic;
        FIC_0_AHB_S_HSIZE      : in  std_logic_vector(1 downto 0);
        FIC_0_AHB_S_HTRANS     : in  std_logic_vector(1 downto 0);
        FIC_0_AHB_S_HWDATA     : in  std_logic_vector(31 downto 0);
        FIC_0_AHB_S_HWRITE     : in  std_logic;
        FIC_2_APB_M_PRDATA     : in  std_logic_vector(31 downto 0);
        FIC_2_APB_M_PREADY     : in  std_logic;
        FIC_2_APB_M_PSLVERR    : in  std_logic;
        M3_RESET_N             : in  std_logic;
        MCCC_CLK_BASE          : in  std_logic;
        MCCC_CLK_BASE_PLL_LOCK : in  std_logic;
        MDDR_APB_S_PADDR       : in  std_logic_vector(10 downto 2);
        MDDR_APB_S_PCLK        : in  std_logic;
        MDDR_APB_S_PENABLE     : in  std_logic;
        MDDR_APB_S_PRESET_N    : in  std_logic;
        MDDR_APB_S_PSEL        : in  std_logic;
        MDDR_APB_S_PWDATA      : in  std_logic_vector(15 downto 0);
        MDDR_APB_S_PWRITE      : in  std_logic;
        MMUART_0_RXD_F2M       : in  std_logic;
        MSS_RESET_N_F2M        : in  std_logic;
        -- Outputs
        FIC_0_AHB_S_HRDATA     : out std_logic_vector(31 downto 0);
        FIC_0_AHB_S_HREADYOUT  : out std_logic;
        FIC_0_AHB_S_HRESP      : out std_logic;
        FIC_2_APB_M_PADDR      : out std_logic_vector(15 downto 2);
        FIC_2_APB_M_PCLK       : out std_logic;
        FIC_2_APB_M_PENABLE    : out std_logic;
        FIC_2_APB_M_PRESET_N   : out std_logic;
        FIC_2_APB_M_PSEL       : out std_logic;
        FIC_2_APB_M_PWDATA     : out std_logic_vector(31 downto 0);
        FIC_2_APB_M_PWRITE     : out std_logic;
        MDDR_APB_S_PRDATA      : out std_logic_vector(15 downto 0);
        MDDR_APB_S_PREADY      : out std_logic;
        MDDR_APB_S_PSLVERR     : out std_logic;
        MMUART_0_TXD_M2F       : out std_logic;
        MSS_RESET_N_M2F        : out std_logic
        );
end component;
-- SYSRESET
component SYSRESET
    -- Port list
    port(
        -- Inputs
        DEVRST_N         : in  std_logic;
        -- Outputs
        POWER_ON_RESET_N : out std_logic
        );
end component;
----------------------------------------------------------------------
-- Signal declarations
----------------------------------------------------------------------
signal AMBA_MASTER_0_HRDATA                               : std_logic_vector(31 downto 0);
signal AMBA_MASTER_0_HREADY                               : std_logic;
signal AMBA_MASTER_0_HRESP                                : std_logic_vector(1 downto 0);
signal APBmslave1_PADDR                                   : std_logic_vector(31 downto 0);
signal APBmslave1_PENABLE                                 : std_logic;
signal APBmslave1_PSELx                                   : std_logic;
signal APBmslave1_PWDATA                                  : std_logic_vector(31 downto 0);
signal APBmslave1_PWRITE                                  : std_logic;
signal CoreAHBLite_0_AHBmslave1_HADDR                     : std_logic_vector(31 downto 0);
signal CoreAHBLite_0_AHBmslave1_HBURST                    : std_logic_vector(2 downto 0);
signal CoreAHBLite_0_AHBmslave1_HMASTLOCK                 : std_logic;
signal CoreAHBLite_0_AHBmslave1_HPROT                     : std_logic_vector(3 downto 0);
signal CoreAHBLite_0_AHBmslave1_HRDATA                    : std_logic_vector(31 downto 0);
signal CoreAHBLite_0_AHBmslave1_HREADY                    : std_logic;
signal CoreAHBLite_0_AHBmslave1_HREADYOUT                 : std_logic;
signal CoreAHBLite_0_AHBmslave1_HRESP                     : std_logic_vector(1 downto 0);
signal CoreAHBLite_0_AHBmslave1_HSELx                     : std_logic;
signal CoreAHBLite_0_AHBmslave1_HSIZE                     : std_logic_vector(2 downto 0);
signal CoreAHBLite_0_AHBmslave1_HTRANS                    : std_logic_vector(1 downto 0);
signal CoreAHBLite_0_AHBmslave1_HWDATA                    : std_logic_vector(31 downto 0);
signal CoreAHBLite_0_AHBmslave1_HWRITE                    : std_logic;
signal CoreAHBLite_0_AHBmslave16_HADDR                    : std_logic_vector(31 downto 0);
signal CoreAHBLite_0_AHBmslave16_HBURST                   : std_logic_vector(2 downto 0);
signal CoreAHBLite_0_AHBmslave16_HMASTLOCK                : std_logic;
signal CoreAHBLite_0_AHBmslave16_HPROT                    : std_logic_vector(3 downto 0);
signal CoreAHBLite_0_AHBmslave16_HRDATA                   : std_logic_vector(31 downto 0);
signal CoreAHBLite_0_AHBmslave16_HREADY                   : std_logic;
signal CoreAHBLite_0_AHBmslave16_HREADYOUT                : std_logic;
signal CoreAHBLite_0_AHBmslave16_HSELx                    : std_logic;
signal CoreAHBLite_0_AHBmslave16_HTRANS                   : std_logic_vector(1 downto 0);
signal CoreAHBLite_0_AHBmslave16_HWDATA                   : std_logic_vector(31 downto 0);
signal CoreAHBLite_0_AHBmslave16_HWRITE                   : std_logic;
signal COREAHBTOAPB3_0_APBmaster_PADDR                    : std_logic_vector(31 downto 0);
signal COREAHBTOAPB3_0_APBmaster_PENABLE                  : std_logic;
signal COREAHBTOAPB3_0_APBmaster_PRDATA                   : std_logic_vector(31 downto 0);
signal COREAHBTOAPB3_0_APBmaster_PREADY                   : std_logic;
signal COREAHBTOAPB3_0_APBmaster_PSELx                    : std_logic;
signal COREAHBTOAPB3_0_APBmaster_PSLVERR                  : std_logic;
signal COREAHBTOAPB3_0_APBmaster_PWDATA                   : std_logic_vector(31 downto 0);
signal COREAHBTOAPB3_0_APBmaster_PWRITE                   : std_logic;
signal CORERESETP_0_RESET_N_F2M                           : std_logic;
signal CoreSF2Config_0_APB_S_PCLK                         : std_logic;
signal CoreSF2Config_0_APB_S_PRESET_N                     : std_logic;
signal CoreSF2Config_0_CONFIG_DONE                        : std_logic;
signal CoreSF2Config_0_MDDR_APBmslave_PENABLE             : std_logic;
signal CoreSF2Config_0_MDDR_APBmslave_PREADY              : std_logic;
signal CoreSF2Config_0_MDDR_APBmslave_PSELx               : std_logic;
signal CoreSF2Config_0_MDDR_APBmslave_PSLVERR             : std_logic;
signal CoreSF2Config_0_MDDR_APBmslave_PWRITE              : std_logic;
signal FABOSC_0_RCOSC_25_50MHZ_CCC_OUT_RCOSC_25_50MHZ_CCC : std_logic;
signal FABOSC_0_RCOSC_25_50MHZ_O2F                        : std_logic;
signal FIC_0_CLK_net_0                                    : std_logic;
signal FIC_0_LOCK_net_0                                   : std_logic;
signal GL1_net_0                                          : std_logic;
signal INIT_DONE_net_0                                    : std_logic;
signal MMUART_0_TXD_M2F_net_0                             : std_logic;
signal MSS_READY_net_0                                    : std_logic;
signal my_mss_MSS_0_FIC_2_APB_M_PCLK                      : std_logic;
signal my_mss_MSS_0_FIC_2_APB_M_PRESET_N                  : std_logic;
signal my_mss_MSS_0_FIC_2_APB_MASTER_PENABLE              : std_logic;
signal my_mss_MSS_0_FIC_2_APB_MASTER_PRDATA               : std_logic_vector(31 downto 0);
signal my_mss_MSS_0_FIC_2_APB_MASTER_PREADY               : std_logic;
signal my_mss_MSS_0_FIC_2_APB_MASTER_PSELx                : std_logic;
signal my_mss_MSS_0_FIC_2_APB_MASTER_PSLVERR              : std_logic;
signal my_mss_MSS_0_FIC_2_APB_MASTER_PWDATA               : std_logic_vector(31 downto 0);
signal my_mss_MSS_0_FIC_2_APB_MASTER_PWRITE               : std_logic;
signal my_mss_MSS_TMP_0_MSS_RESET_N_M2F                   : std_logic;
signal POWER_ON_RESET_N_net_0                             : std_logic;
signal POWER_ON_RESET_N_net_1                             : std_logic;
signal INIT_DONE_net_1                                    : std_logic;
signal FIC_0_CLK_net_1                                    : std_logic;
signal FIC_0_LOCK_net_1                                   : std_logic;
signal MSS_READY_net_1                                    : std_logic;
signal AMBA_MASTER_0_HREADY_net_0                         : std_logic;
signal MMUART_0_TXD_M2F_net_1                             : std_logic;
signal GL1_net_1                                          : std_logic;
signal APBmslave1_PSELx_net_0                             : std_logic;
signal APBmslave1_PENABLE_net_0                           : std_logic;
signal APBmslave1_PWRITE_net_0                            : std_logic;
signal AMBA_MASTER_0_HRDATA_net_0                         : std_logic_vector(31 downto 0);
signal AMBA_MASTER_0_HRESP_net_0                          : std_logic_vector(1 downto 0);
signal APBmslave1_PADDR_net_0                             : std_logic_vector(31 downto 0);
signal APBmslave1_PWDATA_net_0                            : std_logic_vector(31 downto 0);
----------------------------------------------------------------------
-- TiedOff Signals
----------------------------------------------------------------------
signal GND_net                                            : std_logic;
signal VCC_net                                            : std_logic;
signal PADDR_const_net_0                                  : std_logic_vector(7 downto 2);
signal PWDATA_const_net_0                                 : std_logic_vector(7 downto 0);
signal IADDR_const_net_0                                  : std_logic_vector(31 downto 0);
signal SDIF0_PRDATA_const_net_0                           : std_logic_vector(31 downto 0);
signal SDIF1_PRDATA_const_net_0                           : std_logic_vector(31 downto 0);
signal SDIF2_PRDATA_const_net_0                           : std_logic_vector(31 downto 0);
signal SDIF3_PRDATA_const_net_0                           : std_logic_vector(31 downto 0);
signal FDDR_PRDATA_const_net_0                            : std_logic_vector(31 downto 0);
signal SDIF0_PRDATA_const_net_1                           : std_logic_vector(31 downto 0);
signal SDIF1_PRDATA_const_net_1                           : std_logic_vector(31 downto 0);
signal SDIF2_PRDATA_const_net_1                           : std_logic_vector(31 downto 0);
signal SDIF3_PRDATA_const_net_1                           : std_logic_vector(31 downto 0);
signal HADDR_M1_const_net_0                               : std_logic_vector(31 downto 0);
signal HTRANS_M1_const_net_0                              : std_logic_vector(1 downto 0);
signal HSIZE_M1_const_net_0                               : std_logic_vector(2 downto 0);
signal HBURST_M1_const_net_0                              : std_logic_vector(2 downto 0);
signal HPROT_M1_const_net_0                               : std_logic_vector(3 downto 0);
signal HWDATA_M1_const_net_0                              : std_logic_vector(31 downto 0);
signal HADDR_M2_const_net_0                               : std_logic_vector(31 downto 0);
signal HTRANS_M2_const_net_0                              : std_logic_vector(1 downto 0);
signal HSIZE_M2_const_net_0                               : std_logic_vector(2 downto 0);
signal HBURST_M2_const_net_0                              : std_logic_vector(2 downto 0);
signal HPROT_M2_const_net_0                               : std_logic_vector(3 downto 0);
signal HWDATA_M2_const_net_0                              : std_logic_vector(31 downto 0);
signal HADDR_M3_const_net_0                               : std_logic_vector(31 downto 0);
signal HTRANS_M3_const_net_0                              : std_logic_vector(1 downto 0);
signal HSIZE_M3_const_net_0                               : std_logic_vector(2 downto 0);
signal HBURST_M3_const_net_0                              : std_logic_vector(2 downto 0);
signal HPROT_M3_const_net_0                               : std_logic_vector(3 downto 0);
signal HWDATA_M3_const_net_0                              : std_logic_vector(31 downto 0);
signal HRDATA_S0_const_net_0                              : std_logic_vector(31 downto 0);
signal HRESP_S0_const_net_0                               : std_logic_vector(1 downto 0);
signal HRDATA_S2_const_net_0                              : std_logic_vector(31 downto 0);
signal HRESP_S2_const_net_0                               : std_logic_vector(1 downto 0);
signal HRDATA_S3_const_net_0                              : std_logic_vector(31 downto 0);
signal HRESP_S3_const_net_0                               : std_logic_vector(1 downto 0);
signal HRDATA_S4_const_net_0                              : std_logic_vector(31 downto 0);
signal HRESP_S4_const_net_0                               : std_logic_vector(1 downto 0);
signal HRDATA_S5_const_net_0                              : std_logic_vector(31 downto 0);
signal HRESP_S5_const_net_0                               : std_logic_vector(1 downto 0);
signal HRDATA_S6_const_net_0                              : std_logic_vector(31 downto 0);
signal HRESP_S6_const_net_0                               : std_logic_vector(1 downto 0);
signal HRDATA_S7_const_net_0                              : std_logic_vector(31 downto 0);
signal HRESP_S7_const_net_0                               : std_logic_vector(1 downto 0);
signal HRDATA_S8_const_net_0                              : std_logic_vector(31 downto 0);
signal HRESP_S8_const_net_0                               : std_logic_vector(1 downto 0);
signal HRDATA_S9_const_net_0                              : std_logic_vector(31 downto 0);
signal HRESP_S9_const_net_0                               : std_logic_vector(1 downto 0);
signal HRDATA_S10_const_net_0                             : std_logic_vector(31 downto 0);
signal HRESP_S10_const_net_0                              : std_logic_vector(1 downto 0);
signal HRDATA_S11_const_net_0                             : std_logic_vector(31 downto 0);
signal HRESP_S11_const_net_0                              : std_logic_vector(1 downto 0);
signal HRDATA_S12_const_net_0                             : std_logic_vector(31 downto 0);
signal HRESP_S12_const_net_0                              : std_logic_vector(1 downto 0);
signal HRDATA_S13_const_net_0                             : std_logic_vector(31 downto 0);
signal HRESP_S13_const_net_0                              : std_logic_vector(1 downto 0);
signal HRDATA_S14_const_net_0                             : std_logic_vector(31 downto 0);
signal HRESP_S14_const_net_0                              : std_logic_vector(1 downto 0);
signal HRDATA_S15_const_net_0                             : std_logic_vector(31 downto 0);
signal HRESP_S15_const_net_0                              : std_logic_vector(1 downto 0);
signal PRDATAS0_const_net_0                               : std_logic_vector(31 downto 0);
signal PRDATAS2_const_net_0                               : std_logic_vector(31 downto 0);
signal PRDATAS3_const_net_0                               : std_logic_vector(31 downto 0);
signal PRDATAS4_const_net_0                               : std_logic_vector(31 downto 0);
signal PRDATAS5_const_net_0                               : std_logic_vector(31 downto 0);
signal PRDATAS6_const_net_0                               : std_logic_vector(31 downto 0);
signal PRDATAS7_const_net_0                               : std_logic_vector(31 downto 0);
signal PRDATAS8_const_net_0                               : std_logic_vector(31 downto 0);
signal PRDATAS9_const_net_0                               : std_logic_vector(31 downto 0);
signal PRDATAS10_const_net_0                              : std_logic_vector(31 downto 0);
signal PRDATAS11_const_net_0                              : std_logic_vector(31 downto 0);
signal PRDATAS12_const_net_0                              : std_logic_vector(31 downto 0);
signal PRDATAS13_const_net_0                              : std_logic_vector(31 downto 0);
signal PRDATAS14_const_net_0                              : std_logic_vector(31 downto 0);
signal PRDATAS15_const_net_0                              : std_logic_vector(31 downto 0);
signal PRDATAS16_const_net_0                              : std_logic_vector(31 downto 0);
----------------------------------------------------------------------
-- Bus Interface Nets Declarations - Unequal Pin Widths
----------------------------------------------------------------------
signal CoreAHBLite_0_AHBmslave16_HRESP                    : std_logic;
signal CoreAHBLite_0_AHBmslave16_HRESP_0_1to1             : std_logic_vector(1 to 1);
signal CoreAHBLite_0_AHBmslave16_HRESP_0_0to0             : std_logic_vector(0 to 0);
signal CoreAHBLite_0_AHBmslave16_HRESP_0                  : std_logic_vector(1 downto 0);

signal CoreAHBLite_0_AHBmslave16_HSIZE_0_1to0             : std_logic_vector(1 downto 0);
signal CoreAHBLite_0_AHBmslave16_HSIZE_0                  : std_logic_vector(1 downto 0);
signal CoreAHBLite_0_AHBmslave16_HSIZE                    : std_logic_vector(2 downto 0);

signal CoreSF2Config_0_MDDR_APBmslave_PADDR               : std_logic_vector(15 downto 2);
signal CoreSF2Config_0_MDDR_APBmslave_PADDR_0_10to2       : std_logic_vector(10 downto 2);
signal CoreSF2Config_0_MDDR_APBmslave_PADDR_0             : std_logic_vector(10 downto 2);

signal CoreSF2Config_0_MDDR_APBmslave_PRDATA_0_31to16     : std_logic_vector(31 downto 16);
signal CoreSF2Config_0_MDDR_APBmslave_PRDATA_0_15to0      : std_logic_vector(15 downto 0);
signal CoreSF2Config_0_MDDR_APBmslave_PRDATA_0            : std_logic_vector(31 downto 0);
signal CoreSF2Config_0_MDDR_APBmslave_PRDATA              : std_logic_vector(15 downto 0);

signal CoreSF2Config_0_MDDR_APBmslave_PWDATA              : std_logic_vector(31 downto 0);
signal CoreSF2Config_0_MDDR_APBmslave_PWDATA_0_15to0      : std_logic_vector(15 downto 0);
signal CoreSF2Config_0_MDDR_APBmslave_PWDATA_0            : std_logic_vector(15 downto 0);

signal my_mss_MSS_0_FIC_2_APB_MASTER_PADDR_0_16to16       : std_logic_vector(16 to 16);
signal my_mss_MSS_0_FIC_2_APB_MASTER_PADDR_0_15to2        : std_logic_vector(15 downto 2);
signal my_mss_MSS_0_FIC_2_APB_MASTER_PADDR_0              : std_logic_vector(16 downto 2);
signal my_mss_MSS_0_FIC_2_APB_MASTER_PADDR                : std_logic_vector(15 downto 2);


begin
----------------------------------------------------------------------
-- Constant assignments
----------------------------------------------------------------------
 GND_net                  <= '0';
 VCC_net                  <= '1';
 PADDR_const_net_0        <= B"000000";
 PWDATA_const_net_0       <= B"00000000";
 IADDR_const_net_0        <= B"00000000000000000000000000000000";
 SDIF0_PRDATA_const_net_0 <= B"00000000000000000000000000000000";
 SDIF1_PRDATA_const_net_0 <= B"00000000000000000000000000000000";
 SDIF2_PRDATA_const_net_0 <= B"00000000000000000000000000000000";
 SDIF3_PRDATA_const_net_0 <= B"00000000000000000000000000000000";
 FDDR_PRDATA_const_net_0  <= B"00000000000000000000000000000000";
 SDIF0_PRDATA_const_net_1 <= B"00000000000000000000000000000000";
 SDIF1_PRDATA_const_net_1 <= B"00000000000000000000000000000000";
 SDIF2_PRDATA_const_net_1 <= B"00000000000000000000000000000000";
 SDIF3_PRDATA_const_net_1 <= B"00000000000000000000000000000000";
 HADDR_M1_const_net_0     <= B"00000000000000000000000000000000";
 HTRANS_M1_const_net_0    <= B"00";
 HSIZE_M1_const_net_0     <= B"000";
 HBURST_M1_const_net_0    <= B"000";
 HPROT_M1_const_net_0     <= B"0000";
 HWDATA_M1_const_net_0    <= B"00000000000000000000000000000000";
 HADDR_M2_const_net_0     <= B"00000000000000000000000000000000";
 HTRANS_M2_const_net_0    <= B"00";
 HSIZE_M2_const_net_0     <= B"000";
 HBURST_M2_const_net_0    <= B"000";
 HPROT_M2_const_net_0     <= B"0000";
 HWDATA_M2_const_net_0    <= B"00000000000000000000000000000000";
 HADDR_M3_const_net_0     <= B"00000000000000000000000000000000";
 HTRANS_M3_const_net_0    <= B"00";
 HSIZE_M3_const_net_0     <= B"000";
 HBURST_M3_const_net_0    <= B"000";
 HPROT_M3_const_net_0     <= B"0000";
 HWDATA_M3_const_net_0    <= B"00000000000000000000000000000000";
 HRDATA_S0_const_net_0    <= B"00000000000000000000000000000000";
 HRESP_S0_const_net_0     <= B"00";
 HRDATA_S2_const_net_0    <= B"00000000000000000000000000000000";
 HRESP_S2_const_net_0     <= B"00";
 HRDATA_S3_const_net_0    <= B"00000000000000000000000000000000";
 HRESP_S3_const_net_0     <= B"00";
 HRDATA_S4_const_net_0    <= B"00000000000000000000000000000000";
 HRESP_S4_const_net_0     <= B"00";
 HRDATA_S5_const_net_0    <= B"00000000000000000000000000000000";
 HRESP_S5_const_net_0     <= B"00";
 HRDATA_S6_const_net_0    <= B"00000000000000000000000000000000";
 HRESP_S6_const_net_0     <= B"00";
 HRDATA_S7_const_net_0    <= B"00000000000000000000000000000000";
 HRESP_S7_const_net_0     <= B"00";
 HRDATA_S8_const_net_0    <= B"00000000000000000000000000000000";
 HRESP_S8_const_net_0     <= B"00";
 HRDATA_S9_const_net_0    <= B"00000000000000000000000000000000";
 HRESP_S9_const_net_0     <= B"00";
 HRDATA_S10_const_net_0   <= B"00000000000000000000000000000000";
 HRESP_S10_const_net_0    <= B"00";
 HRDATA_S11_const_net_0   <= B"00000000000000000000000000000000";
 HRESP_S11_const_net_0    <= B"00";
 HRDATA_S12_const_net_0   <= B"00000000000000000000000000000000";
 HRESP_S12_const_net_0    <= B"00";
 HRDATA_S13_const_net_0   <= B"00000000000000000000000000000000";
 HRESP_S13_const_net_0    <= B"00";
 HRDATA_S14_const_net_0   <= B"00000000000000000000000000000000";
 HRESP_S14_const_net_0    <= B"00";
 HRDATA_S15_const_net_0   <= B"00000000000000000000000000000000";
 HRESP_S15_const_net_0    <= B"00";
 PRDATAS0_const_net_0     <= B"00000000000000000000000000000000";
 PRDATAS2_const_net_0     <= B"00000000000000000000000000000000";
 PRDATAS3_const_net_0     <= B"00000000000000000000000000000000";
 PRDATAS4_const_net_0     <= B"00000000000000000000000000000000";
 PRDATAS5_const_net_0     <= B"00000000000000000000000000000000";
 PRDATAS6_const_net_0     <= B"00000000000000000000000000000000";
 PRDATAS7_const_net_0     <= B"00000000000000000000000000000000";
 PRDATAS8_const_net_0     <= B"00000000000000000000000000000000";
 PRDATAS9_const_net_0     <= B"00000000000000000000000000000000";
 PRDATAS10_const_net_0    <= B"00000000000000000000000000000000";
 PRDATAS11_const_net_0    <= B"00000000000000000000000000000000";
 PRDATAS12_const_net_0    <= B"00000000000000000000000000000000";
 PRDATAS13_const_net_0    <= B"00000000000000000000000000000000";
 PRDATAS14_const_net_0    <= B"00000000000000000000000000000000";
 PRDATAS15_const_net_0    <= B"00000000000000000000000000000000";
 PRDATAS16_const_net_0    <= B"00000000000000000000000000000000";
----------------------------------------------------------------------
-- Top level output port assignments
----------------------------------------------------------------------
 POWER_ON_RESET_N_net_1               <= POWER_ON_RESET_N_net_0;
 POWER_ON_RESET_N                     <= POWER_ON_RESET_N_net_1;
 INIT_DONE_net_1                      <= INIT_DONE_net_0;
 INIT_DONE                            <= INIT_DONE_net_1;
 FIC_0_CLK_net_1                      <= FIC_0_CLK_net_0;
 FIC_0_CLK                            <= FIC_0_CLK_net_1;
 FIC_0_LOCK_net_1                     <= FIC_0_LOCK_net_0;
 FIC_0_LOCK                           <= FIC_0_LOCK_net_1;
 MSS_READY_net_1                      <= MSS_READY_net_0;
 MSS_READY                            <= MSS_READY_net_1;
 AMBA_MASTER_0_HREADY_net_0           <= AMBA_MASTER_0_HREADY;
 AMBA_MASTER_0_HREADY_M0              <= AMBA_MASTER_0_HREADY_net_0;
 MMUART_0_TXD_M2F_net_1               <= MMUART_0_TXD_M2F_net_0;
 MMUART_0_TXD_M2F                     <= MMUART_0_TXD_M2F_net_1;
 GL1_net_1                            <= GL1_net_0;
 GL1                                  <= GL1_net_1;
 APBmslave1_PSELx_net_0               <= APBmslave1_PSELx;
 PSELS1                               <= APBmslave1_PSELx_net_0;
 APBmslave1_PENABLE_net_0             <= APBmslave1_PENABLE;
 PENABLES                             <= APBmslave1_PENABLE_net_0;
 APBmslave1_PWRITE_net_0              <= APBmslave1_PWRITE;
 PWRITES                              <= APBmslave1_PWRITE_net_0;
 AMBA_MASTER_0_HRDATA_net_0           <= AMBA_MASTER_0_HRDATA;
 AMBA_MASTER_0_HRDATA_M0(31 downto 0) <= AMBA_MASTER_0_HRDATA_net_0;
 AMBA_MASTER_0_HRESP_net_0            <= AMBA_MASTER_0_HRESP;
 AMBA_MASTER_0_HRESP_M0(1 downto 0)   <= AMBA_MASTER_0_HRESP_net_0;
 APBmslave1_PADDR_net_0               <= APBmslave1_PADDR;
 PADDRS(31 downto 0)                  <= APBmslave1_PADDR_net_0;
 APBmslave1_PWDATA_net_0              <= APBmslave1_PWDATA;
 PWDATAS(31 downto 0)                 <= APBmslave1_PWDATA_net_0;
----------------------------------------------------------------------
-- Bus Interface Nets Assignments - Unequal Pin Widths
----------------------------------------------------------------------
 CoreAHBLite_0_AHBmslave16_HRESP_0_1to1(1) <= '0';
 CoreAHBLite_0_AHBmslave16_HRESP_0_0to0(0) <= CoreAHBLite_0_AHBmslave16_HRESP;
 CoreAHBLite_0_AHBmslave16_HRESP_0 <= ( CoreAHBLite_0_AHBmslave16_HRESP_0_1to1(1) & CoreAHBLite_0_AHBmslave16_HRESP_0_0to0(0) );

 CoreAHBLite_0_AHBmslave16_HSIZE_0_1to0(1 downto 0) <= CoreAHBLite_0_AHBmslave16_HSIZE(1 downto 0);
 CoreAHBLite_0_AHBmslave16_HSIZE_0 <= ( CoreAHBLite_0_AHBmslave16_HSIZE_0_1to0(1 downto 0) );

 CoreSF2Config_0_MDDR_APBmslave_PADDR_0_10to2(10 downto 2) <= CoreSF2Config_0_MDDR_APBmslave_PADDR(10 downto 2);
 CoreSF2Config_0_MDDR_APBmslave_PADDR_0 <= ( CoreSF2Config_0_MDDR_APBmslave_PADDR_0_10to2(10 downto 2) );

 CoreSF2Config_0_MDDR_APBmslave_PRDATA_0_31to16(31 downto 16) <= B"0000000000000000";
 CoreSF2Config_0_MDDR_APBmslave_PRDATA_0_15to0(15 downto 0) <= CoreSF2Config_0_MDDR_APBmslave_PRDATA(15 downto 0);
 CoreSF2Config_0_MDDR_APBmslave_PRDATA_0 <= ( CoreSF2Config_0_MDDR_APBmslave_PRDATA_0_31to16(31 downto 16) & CoreSF2Config_0_MDDR_APBmslave_PRDATA_0_15to0(15 downto 0) );

 CoreSF2Config_0_MDDR_APBmslave_PWDATA_0_15to0(15 downto 0) <= CoreSF2Config_0_MDDR_APBmslave_PWDATA(15 downto 0);
 CoreSF2Config_0_MDDR_APBmslave_PWDATA_0 <= ( CoreSF2Config_0_MDDR_APBmslave_PWDATA_0_15to0(15 downto 0) );

 my_mss_MSS_0_FIC_2_APB_MASTER_PADDR_0_16to16(16) <= '0';
 my_mss_MSS_0_FIC_2_APB_MASTER_PADDR_0_15to2(15 downto 2) <= my_mss_MSS_0_FIC_2_APB_MASTER_PADDR(15 downto 2);
 my_mss_MSS_0_FIC_2_APB_MASTER_PADDR_0 <= ( my_mss_MSS_0_FIC_2_APB_MASTER_PADDR_0_16to16(16) & my_mss_MSS_0_FIC_2_APB_MASTER_PADDR_0_15to2(15 downto 2) );

----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
-- CCC_0   -   Actel:SgCore:FCCC:2.0.200
CCC_0 : my_mss_CCC_0_FCCC
    port map( 
        -- Inputs
        RCOSC_25_50MHZ => FABOSC_0_RCOSC_25_50MHZ_CCC_OUT_RCOSC_25_50MHZ_CCC,
        -- Outputs
        GL0            => FIC_0_CLK_net_0,
        GL1            => GL1_net_0,
        LOCK           => FIC_0_LOCK_net_0 
        );
-- CoreAHBLite_0   -   Actel:DirectCore:CoreAHBLite:5.2.100
CoreAHBLite_0 : entity COREAHBLITE_LIB.CoreAHBLite
    generic map( 
        FAMILY             => ( 19 ),
        HADDR_SHG_CFG      => ( 1 ),
        M0_AHBSLOT0ENABLE  => ( 0 ),
        M0_AHBSLOT1ENABLE  => ( 1 ),
        M0_AHBSLOT2ENABLE  => ( 0 ),
        M0_AHBSLOT3ENABLE  => ( 0 ),
        M0_AHBSLOT4ENABLE  => ( 0 ),
        M0_AHBSLOT5ENABLE  => ( 0 ),
        M0_AHBSLOT6ENABLE  => ( 0 ),
        M0_AHBSLOT7ENABLE  => ( 0 ),
        M0_AHBSLOT8ENABLE  => ( 0 ),
        M0_AHBSLOT9ENABLE  => ( 0 ),
        M0_AHBSLOT10ENABLE => ( 0 ),
        M0_AHBSLOT11ENABLE => ( 0 ),
        M0_AHBSLOT12ENABLE => ( 0 ),
        M0_AHBSLOT13ENABLE => ( 0 ),
        M0_AHBSLOT14ENABLE => ( 0 ),
        M0_AHBSLOT15ENABLE => ( 0 ),
        M0_AHBSLOT16ENABLE => ( 1 ),
        M1_AHBSLOT0ENABLE  => ( 0 ),
        M1_AHBSLOT1ENABLE  => ( 0 ),
        M1_AHBSLOT2ENABLE  => ( 0 ),
        M1_AHBSLOT3ENABLE  => ( 0 ),
        M1_AHBSLOT4ENABLE  => ( 0 ),
        M1_AHBSLOT5ENABLE  => ( 0 ),
        M1_AHBSLOT6ENABLE  => ( 0 ),
        M1_AHBSLOT7ENABLE  => ( 0 ),
        M1_AHBSLOT8ENABLE  => ( 0 ),
        M1_AHBSLOT9ENABLE  => ( 0 ),
        M1_AHBSLOT10ENABLE => ( 0 ),
        M1_AHBSLOT11ENABLE => ( 0 ),
        M1_AHBSLOT12ENABLE => ( 0 ),
        M1_AHBSLOT13ENABLE => ( 0 ),
        M1_AHBSLOT14ENABLE => ( 0 ),
        M1_AHBSLOT15ENABLE => ( 0 ),
        M1_AHBSLOT16ENABLE => ( 0 ),
        M2_AHBSLOT0ENABLE  => ( 0 ),
        M2_AHBSLOT1ENABLE  => ( 0 ),
        M2_AHBSLOT2ENABLE  => ( 0 ),
        M2_AHBSLOT3ENABLE  => ( 0 ),
        M2_AHBSLOT4ENABLE  => ( 0 ),
        M2_AHBSLOT5ENABLE  => ( 0 ),
        M2_AHBSLOT6ENABLE  => ( 0 ),
        M2_AHBSLOT7ENABLE  => ( 0 ),
        M2_AHBSLOT8ENABLE  => ( 0 ),
        M2_AHBSLOT9ENABLE  => ( 0 ),
        M2_AHBSLOT10ENABLE => ( 0 ),
        M2_AHBSLOT11ENABLE => ( 0 ),
        M2_AHBSLOT12ENABLE => ( 0 ),
        M2_AHBSLOT13ENABLE => ( 0 ),
        M2_AHBSLOT14ENABLE => ( 0 ),
        M2_AHBSLOT15ENABLE => ( 0 ),
        M2_AHBSLOT16ENABLE => ( 0 ),
        M3_AHBSLOT0ENABLE  => ( 0 ),
        M3_AHBSLOT1ENABLE  => ( 0 ),
        M3_AHBSLOT2ENABLE  => ( 0 ),
        M3_AHBSLOT3ENABLE  => ( 0 ),
        M3_AHBSLOT4ENABLE  => ( 0 ),
        M3_AHBSLOT5ENABLE  => ( 0 ),
        M3_AHBSLOT6ENABLE  => ( 0 ),
        M3_AHBSLOT7ENABLE  => ( 0 ),
        M3_AHBSLOT8ENABLE  => ( 0 ),
        M3_AHBSLOT9ENABLE  => ( 0 ),
        M3_AHBSLOT10ENABLE => ( 0 ),
        M3_AHBSLOT11ENABLE => ( 0 ),
        M3_AHBSLOT12ENABLE => ( 0 ),
        M3_AHBSLOT13ENABLE => ( 0 ),
        M3_AHBSLOT14ENABLE => ( 0 ),
        M3_AHBSLOT15ENABLE => ( 0 ),
        M3_AHBSLOT16ENABLE => ( 0 ),
        MEMSPACE           => ( 1 ),
        SC_0               => ( 1 ),
        SC_1               => ( 0 ),
        SC_2               => ( 1 ),
        SC_3               => ( 0 ),
        SC_4               => ( 1 ),
        SC_5               => ( 0 ),
        SC_6               => ( 1 ),
        SC_7               => ( 0 ),
        SC_8               => ( 0 ),
        SC_9               => ( 0 ),
        SC_10              => ( 0 ),
        SC_11              => ( 0 ),
        SC_12              => ( 0 ),
        SC_13              => ( 0 ),
        SC_14              => ( 0 ),
        SC_15              => ( 0 )
        )
    port map( 
        -- Inputs
        HCLK                  => FIC_0_CLK_net_0,
        HRESETN               => MSS_READY_net_0,
        REMAP_M0              => GND_net,
        HMASTLOCK_M0          => AMBA_MASTER_0_HMASTLOCK_M0,
        HWRITE_M0             => AMBA_MASTER_0_HWRITE_M0,
        HMASTLOCK_M1          => GND_net, -- tied to '0' from definition
        HWRITE_M1             => GND_net, -- tied to '0' from definition
        HMASTLOCK_M2          => GND_net, -- tied to '0' from definition
        HWRITE_M2             => GND_net, -- tied to '0' from definition
        HMASTLOCK_M3          => GND_net, -- tied to '0' from definition
        HWRITE_M3             => GND_net, -- tied to '0' from definition
        HREADYOUT_S0          => VCC_net, -- tied to '1' from definition
        HREADYOUT_S1          => CoreAHBLite_0_AHBmslave1_HREADYOUT,
        HREADYOUT_S2          => VCC_net, -- tied to '1' from definition
        HREADYOUT_S3          => VCC_net, -- tied to '1' from definition
        HREADYOUT_S4          => VCC_net, -- tied to '1' from definition
        HREADYOUT_S5          => VCC_net, -- tied to '1' from definition
        HREADYOUT_S6          => VCC_net, -- tied to '1' from definition
        HREADYOUT_S7          => VCC_net, -- tied to '1' from definition
        HREADYOUT_S8          => VCC_net, -- tied to '1' from definition
        HREADYOUT_S9          => VCC_net, -- tied to '1' from definition
        HREADYOUT_S10         => VCC_net, -- tied to '1' from definition
        HREADYOUT_S11         => VCC_net, -- tied to '1' from definition
        HREADYOUT_S12         => VCC_net, -- tied to '1' from definition
        HREADYOUT_S13         => VCC_net, -- tied to '1' from definition
        HREADYOUT_S14         => VCC_net, -- tied to '1' from definition
        HREADYOUT_S15         => VCC_net, -- tied to '1' from definition
        HREADYOUT_S16         => CoreAHBLite_0_AHBmslave16_HREADYOUT,
        HADDR_M0              => AMBA_MASTER_0_HADDR_M0,
        HSIZE_M0              => AMBA_MASTER_0_HSIZE_M0,
        HTRANS_M0             => AMBA_MASTER_0_HTRANS_M0,
        HWDATA_M0             => AMBA_MASTER_0_HWDATA_M0,
        HBURST_M0             => AMBA_MASTER_0_HBURST_M0,
        HPROT_M0              => AMBA_MASTER_0_HPROT_M0,
        HADDR_M1              => HADDR_M1_const_net_0, -- tied to X"0" from definition
        HSIZE_M1              => HSIZE_M1_const_net_0, -- tied to X"0" from definition
        HTRANS_M1             => HTRANS_M1_const_net_0, -- tied to X"0" from definition
        HWDATA_M1             => HWDATA_M1_const_net_0, -- tied to X"0" from definition
        HBURST_M1             => HBURST_M1_const_net_0, -- tied to X"0" from definition
        HPROT_M1              => HPROT_M1_const_net_0, -- tied to X"0" from definition
        HADDR_M2              => HADDR_M2_const_net_0, -- tied to X"0" from definition
        HSIZE_M2              => HSIZE_M2_const_net_0, -- tied to X"0" from definition
        HTRANS_M2             => HTRANS_M2_const_net_0, -- tied to X"0" from definition
        HWDATA_M2             => HWDATA_M2_const_net_0, -- tied to X"0" from definition
        HBURST_M2             => HBURST_M2_const_net_0, -- tied to X"0" from definition
        HPROT_M2              => HPROT_M2_const_net_0, -- tied to X"0" from definition
        HADDR_M3              => HADDR_M3_const_net_0, -- tied to X"0" from definition
        HSIZE_M3              => HSIZE_M3_const_net_0, -- tied to X"0" from definition
        HTRANS_M3             => HTRANS_M3_const_net_0, -- tied to X"0" from definition
        HWDATA_M3             => HWDATA_M3_const_net_0, -- tied to X"0" from definition
        HBURST_M3             => HBURST_M3_const_net_0, -- tied to X"0" from definition
        HPROT_M3              => HPROT_M3_const_net_0, -- tied to X"0" from definition
        HRDATA_S0             => HRDATA_S0_const_net_0, -- tied to X"0" from definition
        HRESP_S0              => HRESP_S0_const_net_0, -- tied to X"0" from definition
        HRDATA_S1             => CoreAHBLite_0_AHBmslave1_HRDATA,
        HRESP_S1              => CoreAHBLite_0_AHBmslave1_HRESP,
        HRDATA_S2             => HRDATA_S2_const_net_0, -- tied to X"0" from definition
        HRESP_S2              => HRESP_S2_const_net_0, -- tied to X"0" from definition
        HRDATA_S3             => HRDATA_S3_const_net_0, -- tied to X"0" from definition
        HRESP_S3              => HRESP_S3_const_net_0, -- tied to X"0" from definition
        HRDATA_S4             => HRDATA_S4_const_net_0, -- tied to X"0" from definition
        HRESP_S4              => HRESP_S4_const_net_0, -- tied to X"0" from definition
        HRDATA_S5             => HRDATA_S5_const_net_0, -- tied to X"0" from definition
        HRESP_S5              => HRESP_S5_const_net_0, -- tied to X"0" from definition
        HRDATA_S6             => HRDATA_S6_const_net_0, -- tied to X"0" from definition
        HRESP_S6              => HRESP_S6_const_net_0, -- tied to X"0" from definition
        HRDATA_S7             => HRDATA_S7_const_net_0, -- tied to X"0" from definition
        HRESP_S7              => HRESP_S7_const_net_0, -- tied to X"0" from definition
        HRDATA_S8             => HRDATA_S8_const_net_0, -- tied to X"0" from definition
        HRESP_S8              => HRESP_S8_const_net_0, -- tied to X"0" from definition
        HRDATA_S9             => HRDATA_S9_const_net_0, -- tied to X"0" from definition
        HRESP_S9              => HRESP_S9_const_net_0, -- tied to X"0" from definition
        HRDATA_S10            => HRDATA_S10_const_net_0, -- tied to X"0" from definition
        HRESP_S10             => HRESP_S10_const_net_0, -- tied to X"0" from definition
        HRDATA_S11            => HRDATA_S11_const_net_0, -- tied to X"0" from definition
        HRESP_S11             => HRESP_S11_const_net_0, -- tied to X"0" from definition
        HRDATA_S12            => HRDATA_S12_const_net_0, -- tied to X"0" from definition
        HRESP_S12             => HRESP_S12_const_net_0, -- tied to X"0" from definition
        HRDATA_S13            => HRDATA_S13_const_net_0, -- tied to X"0" from definition
        HRESP_S13             => HRESP_S13_const_net_0, -- tied to X"0" from definition
        HRDATA_S14            => HRDATA_S14_const_net_0, -- tied to X"0" from definition
        HRESP_S14             => HRESP_S14_const_net_0, -- tied to X"0" from definition
        HRDATA_S15            => HRDATA_S15_const_net_0, -- tied to X"0" from definition
        HRESP_S15             => HRESP_S15_const_net_0, -- tied to X"0" from definition
        HRDATA_S16            => CoreAHBLite_0_AHBmslave16_HRDATA,
        HRESP_S16(1 downto 0) => CoreAHBLite_0_AHBmslave16_HRESP_0,
        -- Outputs
        HREADY_M0             => AMBA_MASTER_0_HREADY,
        HREADY_M1             => OPEN,
        HREADY_M2             => OPEN,
        HREADY_M3             => OPEN,
        HSEL_S0               => OPEN,
        HWRITE_S0             => OPEN,
        HREADY_S0             => OPEN,
        HMASTLOCK_S0          => OPEN,
        HSEL_S1               => CoreAHBLite_0_AHBmslave1_HSELx,
        HWRITE_S1             => CoreAHBLite_0_AHBmslave1_HWRITE,
        HREADY_S1             => CoreAHBLite_0_AHBmslave1_HREADY,
        HMASTLOCK_S1          => CoreAHBLite_0_AHBmslave1_HMASTLOCK,
        HSEL_S2               => OPEN,
        HWRITE_S2             => OPEN,
        HREADY_S2             => OPEN,
        HMASTLOCK_S2          => OPEN,
        HSEL_S3               => OPEN,
        HWRITE_S3             => OPEN,
        HREADY_S3             => OPEN,
        HMASTLOCK_S3          => OPEN,
        HSEL_S4               => OPEN,
        HWRITE_S4             => OPEN,
        HREADY_S4             => OPEN,
        HMASTLOCK_S4          => OPEN,
        HSEL_S5               => OPEN,
        HWRITE_S5             => OPEN,
        HREADY_S5             => OPEN,
        HMASTLOCK_S5          => OPEN,
        HSEL_S6               => OPEN,
        HWRITE_S6             => OPEN,
        HREADY_S6             => OPEN,
        HMASTLOCK_S6          => OPEN,
        HSEL_S7               => OPEN,
        HWRITE_S7             => OPEN,
        HREADY_S7             => OPEN,
        HMASTLOCK_S7          => OPEN,
        HSEL_S8               => OPEN,
        HWRITE_S8             => OPEN,
        HREADY_S8             => OPEN,
        HMASTLOCK_S8          => OPEN,
        HSEL_S9               => OPEN,
        HWRITE_S9             => OPEN,
        HREADY_S9             => OPEN,
        HMASTLOCK_S9          => OPEN,
        HSEL_S10              => OPEN,
        HWRITE_S10            => OPEN,
        HREADY_S10            => OPEN,
        HMASTLOCK_S10         => OPEN,
        HSEL_S11              => OPEN,
        HWRITE_S11            => OPEN,
        HREADY_S11            => OPEN,
        HMASTLOCK_S11         => OPEN,
        HSEL_S12              => OPEN,
        HWRITE_S12            => OPEN,
        HREADY_S12            => OPEN,
        HMASTLOCK_S12         => OPEN,
        HSEL_S13              => OPEN,
        HWRITE_S13            => OPEN,
        HREADY_S13            => OPEN,
        HMASTLOCK_S13         => OPEN,
        HSEL_S14              => OPEN,
        HWRITE_S14            => OPEN,
        HREADY_S14            => OPEN,
        HMASTLOCK_S14         => OPEN,
        HSEL_S15              => OPEN,
        HWRITE_S15            => OPEN,
        HREADY_S15            => OPEN,
        HMASTLOCK_S15         => OPEN,
        HSEL_S16              => CoreAHBLite_0_AHBmslave16_HSELx,
        HWRITE_S16            => CoreAHBLite_0_AHBmslave16_HWRITE,
        HREADY_S16            => CoreAHBLite_0_AHBmslave16_HREADY,
        HMASTLOCK_S16         => CoreAHBLite_0_AHBmslave16_HMASTLOCK,
        HRESP_M0              => AMBA_MASTER_0_HRESP,
        HRDATA_M0             => AMBA_MASTER_0_HRDATA,
        HRESP_M1              => OPEN,
        HRDATA_M1             => OPEN,
        HRESP_M2              => OPEN,
        HRDATA_M2             => OPEN,
        HRESP_M3              => OPEN,
        HRDATA_M3             => OPEN,
        HADDR_S0              => OPEN,
        HSIZE_S0              => OPEN,
        HTRANS_S0             => OPEN,
        HWDATA_S0             => OPEN,
        HBURST_S0             => OPEN,
        HPROT_S0              => OPEN,
        HADDR_S1              => CoreAHBLite_0_AHBmslave1_HADDR,
        HSIZE_S1              => CoreAHBLite_0_AHBmslave1_HSIZE,
        HTRANS_S1             => CoreAHBLite_0_AHBmslave1_HTRANS,
        HWDATA_S1             => CoreAHBLite_0_AHBmslave1_HWDATA,
        HBURST_S1             => CoreAHBLite_0_AHBmslave1_HBURST,
        HPROT_S1              => CoreAHBLite_0_AHBmslave1_HPROT,
        HADDR_S2              => OPEN,
        HSIZE_S2              => OPEN,
        HTRANS_S2             => OPEN,
        HWDATA_S2             => OPEN,
        HBURST_S2             => OPEN,
        HPROT_S2              => OPEN,
        HADDR_S3              => OPEN,
        HSIZE_S3              => OPEN,
        HTRANS_S3             => OPEN,
        HWDATA_S3             => OPEN,
        HBURST_S3             => OPEN,
        HPROT_S3              => OPEN,
        HADDR_S4              => OPEN,
        HSIZE_S4              => OPEN,
        HTRANS_S4             => OPEN,
        HWDATA_S4             => OPEN,
        HBURST_S4             => OPEN,
        HPROT_S4              => OPEN,
        HADDR_S5              => OPEN,
        HSIZE_S5              => OPEN,
        HTRANS_S5             => OPEN,
        HWDATA_S5             => OPEN,
        HBURST_S5             => OPEN,
        HPROT_S5              => OPEN,
        HADDR_S6              => OPEN,
        HSIZE_S6              => OPEN,
        HTRANS_S6             => OPEN,
        HWDATA_S6             => OPEN,
        HBURST_S6             => OPEN,
        HPROT_S6              => OPEN,
        HADDR_S7              => OPEN,
        HSIZE_S7              => OPEN,
        HTRANS_S7             => OPEN,
        HWDATA_S7             => OPEN,
        HBURST_S7             => OPEN,
        HPROT_S7              => OPEN,
        HADDR_S8              => OPEN,
        HSIZE_S8              => OPEN,
        HTRANS_S8             => OPEN,
        HWDATA_S8             => OPEN,
        HBURST_S8             => OPEN,
        HPROT_S8              => OPEN,
        HADDR_S9              => OPEN,
        HSIZE_S9              => OPEN,
        HTRANS_S9             => OPEN,
        HWDATA_S9             => OPEN,
        HBURST_S9             => OPEN,
        HPROT_S9              => OPEN,
        HADDR_S10             => OPEN,
        HSIZE_S10             => OPEN,
        HTRANS_S10            => OPEN,
        HWDATA_S10            => OPEN,
        HBURST_S10            => OPEN,
        HPROT_S10             => OPEN,
        HADDR_S11             => OPEN,
        HSIZE_S11             => OPEN,
        HTRANS_S11            => OPEN,
        HWDATA_S11            => OPEN,
        HBURST_S11            => OPEN,
        HPROT_S11             => OPEN,
        HADDR_S12             => OPEN,
        HSIZE_S12             => OPEN,
        HTRANS_S12            => OPEN,
        HWDATA_S12            => OPEN,
        HBURST_S12            => OPEN,
        HPROT_S12             => OPEN,
        HADDR_S13             => OPEN,
        HSIZE_S13             => OPEN,
        HTRANS_S13            => OPEN,
        HWDATA_S13            => OPEN,
        HBURST_S13            => OPEN,
        HPROT_S13             => OPEN,
        HADDR_S14             => OPEN,
        HSIZE_S14             => OPEN,
        HTRANS_S14            => OPEN,
        HWDATA_S14            => OPEN,
        HBURST_S14            => OPEN,
        HPROT_S14             => OPEN,
        HADDR_S15             => OPEN,
        HSIZE_S15             => OPEN,
        HTRANS_S15            => OPEN,
        HWDATA_S15            => OPEN,
        HBURST_S15            => OPEN,
        HPROT_S15             => OPEN,
        HADDR_S16             => CoreAHBLite_0_AHBmslave16_HADDR,
        HSIZE_S16             => CoreAHBLite_0_AHBmslave16_HSIZE,
        HTRANS_S16            => CoreAHBLite_0_AHBmslave16_HTRANS,
        HWDATA_S16            => CoreAHBLite_0_AHBmslave16_HWDATA,
        HBURST_S16            => CoreAHBLite_0_AHBmslave16_HBURST,
        HPROT_S16             => CoreAHBLite_0_AHBmslave16_HPROT 
        );
-- COREAHBTOAPB3_0   -   Actel:DirectCore:COREAHBTOAPB3:3.1.100
COREAHBTOAPB3_0 : entity COREAHBTOAPB3_LIB.COREAHBTOAPB3
    generic map( 
        FAMILY => ( 19 )
        )
    port map( 
        -- Inputs
        HCLK      => FIC_0_CLK_net_0,
        HRESETN   => MSS_READY_net_0,
        HWRITE    => CoreAHBLite_0_AHBmslave1_HWRITE,
        HSEL      => CoreAHBLite_0_AHBmslave1_HSELx,
        HREADY    => CoreAHBLite_0_AHBmslave1_HREADY,
        PREADY    => COREAHBTOAPB3_0_APBmaster_PREADY,
        PSLVERR   => COREAHBTOAPB3_0_APBmaster_PSLVERR,
        HADDR     => CoreAHBLite_0_AHBmslave1_HADDR,
        HTRANS    => CoreAHBLite_0_AHBmslave1_HTRANS,
        HWDATA    => CoreAHBLite_0_AHBmslave1_HWDATA,
        PRDATA    => COREAHBTOAPB3_0_APBmaster_PRDATA,
        -- Outputs
        HREADYOUT => CoreAHBLite_0_AHBmslave1_HREADYOUT,
        PENABLE   => COREAHBTOAPB3_0_APBmaster_PENABLE,
        PWRITE    => COREAHBTOAPB3_0_APBmaster_PWRITE,
        PSEL      => COREAHBTOAPB3_0_APBmaster_PSELx,
        HRDATA    => CoreAHBLite_0_AHBmslave1_HRDATA,
        HRESP     => CoreAHBLite_0_AHBmslave1_HRESP,
        PWDATA    => COREAHBTOAPB3_0_APBmaster_PWDATA,
        PADDR     => COREAHBTOAPB3_0_APBmaster_PADDR 
        );
-- CoreAPB3_0   -   Actel:DirectCore:CoreAPB3:4.1.100
CoreAPB3_0 : entity COREAPB3_LIB.CoreAPB3
    generic map( 
        APB_DWIDTH      => ( 32 ),
        APBSLOT0ENABLE  => ( 0 ),
        APBSLOT1ENABLE  => ( 1 ),
        APBSLOT2ENABLE  => ( 0 ),
        APBSLOT3ENABLE  => ( 0 ),
        APBSLOT4ENABLE  => ( 0 ),
        APBSLOT5ENABLE  => ( 0 ),
        APBSLOT6ENABLE  => ( 0 ),
        APBSLOT7ENABLE  => ( 0 ),
        APBSLOT8ENABLE  => ( 0 ),
        APBSLOT9ENABLE  => ( 0 ),
        APBSLOT10ENABLE => ( 0 ),
        APBSLOT11ENABLE => ( 0 ),
        APBSLOT12ENABLE => ( 0 ),
        APBSLOT13ENABLE => ( 0 ),
        APBSLOT14ENABLE => ( 0 ),
        APBSLOT15ENABLE => ( 0 ),
        FAMILY          => ( 19 ),
        IADDR_OPTION    => ( 0 ),
        MADDR_BITS      => ( 32 ),
        SC_0            => ( 0 ),
        SC_1            => ( 0 ),
        SC_2            => ( 0 ),
        SC_3            => ( 0 ),
        SC_4            => ( 0 ),
        SC_5            => ( 0 ),
        SC_6            => ( 0 ),
        SC_7            => ( 0 ),
        SC_8            => ( 0 ),
        SC_9            => ( 0 ),
        SC_10           => ( 0 ),
        SC_11           => ( 0 ),
        SC_12           => ( 0 ),
        SC_13           => ( 0 ),
        SC_14           => ( 0 ),
        SC_15           => ( 0 ),
        UPR_NIBBLE_POSN => ( 3 )
        )
    port map( 
        -- Inputs
        PRESETN    => GND_net, -- tied to '0' from definition
        PCLK       => GND_net, -- tied to '0' from definition
        PWRITE     => COREAHBTOAPB3_0_APBmaster_PWRITE,
        PENABLE    => COREAHBTOAPB3_0_APBmaster_PENABLE,
        PSEL       => COREAHBTOAPB3_0_APBmaster_PSELx,
        PREADYS0   => VCC_net, -- tied to '1' from definition
        PSLVERRS0  => GND_net, -- tied to '0' from definition
        PREADYS1   => PREADYS1,
        PSLVERRS1  => PSLVERRS1,
        PREADYS2   => VCC_net, -- tied to '1' from definition
        PSLVERRS2  => GND_net, -- tied to '0' from definition
        PREADYS3   => VCC_net, -- tied to '1' from definition
        PSLVERRS3  => GND_net, -- tied to '0' from definition
        PREADYS4   => VCC_net, -- tied to '1' from definition
        PSLVERRS4  => GND_net, -- tied to '0' from definition
        PREADYS5   => VCC_net, -- tied to '1' from definition
        PSLVERRS5  => GND_net, -- tied to '0' from definition
        PREADYS6   => VCC_net, -- tied to '1' from definition
        PSLVERRS6  => GND_net, -- tied to '0' from definition
        PREADYS7   => VCC_net, -- tied to '1' from definition
        PSLVERRS7  => GND_net, -- tied to '0' from definition
        PREADYS8   => VCC_net, -- tied to '1' from definition
        PSLVERRS8  => GND_net, -- tied to '0' from definition
        PREADYS9   => VCC_net, -- tied to '1' from definition
        PSLVERRS9  => GND_net, -- tied to '0' from definition
        PREADYS10  => VCC_net, -- tied to '1' from definition
        PSLVERRS10 => GND_net, -- tied to '0' from definition
        PREADYS11  => VCC_net, -- tied to '1' from definition
        PSLVERRS11 => GND_net, -- tied to '0' from definition
        PREADYS12  => VCC_net, -- tied to '1' from definition
        PSLVERRS12 => GND_net, -- tied to '0' from definition
        PREADYS13  => VCC_net, -- tied to '1' from definition
        PSLVERRS13 => GND_net, -- tied to '0' from definition
        PREADYS14  => VCC_net, -- tied to '1' from definition
        PSLVERRS14 => GND_net, -- tied to '0' from definition
        PREADYS15  => VCC_net, -- tied to '1' from definition
        PSLVERRS15 => GND_net, -- tied to '0' from definition
        PREADYS16  => VCC_net, -- tied to '1' from definition
        PSLVERRS16 => GND_net, -- tied to '0' from definition
        PADDR      => COREAHBTOAPB3_0_APBmaster_PADDR,
        PWDATA     => COREAHBTOAPB3_0_APBmaster_PWDATA,
        PRDATAS0   => PRDATAS0_const_net_0, -- tied to X"0" from definition
        PRDATAS1   => PRDATAS1,
        PRDATAS2   => PRDATAS2_const_net_0, -- tied to X"0" from definition
        PRDATAS3   => PRDATAS3_const_net_0, -- tied to X"0" from definition
        PRDATAS4   => PRDATAS4_const_net_0, -- tied to X"0" from definition
        PRDATAS5   => PRDATAS5_const_net_0, -- tied to X"0" from definition
        PRDATAS6   => PRDATAS6_const_net_0, -- tied to X"0" from definition
        PRDATAS7   => PRDATAS7_const_net_0, -- tied to X"0" from definition
        PRDATAS8   => PRDATAS8_const_net_0, -- tied to X"0" from definition
        PRDATAS9   => PRDATAS9_const_net_0, -- tied to X"0" from definition
        PRDATAS10  => PRDATAS10_const_net_0, -- tied to X"0" from definition
        PRDATAS11  => PRDATAS11_const_net_0, -- tied to X"0" from definition
        PRDATAS12  => PRDATAS12_const_net_0, -- tied to X"0" from definition
        PRDATAS13  => PRDATAS13_const_net_0, -- tied to X"0" from definition
        PRDATAS14  => PRDATAS14_const_net_0, -- tied to X"0" from definition
        PRDATAS15  => PRDATAS15_const_net_0, -- tied to X"0" from definition
        PRDATAS16  => PRDATAS16_const_net_0, -- tied to X"0" from definition
        IADDR      => IADDR_const_net_0, -- tied to X"0" from definition
        -- Outputs
        PREADY     => COREAHBTOAPB3_0_APBmaster_PREADY,
        PSLVERR    => COREAHBTOAPB3_0_APBmaster_PSLVERR,
        PWRITES    => APBmslave1_PWRITE,
        PENABLES   => APBmslave1_PENABLE,
        PSELS0     => OPEN,
        PSELS1     => APBmslave1_PSELx,
        PSELS2     => OPEN,
        PSELS3     => OPEN,
        PSELS4     => OPEN,
        PSELS5     => OPEN,
        PSELS6     => OPEN,
        PSELS7     => OPEN,
        PSELS8     => OPEN,
        PSELS9     => OPEN,
        PSELS10    => OPEN,
        PSELS11    => OPEN,
        PSELS12    => OPEN,
        PSELS13    => OPEN,
        PSELS14    => OPEN,
        PSELS15    => OPEN,
        PSELS16    => OPEN,
        PRDATA     => COREAHBTOAPB3_0_APBmaster_PRDATA,
        PADDRS     => APBmslave1_PADDR,
        PWDATAS    => APBmslave1_PWDATA 
        );
-- CORERESETP_0   -   Actel:DirectCore:CoreResetP:7.0.104
CORERESETP_0 : CoreResetP
    generic map( 
        DDR_WAIT            => ( 200 ),
        DEVICE_090          => ( 0 ),
        DEVICE_VOLTAGE      => ( 2 ),
        ENABLE_SOFT_RESETS  => ( 0 ),
        EXT_RESET_CFG       => ( 0 ),
        FDDR_IN_USE         => ( 0 ),
        MDDR_IN_USE         => ( 0 ),
        SDIF0_IN_USE        => ( 0 ),
        SDIF0_PCIE          => ( 0 ),
        SDIF0_PCIE_HOTRESET => ( 1 ),
        SDIF0_PCIE_L2P2     => ( 1 ),
        SDIF1_IN_USE        => ( 0 ),
        SDIF1_PCIE          => ( 0 ),
        SDIF1_PCIE_HOTRESET => ( 1 ),
        SDIF1_PCIE_L2P2     => ( 1 ),
        SDIF2_IN_USE        => ( 0 ),
        SDIF2_PCIE          => ( 0 ),
        SDIF2_PCIE_HOTRESET => ( 1 ),
        SDIF2_PCIE_L2P2     => ( 1 ),
        SDIF3_IN_USE        => ( 0 ),
        SDIF3_PCIE          => ( 0 ),
        SDIF3_PCIE_HOTRESET => ( 1 ),
        SDIF3_PCIE_L2P2     => ( 1 )
        )
    port map( 
        -- Inputs
        RESET_N_M2F                    => my_mss_MSS_TMP_0_MSS_RESET_N_M2F,
        FIC_2_APB_M_PRESET_N           => my_mss_MSS_0_FIC_2_APB_M_PRESET_N,
        POWER_ON_RESET_N               => POWER_ON_RESET_N_net_0,
        FAB_RESET_N                    => FAB_RESET_N,
        RCOSC_25_50MHZ                 => FABOSC_0_RCOSC_25_50MHZ_O2F,
        CLK_BASE                       => FIC_0_CLK_net_0,
        CLK_LTSSM                      => GND_net, -- tied to '0' from definition
        FPLL_LOCK                      => VCC_net, -- tied to '1' from definition
        SDIF0_SPLL_LOCK                => VCC_net, -- tied to '1' from definition
        SDIF1_SPLL_LOCK                => VCC_net, -- tied to '1' from definition
        SDIF2_SPLL_LOCK                => VCC_net, -- tied to '1' from definition
        SDIF3_SPLL_LOCK                => VCC_net, -- tied to '1' from definition
        CONFIG1_DONE                   => CoreSF2Config_0_CONFIG_DONE,
        CONFIG2_DONE                   => VCC_net,
        SDIF0_PERST_N                  => VCC_net, -- tied to '1' from definition
        SDIF1_PERST_N                  => VCC_net, -- tied to '1' from definition
        SDIF2_PERST_N                  => VCC_net, -- tied to '1' from definition
        SDIF3_PERST_N                  => VCC_net, -- tied to '1' from definition
        SDIF0_PSEL                     => GND_net, -- tied to '0' from definition
        SDIF0_PWRITE                   => VCC_net, -- tied to '1' from definition
        SDIF1_PSEL                     => GND_net, -- tied to '0' from definition
        SDIF1_PWRITE                   => VCC_net, -- tied to '1' from definition
        SDIF2_PSEL                     => GND_net, -- tied to '0' from definition
        SDIF2_PWRITE                   => VCC_net, -- tied to '1' from definition
        SDIF3_PSEL                     => GND_net, -- tied to '0' from definition
        SDIF3_PWRITE                   => VCC_net, -- tied to '1' from definition
        SOFT_EXT_RESET_OUT             => GND_net, -- tied to '0' from definition
        SOFT_RESET_F2M                 => GND_net, -- tied to '0' from definition
        SOFT_M3_RESET                  => GND_net, -- tied to '0' from definition
        SOFT_MDDR_DDR_AXI_S_CORE_RESET => GND_net, -- tied to '0' from definition
        SOFT_FDDR_CORE_RESET           => GND_net, -- tied to '0' from definition
        SOFT_SDIF0_PHY_RESET           => GND_net, -- tied to '0' from definition
        SOFT_SDIF0_CORE_RESET          => GND_net, -- tied to '0' from definition
        SOFT_SDIF0_0_CORE_RESET        => GND_net, -- tied to '0' from definition
        SOFT_SDIF0_1_CORE_RESET        => GND_net, -- tied to '0' from definition
        SOFT_SDIF1_PHY_RESET           => GND_net, -- tied to '0' from definition
        SOFT_SDIF1_CORE_RESET          => GND_net, -- tied to '0' from definition
        SOFT_SDIF2_PHY_RESET           => GND_net, -- tied to '0' from definition
        SOFT_SDIF2_CORE_RESET          => GND_net, -- tied to '0' from definition
        SOFT_SDIF3_PHY_RESET           => GND_net, -- tied to '0' from definition
        SOFT_SDIF3_CORE_RESET          => GND_net, -- tied to '0' from definition
        SDIF0_PRDATA                   => SDIF0_PRDATA_const_net_0, -- tied to X"0" from definition
        SDIF1_PRDATA                   => SDIF1_PRDATA_const_net_0, -- tied to X"0" from definition
        SDIF2_PRDATA                   => SDIF2_PRDATA_const_net_0, -- tied to X"0" from definition
        SDIF3_PRDATA                   => SDIF3_PRDATA_const_net_0, -- tied to X"0" from definition
        -- Outputs
        MSS_HPMS_READY                 => MSS_READY_net_0,
        DDR_READY                      => OPEN,
        SDIF_READY                     => OPEN,
        RESET_N_F2M                    => CORERESETP_0_RESET_N_F2M,
        M3_RESET_N                     => OPEN,
        EXT_RESET_OUT                  => OPEN,
        MDDR_DDR_AXI_S_CORE_RESET_N    => OPEN,
        FDDR_CORE_RESET_N              => OPEN,
        SDIF0_CORE_RESET_N             => OPEN,
        SDIF0_0_CORE_RESET_N           => OPEN,
        SDIF0_1_CORE_RESET_N           => OPEN,
        SDIF0_PHY_RESET_N              => OPEN,
        SDIF1_CORE_RESET_N             => OPEN,
        SDIF1_PHY_RESET_N              => OPEN,
        SDIF2_CORE_RESET_N             => OPEN,
        SDIF2_PHY_RESET_N              => OPEN,
        SDIF3_CORE_RESET_N             => OPEN,
        SDIF3_PHY_RESET_N              => OPEN,
        SDIF_RELEASED                  => OPEN,
        INIT_DONE                      => INIT_DONE_net_0 
        );
-- CoreSF2Config_0   -   Actel:DirectCore:CoreSF2Config:3.0.100
CoreSF2Config_0 : CoreSF2Config
    port map( 
        -- Inputs
        FIC_2_APB_M_PRESET_N => my_mss_MSS_0_FIC_2_APB_M_PRESET_N,
        FIC_2_APB_M_PCLK     => my_mss_MSS_0_FIC_2_APB_M_PCLK,
        INIT_DONE            => INIT_DONE_net_0,
        FIC_2_APB_M_PSEL     => my_mss_MSS_0_FIC_2_APB_MASTER_PSELx,
        FIC_2_APB_M_PENABLE  => my_mss_MSS_0_FIC_2_APB_MASTER_PENABLE,
        FIC_2_APB_M_PWRITE   => my_mss_MSS_0_FIC_2_APB_MASTER_PWRITE,
        MDDR_PREADY          => CoreSF2Config_0_MDDR_APBmslave_PREADY,
        MDDR_PSLVERR         => CoreSF2Config_0_MDDR_APBmslave_PSLVERR,
        FDDR_PREADY          => VCC_net, -- tied to '1' from definition
        FDDR_PSLVERR         => GND_net, -- tied to '0' from definition
        SDIF0_PREADY         => VCC_net, -- tied to '1' from definition
        SDIF0_PSLVERR        => GND_net, -- tied to '0' from definition
        SDIF1_PREADY         => VCC_net, -- tied to '1' from definition
        SDIF1_PSLVERR        => GND_net, -- tied to '0' from definition
        SDIF2_PREADY         => VCC_net, -- tied to '1' from definition
        SDIF2_PSLVERR        => GND_net, -- tied to '0' from definition
        SDIF3_PREADY         => VCC_net, -- tied to '1' from definition
        SDIF3_PSLVERR        => GND_net, -- tied to '0' from definition
        FIC_2_APB_M_PADDR    => my_mss_MSS_0_FIC_2_APB_MASTER_PADDR_0,
        FIC_2_APB_M_PWDATA   => my_mss_MSS_0_FIC_2_APB_MASTER_PWDATA,
        MDDR_PRDATA          => CoreSF2Config_0_MDDR_APBmslave_PRDATA_0,
        FDDR_PRDATA          => FDDR_PRDATA_const_net_0, -- tied to X"0" from definition
        SDIF0_PRDATA         => SDIF0_PRDATA_const_net_1, -- tied to X"0" from definition
        SDIF1_PRDATA         => SDIF1_PRDATA_const_net_1, -- tied to X"0" from definition
        SDIF2_PRDATA         => SDIF2_PRDATA_const_net_1, -- tied to X"0" from definition
        SDIF3_PRDATA         => SDIF3_PRDATA_const_net_1, -- tied to X"0" from definition
        -- Outputs
        APB_S_PCLK           => CoreSF2Config_0_APB_S_PCLK,
        APB_S_PRESET_N       => CoreSF2Config_0_APB_S_PRESET_N,
        CLR_INIT_DONE        => OPEN,
        CONFIG_DONE          => CoreSF2Config_0_CONFIG_DONE,
        FIC_2_APB_M_PREADY   => my_mss_MSS_0_FIC_2_APB_MASTER_PREADY,
        FIC_2_APB_M_PSLVERR  => my_mss_MSS_0_FIC_2_APB_MASTER_PSLVERR,
        MDDR_PSEL            => CoreSF2Config_0_MDDR_APBmslave_PSELx,
        MDDR_PENABLE         => CoreSF2Config_0_MDDR_APBmslave_PENABLE,
        MDDR_PWRITE          => CoreSF2Config_0_MDDR_APBmslave_PWRITE,
        FDDR_PSEL            => OPEN,
        FDDR_PENABLE         => OPEN,
        FDDR_PWRITE          => OPEN,
        SDIF0_PSEL           => OPEN,
        SDIF0_PENABLE        => OPEN,
        SDIF0_PWRITE         => OPEN,
        SDIF1_PSEL           => OPEN,
        SDIF1_PENABLE        => OPEN,
        SDIF1_PWRITE         => OPEN,
        SDIF2_PSEL           => OPEN,
        SDIF2_PENABLE        => OPEN,
        SDIF2_PWRITE         => OPEN,
        SDIF3_PSEL           => OPEN,
        SDIF3_PENABLE        => OPEN,
        SDIF3_PWRITE         => OPEN,
        FIC_2_APB_M_PRDATA   => my_mss_MSS_0_FIC_2_APB_MASTER_PRDATA,
        MDDR_PADDR           => CoreSF2Config_0_MDDR_APBmslave_PADDR,
        MDDR_PWDATA          => CoreSF2Config_0_MDDR_APBmslave_PWDATA,
        FDDR_PADDR           => OPEN,
        FDDR_PWDATA          => OPEN,
        SDIF0_PADDR          => OPEN,
        SDIF0_PWDATA         => OPEN,
        SDIF1_PADDR          => OPEN,
        SDIF1_PWDATA         => OPEN,
        SDIF2_PADDR          => OPEN,
        SDIF2_PWDATA         => OPEN,
        SDIF3_PADDR          => OPEN,
        SDIF3_PWDATA         => OPEN 
        );
-- FABOSC_0   -   Actel:SgCore:OSC:2.0.101
FABOSC_0 : my_mss_FABOSC_0_OSC
    port map( 
        -- Inputs
        XTL                => GND_net, -- tied to '0' from definition
        -- Outputs
        RCOSC_25_50MHZ_CCC => FABOSC_0_RCOSC_25_50MHZ_CCC_OUT_RCOSC_25_50MHZ_CCC,
        RCOSC_25_50MHZ_O2F => FABOSC_0_RCOSC_25_50MHZ_O2F,
        RCOSC_1MHZ_CCC     => OPEN,
        RCOSC_1MHZ_O2F     => OPEN,
        XTLOSC_CCC         => OPEN,
        XTLOSC_O2F         => OPEN 
        );
-- my_mss_MSS_0
my_mss_MSS_0 : my_mss_MSS
    port map( 
        -- Inputs
        MCCC_CLK_BASE          => FIC_0_CLK_net_0,
        MCCC_CLK_BASE_PLL_LOCK => FIC_0_LOCK_net_0,
        MSS_RESET_N_F2M        => CORERESETP_0_RESET_N_F2M,
        MMUART_0_RXD_F2M       => MMUART_0_RXD_F2M,
        FIC_0_AHB_S_HREADY     => CoreAHBLite_0_AHBmslave16_HREADY,
        FIC_0_AHB_S_HWRITE     => CoreAHBLite_0_AHBmslave16_HWRITE,
        FIC_0_AHB_S_HMASTLOCK  => CoreAHBLite_0_AHBmslave16_HMASTLOCK,
        FIC_0_AHB_S_HSEL       => CoreAHBLite_0_AHBmslave16_HSELx,
        M3_RESET_N             => M3_RESET_N,
        MDDR_APB_S_PRESET_N    => CoreSF2Config_0_APB_S_PRESET_N,
        MDDR_APB_S_PCLK        => CoreSF2Config_0_APB_S_PCLK,
        FIC_2_APB_M_PREADY     => my_mss_MSS_0_FIC_2_APB_MASTER_PREADY,
        FIC_2_APB_M_PSLVERR    => my_mss_MSS_0_FIC_2_APB_MASTER_PSLVERR,
        MDDR_APB_S_PWRITE      => CoreSF2Config_0_MDDR_APBmslave_PWRITE,
        MDDR_APB_S_PENABLE     => CoreSF2Config_0_MDDR_APBmslave_PENABLE,
        MDDR_APB_S_PSEL        => CoreSF2Config_0_MDDR_APBmslave_PSELx,
        FIC_0_AHB_S_HADDR      => CoreAHBLite_0_AHBmslave16_HADDR,
        FIC_0_AHB_S_HWDATA     => CoreAHBLite_0_AHBmslave16_HWDATA,
        FIC_0_AHB_S_HSIZE      => CoreAHBLite_0_AHBmslave16_HSIZE_0,
        FIC_0_AHB_S_HTRANS     => CoreAHBLite_0_AHBmslave16_HTRANS,
        FIC_2_APB_M_PRDATA     => my_mss_MSS_0_FIC_2_APB_MASTER_PRDATA,
        MDDR_APB_S_PWDATA      => CoreSF2Config_0_MDDR_APBmslave_PWDATA_0,
        MDDR_APB_S_PADDR       => CoreSF2Config_0_MDDR_APBmslave_PADDR_0,
        -- Outputs
        MSS_RESET_N_M2F        => my_mss_MSS_TMP_0_MSS_RESET_N_M2F,
        MMUART_0_TXD_M2F       => MMUART_0_TXD_M2F_net_0,
        FIC_0_AHB_S_HRESP      => CoreAHBLite_0_AHBmslave16_HRESP,
        FIC_0_AHB_S_HREADYOUT  => CoreAHBLite_0_AHBmslave16_HREADYOUT,
        FIC_2_APB_M_PRESET_N   => my_mss_MSS_0_FIC_2_APB_M_PRESET_N,
        FIC_2_APB_M_PCLK       => my_mss_MSS_0_FIC_2_APB_M_PCLK,
        FIC_2_APB_M_PWRITE     => my_mss_MSS_0_FIC_2_APB_MASTER_PWRITE,
        FIC_2_APB_M_PENABLE    => my_mss_MSS_0_FIC_2_APB_MASTER_PENABLE,
        FIC_2_APB_M_PSEL       => my_mss_MSS_0_FIC_2_APB_MASTER_PSELx,
        MDDR_APB_S_PREADY      => CoreSF2Config_0_MDDR_APBmslave_PREADY,
        MDDR_APB_S_PSLVERR     => CoreSF2Config_0_MDDR_APBmslave_PSLVERR,
        FIC_0_AHB_S_HRDATA     => CoreAHBLite_0_AHBmslave16_HRDATA,
        FIC_2_APB_M_PADDR      => my_mss_MSS_0_FIC_2_APB_MASTER_PADDR,
        FIC_2_APB_M_PWDATA     => my_mss_MSS_0_FIC_2_APB_MASTER_PWDATA,
        MDDR_APB_S_PRDATA      => CoreSF2Config_0_MDDR_APBmslave_PRDATA 
        );
-- SYSRESET_POR
SYSRESET_POR : SYSRESET
    port map( 
        -- Inputs
        DEVRST_N         => DEVRST_N,
        -- Outputs
        POWER_ON_RESET_N => POWER_ON_RESET_N_net_0 
        );

end RTL;
