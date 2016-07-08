----------------------------------------------------------------------
-- Created by SmartDesign Sat Jul  9 11:14:55 2016
-- Version: v11.7 11.7.0.119
----------------------------------------------------------------------

----------------------------------------------------------------------
-- Libraries
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library smartfusion2;
use smartfusion2.all;
library COREGPIO_LIB;
use COREGPIO_LIB.all;
use COREGPIO_LIB.components.all;
library CORESPI_LIB;
use CORESPI_LIB.all;
library COREUARTAPB_LIB;
use COREUARTAPB_LIB.all;
use COREUARTAPB_LIB.Top_Fabric_Master_CoreUARTapb_0_components.all;
----------------------------------------------------------------------
-- Top_Fabric_Master entity declaration
----------------------------------------------------------------------
entity Top_Fabric_Master is
    -- Port list
    port(
        -- Inputs
        DEVRST_N     : in  std_logic;
        RX           : in  std_logic;
        SPISDI       : in  std_logic;
        i2s_sck_i    : in  std_logic;
        i2s_sd_i     : in  std_logic;
        i2s_ws_i     : in  std_logic;
        -- Outputs
        LED1_GREEN   : out std_logic;
        LED2_RED     : out std_logic;
        LED5B        : out std_logic;
        LED5G        : out std_logic;
        LED5R        : out std_logic;
        RESET_OUT_N  : out std_logic;
        SPISCLKO     : out std_logic;
        SPISDO       : out std_logic;
        SPISS        : out std_logic;
        SPISS_COPY   : out std_logic;
        TX           : out std_logic;
        i2s_sck_copy : out std_logic;
        i2s_sd_copy  : out std_logic;
        i2s_ws_copy  : out std_logic
        );
end Top_Fabric_Master;
----------------------------------------------------------------------
-- Top_Fabric_Master architecture body
----------------------------------------------------------------------
architecture RTL of Top_Fabric_Master is
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------
-- axi_splitter
-- using entity instantiation for component axi_splitter
-- axi_to_apb
-- using entity instantiation for component axi_to_apb
-- CoreGPIO   -   Actel:DirectCore:CoreGPIO:3.1.101
-- using entity instantiation for component CoreGPIO
-- CORESPI   -   Actel:DirectCore:CORESPI:5.0.100
component CORESPI
    generic( 
        APB_DWIDTH        : integer := 8 ;
        CFG_CLK           : integer := 7 ;
        CFG_FIFO_DEPTH    : integer := 4 ;
        CFG_FRAME_SIZE    : integer := 8 ;
        CFG_MODE          : integer := 0 ;
        CFG_MOT_MODE      : integer := 0 ;
        CFG_MOT_SSEL      : integer := 0 ;
        CFG_NSC_OPERATION : integer := 0 ;
        CFG_TI_JMB_FRAMES : integer := 0 ;
        CFG_TI_NSC_CUSTOM : integer := 0 ;
        CFG_TI_NSC_FRC    : integer := 0 ;
        FAMILY            : integer := 19 
        );
    -- Port list
    port(
        -- Inputs
        PADDR      : in  std_logic_vector(6 downto 0);
        PCLK       : in  std_logic;
        PENABLE    : in  std_logic;
        PRESETN    : in  std_logic;
        PSEL       : in  std_logic;
        PWDATA     : in  std_logic_vector(7 downto 0);
        PWRITE     : in  std_logic;
        SPICLKI    : in  std_logic;
        SPISDI     : in  std_logic;
        SPISSI     : in  std_logic;
        -- Outputs
        PRDATA     : out std_logic_vector(7 downto 0);
        PREADY     : out std_logic;
        PSLVERR    : out std_logic;
        SPIINT     : out std_logic;
        SPIMODE    : out std_logic;
        SPIOEN     : out std_logic;
        SPIRXAVAIL : out std_logic;
        SPISCLKO   : out std_logic;
        SPISDO     : out std_logic;
        SPISS      : out std_logic_vector(7 downto 0);
        SPITXRFM   : out std_logic
        );
end component;
-- Top_Fabric_Master_CoreUARTapb_0_CoreUARTapb   -   Actel:DirectCore:CoreUARTapb:5.5.101
component Top_Fabric_Master_CoreUARTapb_0_CoreUARTapb
    generic( 
        BAUD_VAL_FRCTN    : integer := 6 ;
        BAUD_VAL_FRCTN_EN : integer := 1 ;
        BAUD_VALUE        : integer := 5 ;
        FAMILY            : integer := 19 ;
        FIXEDMODE         : integer := 1 ;
        PRG_BIT8          : integer := 1 ;
        PRG_PARITY        : integer := 0 ;
        RX_FIFO           : integer := 0 ;
        RX_LEGACY_MODE    : integer := 0 ;
        TX_FIFO           : integer := 1 
        );
    -- Port list
    port(
        -- Inputs
        PADDR       : in  std_logic_vector(4 downto 0);
        PCLK        : in  std_logic;
        PENABLE     : in  std_logic;
        PRESETN     : in  std_logic;
        PSEL        : in  std_logic;
        PWDATA      : in  std_logic_vector(7 downto 0);
        PWRITE      : in  std_logic;
        RX          : in  std_logic;
        -- Outputs
        FRAMING_ERR : out std_logic;
        OVERFLOW    : out std_logic;
        PARITY_ERR  : out std_logic;
        PRDATA      : out std_logic_vector(7 downto 0);
        PREADY      : out std_logic;
        PSLVERR     : out std_logic;
        RXRDY       : out std_logic;
        TX          : out std_logic;
        TXRDY       : out std_logic
        );
end component;
-- fabric_master
-- using entity instantiation for component fabric_master
-- i2s_apb
-- using entity instantiation for component i2s_apb
-- my_mss_top
component my_mss_top
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
end component;
-- riscV_axi
-- using entity instantiation for component riscV_axi
-- vectorblox_mxp
-- using entity instantiation for component vectorblox_mxp
----------------------------------------------------------------------
-- Signal declarations
----------------------------------------------------------------------
signal axi_splitter_0_AXI_FLASH_ARADDR     : std_logic_vector(31 downto 0);
signal axi_splitter_0_AXI_FLASH_ARBURST    : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_FLASH_ARID       : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_FLASH_ARLEN      : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_FLASH_ARLOCK     : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_FLASH_ARREADY    : std_logic;
signal axi_splitter_0_AXI_FLASH_ARSIZE     : std_logic_vector(2 downto 0);
signal axi_splitter_0_AXI_FLASH_ARVALID    : std_logic;
signal axi_splitter_0_AXI_FLASH_AWADDR     : std_logic_vector(31 downto 0);
signal axi_splitter_0_AXI_FLASH_AWBURST    : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_FLASH_AWID       : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_FLASH_AWLEN      : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_FLASH_AWLOCK     : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_FLASH_AWREADY    : std_logic;
signal axi_splitter_0_AXI_FLASH_AWSIZE     : std_logic_vector(2 downto 0);
signal axi_splitter_0_AXI_FLASH_AWVALID    : std_logic;
signal axi_splitter_0_AXI_FLASH_BID        : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_FLASH_BREADY     : std_logic;
signal axi_splitter_0_AXI_FLASH_BRESP      : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_FLASH_BVALID     : std_logic;
signal axi_splitter_0_AXI_FLASH_RDATA      : std_logic_vector(31 downto 0);
signal axi_splitter_0_AXI_FLASH_RID        : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_FLASH_RLAST      : std_logic;
signal axi_splitter_0_AXI_FLASH_RREADY     : std_logic;
signal axi_splitter_0_AXI_FLASH_RRESP      : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_FLASH_RVALID     : std_logic;
signal axi_splitter_0_AXI_FLASH_WDATA      : std_logic_vector(31 downto 0);
signal axi_splitter_0_AXI_FLASH_WID        : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_FLASH_WLAST      : std_logic;
signal axi_splitter_0_AXI_FLASH_WREADY     : std_logic;
signal axi_splitter_0_AXI_FLASH_WSTRB      : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_FLASH_WVALID     : std_logic;
signal axi_splitter_0_AXI_SLAVE_0_ARADDR   : std_logic_vector(31 downto 0);
signal axi_splitter_0_AXI_SLAVE_0_ARBURST  : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_SLAVE_0_ARID     : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_0_ARLEN    : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_0_ARLOCK   : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_SLAVE_0_ARREADY  : std_logic;
signal axi_splitter_0_AXI_SLAVE_0_ARSIZE   : std_logic_vector(2 downto 0);
signal axi_splitter_0_AXI_SLAVE_0_ARVALID  : std_logic;
signal axi_splitter_0_AXI_SLAVE_0_AWADDR   : std_logic_vector(31 downto 0);
signal axi_splitter_0_AXI_SLAVE_0_AWBURST  : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_SLAVE_0_AWID     : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_0_AWLEN    : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_0_AWLOCK   : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_SLAVE_0_AWREADY  : std_logic;
signal axi_splitter_0_AXI_SLAVE_0_AWSIZE   : std_logic_vector(2 downto 0);
signal axi_splitter_0_AXI_SLAVE_0_AWVALID  : std_logic;
signal axi_splitter_0_AXI_SLAVE_0_BREADY   : std_logic;
signal axi_splitter_0_AXI_SLAVE_0_BRESP    : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_SLAVE_0_BVALID   : std_logic;
signal axi_splitter_0_AXI_SLAVE_0_RDATA    : std_logic_vector(31 downto 0);
signal axi_splitter_0_AXI_SLAVE_0_RREADY   : std_logic;
signal axi_splitter_0_AXI_SLAVE_0_RRESP    : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_SLAVE_0_RVALID   : std_logic;
signal axi_splitter_0_AXI_SLAVE_0_WDATA    : std_logic_vector(31 downto 0);
signal axi_splitter_0_AXI_SLAVE_0_WID      : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_0_WLAST    : std_logic;
signal axi_splitter_0_AXI_SLAVE_0_WREADY   : std_logic;
signal axi_splitter_0_AXI_SLAVE_0_WSTRB    : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_0_WVALID   : std_logic;
signal axi_splitter_0_AXI_SLAVE_1_ARADDR   : std_logic_vector(31 downto 0);
signal axi_splitter_0_AXI_SLAVE_1_ARBURST  : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_SLAVE_1_ARID     : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_1_ARLOCK   : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_SLAVE_1_ARREADY  : std_logic;
signal axi_splitter_0_AXI_SLAVE_1_ARSIZE   : std_logic_vector(2 downto 0);
signal axi_splitter_0_AXI_SLAVE_1_ARVALID  : std_logic;
signal axi_splitter_0_AXI_SLAVE_1_AWADDR   : std_logic_vector(31 downto 0);
signal axi_splitter_0_AXI_SLAVE_1_AWBURST  : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_SLAVE_1_AWID     : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_1_AWLOCK   : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_SLAVE_1_AWREADY  : std_logic;
signal axi_splitter_0_AXI_SLAVE_1_AWSIZE   : std_logic_vector(2 downto 0);
signal axi_splitter_0_AXI_SLAVE_1_AWVALID  : std_logic;
signal axi_splitter_0_AXI_SLAVE_1_BID      : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_1_BREADY   : std_logic;
signal axi_splitter_0_AXI_SLAVE_1_BRESP    : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_SLAVE_1_BVALID   : std_logic;
signal axi_splitter_0_AXI_SLAVE_1_RDATA    : std_logic_vector(31 downto 0);
signal axi_splitter_0_AXI_SLAVE_1_RID      : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_1_RLAST    : std_logic;
signal axi_splitter_0_AXI_SLAVE_1_RREADY   : std_logic;
signal axi_splitter_0_AXI_SLAVE_1_RRESP    : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_SLAVE_1_RVALID   : std_logic;
signal axi_splitter_0_AXI_SLAVE_1_WDATA    : std_logic_vector(31 downto 0);
signal axi_splitter_0_AXI_SLAVE_1_WID      : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_1_WLAST    : std_logic;
signal axi_splitter_0_AXI_SLAVE_1_WREADY   : std_logic;
signal axi_splitter_0_AXI_SLAVE_1_WSTRB    : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_1_WVALID   : std_logic;
signal axi_splitter_0_AXI_SLAVE_2_ARADDR   : std_logic_vector(31 downto 0);
signal axi_splitter_0_AXI_SLAVE_2_ARBURST  : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_SLAVE_2_ARID     : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_2_ARLEN    : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_2_ARLOCK   : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_SLAVE_2_ARREADY  : std_logic;
signal axi_splitter_0_AXI_SLAVE_2_ARSIZE   : std_logic_vector(2 downto 0);
signal axi_splitter_0_AXI_SLAVE_2_ARVALID  : std_logic;
signal axi_splitter_0_AXI_SLAVE_2_AWADDR   : std_logic_vector(31 downto 0);
signal axi_splitter_0_AXI_SLAVE_2_AWBURST  : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_SLAVE_2_AWID     : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_2_AWLEN    : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_2_AWLOCK   : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_SLAVE_2_AWREADY  : std_logic;
signal axi_splitter_0_AXI_SLAVE_2_AWSIZE   : std_logic_vector(2 downto 0);
signal axi_splitter_0_AXI_SLAVE_2_AWVALID  : std_logic;
signal axi_splitter_0_AXI_SLAVE_2_BID      : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_2_BREADY   : std_logic;
signal axi_splitter_0_AXI_SLAVE_2_BRESP    : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_SLAVE_2_BVALID   : std_logic;
signal axi_splitter_0_AXI_SLAVE_2_RDATA    : std_logic_vector(31 downto 0);
signal axi_splitter_0_AXI_SLAVE_2_RID      : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_2_RLAST    : std_logic;
signal axi_splitter_0_AXI_SLAVE_2_RREADY   : std_logic;
signal axi_splitter_0_AXI_SLAVE_2_RRESP    : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_SLAVE_2_RVALID   : std_logic;
signal axi_splitter_0_AXI_SLAVE_2_WDATA    : std_logic_vector(31 downto 0);
signal axi_splitter_0_AXI_SLAVE_2_WID      : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_2_WLAST    : std_logic;
signal axi_splitter_0_AXI_SLAVE_2_WREADY   : std_logic;
signal axi_splitter_0_AXI_SLAVE_2_WSTRB    : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_2_WVALID   : std_logic;
signal axi_splitter_0_AXI_SLAVE_3_ARADDR   : std_logic_vector(31 downto 0);
signal axi_splitter_0_AXI_SLAVE_3_ARBURST  : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_SLAVE_3_ARID     : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_3_ARLEN    : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_3_ARLOCK   : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_SLAVE_3_ARREADY  : std_logic;
signal axi_splitter_0_AXI_SLAVE_3_ARSIZE   : std_logic_vector(2 downto 0);
signal axi_splitter_0_AXI_SLAVE_3_ARVALID  : std_logic;
signal axi_splitter_0_AXI_SLAVE_3_AWADDR   : std_logic_vector(31 downto 0);
signal axi_splitter_0_AXI_SLAVE_3_AWBURST  : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_SLAVE_3_AWID     : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_3_AWLEN    : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_3_AWLOCK   : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_SLAVE_3_AWREADY  : std_logic;
signal axi_splitter_0_AXI_SLAVE_3_AWSIZE   : std_logic_vector(2 downto 0);
signal axi_splitter_0_AXI_SLAVE_3_AWVALID  : std_logic;
signal axi_splitter_0_AXI_SLAVE_3_BID      : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_3_BREADY   : std_logic;
signal axi_splitter_0_AXI_SLAVE_3_BRESP    : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_SLAVE_3_BVALID   : std_logic;
signal axi_splitter_0_AXI_SLAVE_3_RDATA    : std_logic_vector(31 downto 0);
signal axi_splitter_0_AXI_SLAVE_3_RID      : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_3_RLAST    : std_logic;
signal axi_splitter_0_AXI_SLAVE_3_RREADY   : std_logic;
signal axi_splitter_0_AXI_SLAVE_3_RRESP    : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_SLAVE_3_RVALID   : std_logic;
signal axi_splitter_0_AXI_SLAVE_3_WDATA    : std_logic_vector(31 downto 0);
signal axi_splitter_0_AXI_SLAVE_3_WID      : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_3_WLAST    : std_logic;
signal axi_splitter_0_AXI_SLAVE_3_WREADY   : std_logic;
signal axi_splitter_0_AXI_SLAVE_3_WSTRB    : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_3_WVALID   : std_logic;
signal axi_splitter_0_AXI_SLAVE_4_ARADDR   : std_logic_vector(31 downto 0);
signal axi_splitter_0_AXI_SLAVE_4_ARBURST  : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_SLAVE_4_ARID     : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_4_ARLEN    : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_4_ARLOCK   : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_SLAVE_4_ARREADY  : std_logic;
signal axi_splitter_0_AXI_SLAVE_4_ARSIZE   : std_logic_vector(2 downto 0);
signal axi_splitter_0_AXI_SLAVE_4_ARVALID  : std_logic;
signal axi_splitter_0_AXI_SLAVE_4_AWADDR   : std_logic_vector(31 downto 0);
signal axi_splitter_0_AXI_SLAVE_4_AWBURST  : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_SLAVE_4_AWID     : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_4_AWLEN    : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_4_AWLOCK   : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_SLAVE_4_AWREADY  : std_logic;
signal axi_splitter_0_AXI_SLAVE_4_AWSIZE   : std_logic_vector(2 downto 0);
signal axi_splitter_0_AXI_SLAVE_4_AWVALID  : std_logic;
signal axi_splitter_0_AXI_SLAVE_4_BID      : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_4_BREADY   : std_logic;
signal axi_splitter_0_AXI_SLAVE_4_BRESP    : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_SLAVE_4_BVALID   : std_logic;
signal axi_splitter_0_AXI_SLAVE_4_RDATA    : std_logic_vector(31 downto 0);
signal axi_splitter_0_AXI_SLAVE_4_RID      : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_4_RLAST    : std_logic;
signal axi_splitter_0_AXI_SLAVE_4_RREADY   : std_logic;
signal axi_splitter_0_AXI_SLAVE_4_RRESP    : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_SLAVE_4_RVALID   : std_logic;
signal axi_splitter_0_AXI_SLAVE_4_WDATA    : std_logic_vector(31 downto 0);
signal axi_splitter_0_AXI_SLAVE_4_WID      : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_4_WLAST    : std_logic;
signal axi_splitter_0_AXI_SLAVE_4_WREADY   : std_logic;
signal axi_splitter_0_AXI_SLAVE_4_WSTRB    : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_4_WVALID   : std_logic;
signal axi_splitter_0_AXI_SLAVE_5_ARADDR   : std_logic_vector(31 downto 0);
signal axi_splitter_0_AXI_SLAVE_5_ARBURST  : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_SLAVE_5_ARID     : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_5_ARLEN    : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_5_ARLOCK   : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_SLAVE_5_ARREADY  : std_logic;
signal axi_splitter_0_AXI_SLAVE_5_ARSIZE   : std_logic_vector(2 downto 0);
signal axi_splitter_0_AXI_SLAVE_5_ARVALID  : std_logic;
signal axi_splitter_0_AXI_SLAVE_5_AWADDR   : std_logic_vector(31 downto 0);
signal axi_splitter_0_AXI_SLAVE_5_AWBURST  : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_SLAVE_5_AWID     : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_5_AWLEN    : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_5_AWLOCK   : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_SLAVE_5_AWREADY  : std_logic;
signal axi_splitter_0_AXI_SLAVE_5_AWSIZE   : std_logic_vector(2 downto 0);
signal axi_splitter_0_AXI_SLAVE_5_AWVALID  : std_logic;
signal axi_splitter_0_AXI_SLAVE_5_BID      : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_5_BREADY   : std_logic;
signal axi_splitter_0_AXI_SLAVE_5_BRESP    : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_SLAVE_5_BVALID   : std_logic;
signal axi_splitter_0_AXI_SLAVE_5_RDATA    : std_logic_vector(31 downto 0);
signal axi_splitter_0_AXI_SLAVE_5_RID      : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_5_RLAST    : std_logic;
signal axi_splitter_0_AXI_SLAVE_5_RREADY   : std_logic;
signal axi_splitter_0_AXI_SLAVE_5_RRESP    : std_logic_vector(1 downto 0);
signal axi_splitter_0_AXI_SLAVE_5_RVALID   : std_logic;
signal axi_splitter_0_AXI_SLAVE_5_WDATA    : std_logic_vector(31 downto 0);
signal axi_splitter_0_AXI_SLAVE_5_WID      : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_5_WLAST    : std_logic;
signal axi_splitter_0_AXI_SLAVE_5_WREADY   : std_logic;
signal axi_splitter_0_AXI_SLAVE_5_WSTRB    : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_5_WVALID   : std_logic;
signal axi_to_apb_0_APB_SLAVE_PENABLE      : std_logic;
signal axi_to_apb_0_APB_SLAVE_PREADY       : std_logic;
signal axi_to_apb_0_APB_SLAVE_PSELx        : std_logic;
signal axi_to_apb_0_APB_SLAVE_PSLVERR      : std_logic;
signal axi_to_apb_0_APB_SLAVE_PWRITE       : std_logic;
signal axi_to_apb_1_APB_SLAVE_PENABLE      : std_logic;
signal axi_to_apb_1_APB_SLAVE_PREADY       : std_logic;
signal axi_to_apb_1_APB_SLAVE_PSELx        : std_logic;
signal axi_to_apb_1_APB_SLAVE_PSLVERR      : std_logic;
signal axi_to_apb_1_APB_SLAVE_PWRITE       : std_logic;
signal axi_to_apb_2_APB_SLAVE_PADDR        : std_logic_vector(31 downto 0);
signal axi_to_apb_2_APB_SLAVE_PENABLE      : std_logic;
signal axi_to_apb_2_APB_SLAVE_PRDATA       : std_logic_vector(31 downto 0);
signal axi_to_apb_2_APB_SLAVE_PREADY       : std_logic;
signal axi_to_apb_2_APB_SLAVE_PSELx        : std_logic;
signal axi_to_apb_2_APB_SLAVE_PWDATA       : std_logic_vector(31 downto 0);
signal axi_to_apb_2_APB_SLAVE_PWRITE       : std_logic;
signal axi_to_apb_3_APB_SLAVE_PENABLE      : std_logic;
signal axi_to_apb_3_APB_SLAVE_PRDATA       : std_logic_vector(31 downto 0);
signal axi_to_apb_3_APB_SLAVE_PREADY       : std_logic;
signal axi_to_apb_3_APB_SLAVE_PSELx        : std_logic;
signal axi_to_apb_3_APB_SLAVE_PSLVERR      : std_logic;
signal axi_to_apb_3_APB_SLAVE_PWDATA       : std_logic_vector(31 downto 0);
signal axi_to_apb_3_APB_SLAVE_PWRITE       : std_logic;
signal fabric_master_0_BIF_1_HADDR         : std_logic_vector(31 downto 0);
signal fabric_master_0_BIF_1_HBURST        : std_logic_vector(2 downto 0);
signal fabric_master_0_BIF_1_HPROT         : std_logic_vector(3 downto 0);
signal fabric_master_0_BIF_1_HRDATA        : std_logic_vector(31 downto 0);
signal fabric_master_0_BIF_1_HREADY        : std_logic;
signal fabric_master_0_BIF_1_HRESP         : std_logic_vector(1 downto 0);
signal fabric_master_0_BIF_1_HSIZE         : std_logic_vector(2 downto 0);
signal fabric_master_0_BIF_1_HTRANS        : std_logic_vector(1 downto 0);
signal fabric_master_0_BIF_1_HWDATA        : std_logic_vector(31 downto 0);
signal fabric_master_0_BIF_1_HWRITE        : std_logic;
signal LED1_GREEN_net_0                    : std_logic_vector(0 to 0);
signal LED2_RED_net_0                      : std_logic_vector(1 to 1);
signal LED5B_net_0                         : std_logic_vector(2 to 2);
signal LED5G_net_0                         : std_logic_vector(3 to 3);
signal LED5R_net_0                         : std_logic_vector(4 to 4);
signal my_mss_top_0_AMBA_SLAVE_0_0_PADDR   : std_logic_vector(31 downto 0);
signal my_mss_top_0_AMBA_SLAVE_0_0_PENABLE : std_logic;
signal my_mss_top_0_AMBA_SLAVE_0_0_PRDATA  : std_logic_vector(31 downto 0);
signal my_mss_top_0_AMBA_SLAVE_0_0_PREADY  : std_logic;
signal my_mss_top_0_AMBA_SLAVE_0_0_PSELx   : std_logic;
signal my_mss_top_0_AMBA_SLAVE_0_0_PWDATA  : std_logic_vector(31 downto 0);
signal my_mss_top_0_AMBA_SLAVE_0_0_PWRITE  : std_logic;
signal my_mss_top_0_FIC_0_CLK              : std_logic;
signal my_mss_top_0_GL1                    : std_logic;
signal my_mss_top_0_MSS_READY              : std_logic;
signal RESET_OUT_N_net_0                   : std_logic;
signal riscV_axi_0_BIF_1_ARADDR            : std_logic_vector(31 downto 0);
signal riscV_axi_0_BIF_1_ARBURST           : std_logic_vector(1 downto 0);
signal riscV_axi_0_BIF_1_ARCACHE           : std_logic_vector(3 downto 0);
signal riscV_axi_0_BIF_1_ARID              : std_logic_vector(3 downto 0);
signal riscV_axi_0_BIF_1_ARLEN             : std_logic_vector(3 downto 0);
signal riscV_axi_0_BIF_1_ARLOCK            : std_logic_vector(1 downto 0);
signal riscV_axi_0_BIF_1_ARPROT            : std_logic_vector(2 downto 0);
signal riscV_axi_0_BIF_1_ARREADY           : std_logic;
signal riscV_axi_0_BIF_1_ARSIZE            : std_logic_vector(2 downto 0);
signal riscV_axi_0_BIF_1_ARVALID           : std_logic;
signal riscV_axi_0_BIF_1_AWADDR            : std_logic_vector(31 downto 0);
signal riscV_axi_0_BIF_1_AWBURST           : std_logic_vector(1 downto 0);
signal riscV_axi_0_BIF_1_AWCACHE           : std_logic_vector(3 downto 0);
signal riscV_axi_0_BIF_1_AWID              : std_logic_vector(3 downto 0);
signal riscV_axi_0_BIF_1_AWLEN             : std_logic_vector(3 downto 0);
signal riscV_axi_0_BIF_1_AWLOCK            : std_logic_vector(1 downto 0);
signal riscV_axi_0_BIF_1_AWPROT            : std_logic_vector(2 downto 0);
signal riscV_axi_0_BIF_1_AWREADY           : std_logic;
signal riscV_axi_0_BIF_1_AWSIZE            : std_logic_vector(2 downto 0);
signal riscV_axi_0_BIF_1_AWVALID           : std_logic;
signal riscV_axi_0_BIF_1_BID               : std_logic_vector(3 downto 0);
signal riscV_axi_0_BIF_1_BREADY            : std_logic;
signal riscV_axi_0_BIF_1_BRESP             : std_logic_vector(1 downto 0);
signal riscV_axi_0_BIF_1_BVALID            : std_logic;
signal riscV_axi_0_BIF_1_RDATA             : std_logic_vector(31 downto 0);
signal riscV_axi_0_BIF_1_RID               : std_logic_vector(3 downto 0);
signal riscV_axi_0_BIF_1_RLAST             : std_logic;
signal riscV_axi_0_BIF_1_RREADY            : std_logic;
signal riscV_axi_0_BIF_1_RRESP             : std_logic_vector(1 downto 0);
signal riscV_axi_0_BIF_1_RVALID            : std_logic;
signal riscV_axi_0_BIF_1_WDATA             : std_logic_vector(31 downto 0);
signal riscV_axi_0_BIF_1_WID               : std_logic_vector(3 downto 0);
signal riscV_axi_0_BIF_1_WLAST             : std_logic;
signal riscV_axi_0_BIF_1_WREADY            : std_logic;
signal riscV_axi_0_BIF_1_WSTRB             : std_logic_vector(3 downto 0);
signal riscV_axi_0_BIF_1_WVALID            : std_logic;
signal SPISCLKO_net_0                      : std_logic;
signal SPISDO_net_0                        : std_logic;
signal SPISS_net_0                         : std_logic_vector(0 to 0);
signal TX_net_0                            : std_logic;
signal LED2_RED_net_1                      : std_logic;
signal LED5B_net_1                         : std_logic;
signal LED1_GREEN_net_1                    : std_logic;
signal LED5G_net_1                         : std_logic;
signal LED5R_net_1                         : std_logic;
signal TX_net_1                            : std_logic;
signal SPISCLKO_net_1                      : std_logic;
signal SPISS_net_1                         : std_logic;
signal SPISDO_net_1                        : std_logic;
signal SPISS_net_2                         : std_logic;
signal RESET_OUT_N_net_1                   : std_logic;
signal i2s_sd_copy_net_0                   : std_logic;
signal i2s_sck_i_net_0                     : std_logic;
signal i2s_ws_i_net_0                      : std_logic;
signal SPISS_slice_0                       : std_logic_vector(0 to 0);
signal SPISS_slice_1                       : std_logic_vector(1 to 1);
signal SPISS_slice_2                       : std_logic_vector(2 to 2);
signal SPISS_slice_3                       : std_logic_vector(3 to 3);
signal SPISS_slice_4                       : std_logic_vector(4 to 4);
signal SPISS_slice_5                       : std_logic_vector(5 to 5);
signal SPISS_slice_6                       : std_logic_vector(6 to 6);
signal SPISS_slice_7                       : std_logic_vector(7 to 7);
signal coe_to_host_slice_0                 : std_logic_vector(10 to 10);
signal coe_to_host_slice_1                 : std_logic_vector(11 to 11);
signal coe_to_host_slice_2                 : std_logic_vector(12 to 12);
signal coe_to_host_slice_3                 : std_logic_vector(13 to 13);
signal coe_to_host_slice_4                 : std_logic_vector(14 to 14);
signal coe_to_host_slice_5                 : std_logic_vector(15 to 15);
signal coe_to_host_slice_6                 : std_logic_vector(16 to 16);
signal coe_to_host_slice_7                 : std_logic_vector(17 to 17);
signal coe_to_host_slice_8                 : std_logic_vector(18 to 18);
signal coe_to_host_slice_9                 : std_logic_vector(19 to 19);
signal coe_to_host_slice_10                : std_logic_vector(20 to 20);
signal coe_to_host_slice_11                : std_logic_vector(21 to 21);
signal coe_to_host_slice_12                : std_logic_vector(22 to 22);
signal coe_to_host_slice_13                : std_logic_vector(23 to 23);
signal coe_to_host_slice_14                : std_logic_vector(24 to 24);
signal coe_to_host_slice_15                : std_logic_vector(25 to 25);
signal coe_to_host_slice_16                : std_logic_vector(26 to 26);
signal coe_to_host_slice_17                : std_logic_vector(27 to 27);
signal coe_to_host_slice_18                : std_logic_vector(28 to 28);
signal coe_to_host_slice_19                : std_logic_vector(29 to 29);
signal coe_to_host_slice_20                : std_logic_vector(30 to 30);
signal coe_to_host_slice_21                : std_logic_vector(31 to 31);
signal coe_to_host_slice_22                : std_logic_vector(5 to 5);
signal coe_to_host_slice_23                : std_logic_vector(6 to 6);
signal coe_to_host_slice_24                : std_logic_vector(7 to 7);
signal coe_to_host_slice_25                : std_logic_vector(8 to 8);
signal coe_to_host_slice_26                : std_logic_vector(9 to 9);
signal SPISS_net_3                         : std_logic_vector(7 downto 0);
signal coe_to_host_net_0                   : std_logic_vector(31 downto 0);
----------------------------------------------------------------------
-- TiedOff Signals
----------------------------------------------------------------------
signal GND_net                             : std_logic;
signal VCC_net                             : std_logic;
signal coe_from_host_const_net_0           : std_logic_vector(31 downto 0);
signal S0_BID_const_net_0                  : std_logic_vector(3 downto 0);
signal S0_RID_const_net_0                  : std_logic_vector(3 downto 0);
signal m_axi_bresp_const_net_0             : std_logic_vector(1 downto 0);
signal m_axi_rdata_const_net_0             : std_logic_vector(31 downto 0);
signal m_axi_rresp_const_net_0             : std_logic_vector(1 downto 0);
----------------------------------------------------------------------
-- Inverted Signals
----------------------------------------------------------------------
signal reset_IN_POST_INV0_0                : std_logic;
----------------------------------------------------------------------
-- Bus Interface Nets Declarations - Unequal Pin Widths
----------------------------------------------------------------------
signal axi_splitter_0_AXI_SLAVE_1_ARLEN    : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_1_ARLEN_0_7to4: std_logic_vector(7 downto 4);
signal axi_splitter_0_AXI_SLAVE_1_ARLEN_0_3to0: std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_1_ARLEN_0  : std_logic_vector(7 downto 0);

signal axi_splitter_0_AXI_SLAVE_1_AWLEN    : std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_1_AWLEN_0_7to4: std_logic_vector(7 downto 4);
signal axi_splitter_0_AXI_SLAVE_1_AWLEN_0_3to0: std_logic_vector(3 downto 0);
signal axi_splitter_0_AXI_SLAVE_1_AWLEN_0  : std_logic_vector(7 downto 0);

signal axi_to_apb_0_APB_SLAVE_PADDR        : std_logic_vector(31 downto 0);
signal axi_to_apb_0_APB_SLAVE_PADDR_0_4to0 : std_logic_vector(4 downto 0);
signal axi_to_apb_0_APB_SLAVE_PADDR_0      : std_logic_vector(4 downto 0);

signal axi_to_apb_0_APB_SLAVE_PRDATA       : std_logic_vector(7 downto 0);
signal axi_to_apb_0_APB_SLAVE_PRDATA_0_31to8: std_logic_vector(31 downto 8);
signal axi_to_apb_0_APB_SLAVE_PRDATA_0_7to0: std_logic_vector(7 downto 0);
signal axi_to_apb_0_APB_SLAVE_PRDATA_0     : std_logic_vector(31 downto 0);

signal axi_to_apb_0_APB_SLAVE_PWDATA_0_7to0: std_logic_vector(7 downto 0);
signal axi_to_apb_0_APB_SLAVE_PWDATA_0     : std_logic_vector(7 downto 0);
signal axi_to_apb_0_APB_SLAVE_PWDATA       : std_logic_vector(31 downto 0);

signal axi_to_apb_1_APB_SLAVE_PADDR_0_6to0 : std_logic_vector(6 downto 0);
signal axi_to_apb_1_APB_SLAVE_PADDR_0      : std_logic_vector(6 downto 0);
signal axi_to_apb_1_APB_SLAVE_PADDR        : std_logic_vector(31 downto 0);

signal axi_to_apb_1_APB_SLAVE_PRDATA       : std_logic_vector(7 downto 0);
signal axi_to_apb_1_APB_SLAVE_PRDATA_0_31to8: std_logic_vector(31 downto 8);
signal axi_to_apb_1_APB_SLAVE_PRDATA_0_7to0: std_logic_vector(7 downto 0);
signal axi_to_apb_1_APB_SLAVE_PRDATA_0     : std_logic_vector(31 downto 0);

signal axi_to_apb_1_APB_SLAVE_PWDATA       : std_logic_vector(31 downto 0);
signal axi_to_apb_1_APB_SLAVE_PWDATA_0_7to0: std_logic_vector(7 downto 0);
signal axi_to_apb_1_APB_SLAVE_PWDATA_0     : std_logic_vector(7 downto 0);

signal axi_to_apb_3_APB_SLAVE_PADDR        : std_logic_vector(31 downto 0);
signal axi_to_apb_3_APB_SLAVE_PADDR_0_7to0 : std_logic_vector(7 downto 0);
signal axi_to_apb_3_APB_SLAVE_PADDR_0      : std_logic_vector(7 downto 0);


begin
----------------------------------------------------------------------
-- Constant assignments
----------------------------------------------------------------------
 GND_net                   <= '0';
 VCC_net                   <= '1';
 coe_from_host_const_net_0 <= B"00000000000000000000000000000000";
 S0_BID_const_net_0        <= B"0000";
 S0_RID_const_net_0        <= B"0000";
 m_axi_bresp_const_net_0   <= B"00";
 m_axi_rdata_const_net_0   <= B"00000000000000000000000000000000";
 m_axi_rresp_const_net_0   <= B"00";
----------------------------------------------------------------------
-- Inversions
----------------------------------------------------------------------
 reset_IN_POST_INV0_0 <= NOT my_mss_top_0_MSS_READY;
----------------------------------------------------------------------
-- Top level output port assignments
----------------------------------------------------------------------
 LED2_RED_net_1    <= LED2_RED_net_0(1);
 LED2_RED          <= LED2_RED_net_1;
 LED5B_net_1       <= LED5B_net_0(2);
 LED5B             <= LED5B_net_1;
 LED1_GREEN_net_1  <= LED1_GREEN_net_0(0);
 LED1_GREEN        <= LED1_GREEN_net_1;
 LED5G_net_1       <= LED5G_net_0(3);
 LED5G             <= LED5G_net_1;
 LED5R_net_1       <= LED5R_net_0(4);
 LED5R             <= LED5R_net_1;
 TX_net_1          <= TX_net_0;
 TX                <= TX_net_1;
 SPISCLKO_net_1    <= SPISCLKO_net_0;
 SPISCLKO          <= SPISCLKO_net_1;
 SPISS_net_1       <= SPISS_net_0(0);
 SPISS             <= SPISS_net_1;
 SPISDO_net_1      <= SPISDO_net_0;
 SPISDO            <= SPISDO_net_1;
 SPISS_net_2       <= SPISS_net_0(0);
 SPISS_COPY        <= SPISS_net_2;
 RESET_OUT_N_net_1 <= RESET_OUT_N_net_0;
 RESET_OUT_N       <= RESET_OUT_N_net_1;
 i2s_sd_copy_net_0 <= i2s_sd_i;
 i2s_sd_copy       <= i2s_sd_copy_net_0;
 i2s_sck_i_net_0   <= i2s_sck_i;
 i2s_sck_copy      <= i2s_sck_i_net_0;
 i2s_ws_i_net_0    <= i2s_ws_i;
 i2s_ws_copy       <= i2s_ws_i_net_0;
----------------------------------------------------------------------
-- Slices assignments
----------------------------------------------------------------------
 LED1_GREEN_net_0(0)      <= coe_to_host_net_0(0);
 LED2_RED_net_0(1)        <= coe_to_host_net_0(1);
 LED5B_net_0(2)           <= coe_to_host_net_0(2);
 LED5G_net_0(3)           <= coe_to_host_net_0(3);
 LED5R_net_0(4)           <= coe_to_host_net_0(4);
 SPISS_slice_0(0)         <= SPISS_net_3(0);
 SPISS_slice_1(1)         <= SPISS_net_3(1);
 SPISS_slice_2(2)         <= SPISS_net_3(2);
 SPISS_slice_3(3)         <= SPISS_net_3(3);
 SPISS_slice_4(4)         <= SPISS_net_3(4);
 SPISS_slice_5(5)         <= SPISS_net_3(5);
 SPISS_slice_6(6)         <= SPISS_net_3(6);
 SPISS_slice_7(7)         <= SPISS_net_3(7);
 coe_to_host_slice_0(10)  <= coe_to_host_net_0(10);
 coe_to_host_slice_1(11)  <= coe_to_host_net_0(11);
 coe_to_host_slice_2(12)  <= coe_to_host_net_0(12);
 coe_to_host_slice_3(13)  <= coe_to_host_net_0(13);
 coe_to_host_slice_4(14)  <= coe_to_host_net_0(14);
 coe_to_host_slice_5(15)  <= coe_to_host_net_0(15);
 coe_to_host_slice_6(16)  <= coe_to_host_net_0(16);
 coe_to_host_slice_7(17)  <= coe_to_host_net_0(17);
 coe_to_host_slice_8(18)  <= coe_to_host_net_0(18);
 coe_to_host_slice_9(19)  <= coe_to_host_net_0(19);
 coe_to_host_slice_10(20) <= coe_to_host_net_0(20);
 coe_to_host_slice_11(21) <= coe_to_host_net_0(21);
 coe_to_host_slice_12(22) <= coe_to_host_net_0(22);
 coe_to_host_slice_13(23) <= coe_to_host_net_0(23);
 coe_to_host_slice_14(24) <= coe_to_host_net_0(24);
 coe_to_host_slice_15(25) <= coe_to_host_net_0(25);
 coe_to_host_slice_16(26) <= coe_to_host_net_0(26);
 coe_to_host_slice_17(27) <= coe_to_host_net_0(27);
 coe_to_host_slice_18(28) <= coe_to_host_net_0(28);
 coe_to_host_slice_19(29) <= coe_to_host_net_0(29);
 coe_to_host_slice_20(30) <= coe_to_host_net_0(30);
 coe_to_host_slice_21(31) <= coe_to_host_net_0(31);
 coe_to_host_slice_22(5)  <= coe_to_host_net_0(5);
 coe_to_host_slice_23(6)  <= coe_to_host_net_0(6);
 coe_to_host_slice_24(7)  <= coe_to_host_net_0(7);
 coe_to_host_slice_25(8)  <= coe_to_host_net_0(8);
 coe_to_host_slice_26(9)  <= coe_to_host_net_0(9);
----------------------------------------------------------------------
-- Bus Interface Nets Assignments - Unequal Pin Widths
----------------------------------------------------------------------
 axi_splitter_0_AXI_SLAVE_1_ARLEN_0_7to4(7 downto 4) <= B"0000";
 axi_splitter_0_AXI_SLAVE_1_ARLEN_0_3to0(3 downto 0) <= axi_splitter_0_AXI_SLAVE_1_ARLEN(3 downto 0);
 axi_splitter_0_AXI_SLAVE_1_ARLEN_0 <= ( axi_splitter_0_AXI_SLAVE_1_ARLEN_0_7to4(7 downto 4) & axi_splitter_0_AXI_SLAVE_1_ARLEN_0_3to0(3 downto 0) );

 axi_splitter_0_AXI_SLAVE_1_AWLEN_0_7to4(7 downto 4) <= B"0000";
 axi_splitter_0_AXI_SLAVE_1_AWLEN_0_3to0(3 downto 0) <= axi_splitter_0_AXI_SLAVE_1_AWLEN(3 downto 0);
 axi_splitter_0_AXI_SLAVE_1_AWLEN_0 <= ( axi_splitter_0_AXI_SLAVE_1_AWLEN_0_7to4(7 downto 4) & axi_splitter_0_AXI_SLAVE_1_AWLEN_0_3to0(3 downto 0) );

 axi_to_apb_0_APB_SLAVE_PADDR_0_4to0(4 downto 0) <= axi_to_apb_0_APB_SLAVE_PADDR(4 downto 0);
 axi_to_apb_0_APB_SLAVE_PADDR_0 <= ( axi_to_apb_0_APB_SLAVE_PADDR_0_4to0(4 downto 0) );

 axi_to_apb_0_APB_SLAVE_PRDATA_0_31to8(31 downto 8) <= B"000000000000000000000000";
 axi_to_apb_0_APB_SLAVE_PRDATA_0_7to0(7 downto 0) <= axi_to_apb_0_APB_SLAVE_PRDATA(7 downto 0);
 axi_to_apb_0_APB_SLAVE_PRDATA_0 <= ( axi_to_apb_0_APB_SLAVE_PRDATA_0_31to8(31 downto 8) & axi_to_apb_0_APB_SLAVE_PRDATA_0_7to0(7 downto 0) );

 axi_to_apb_0_APB_SLAVE_PWDATA_0_7to0(7 downto 0) <= axi_to_apb_0_APB_SLAVE_PWDATA(7 downto 0);
 axi_to_apb_0_APB_SLAVE_PWDATA_0 <= ( axi_to_apb_0_APB_SLAVE_PWDATA_0_7to0(7 downto 0) );

 axi_to_apb_1_APB_SLAVE_PADDR_0_6to0(6 downto 0) <= axi_to_apb_1_APB_SLAVE_PADDR(6 downto 0);
 axi_to_apb_1_APB_SLAVE_PADDR_0 <= ( axi_to_apb_1_APB_SLAVE_PADDR_0_6to0(6 downto 0) );

 axi_to_apb_1_APB_SLAVE_PRDATA_0_31to8(31 downto 8) <= B"000000000000000000000000";
 axi_to_apb_1_APB_SLAVE_PRDATA_0_7to0(7 downto 0) <= axi_to_apb_1_APB_SLAVE_PRDATA(7 downto 0);
 axi_to_apb_1_APB_SLAVE_PRDATA_0 <= ( axi_to_apb_1_APB_SLAVE_PRDATA_0_31to8(31 downto 8) & axi_to_apb_1_APB_SLAVE_PRDATA_0_7to0(7 downto 0) );

 axi_to_apb_1_APB_SLAVE_PWDATA_0_7to0(7 downto 0) <= axi_to_apb_1_APB_SLAVE_PWDATA(7 downto 0);
 axi_to_apb_1_APB_SLAVE_PWDATA_0 <= ( axi_to_apb_1_APB_SLAVE_PWDATA_0_7to0(7 downto 0) );

 axi_to_apb_3_APB_SLAVE_PADDR_0_7to0(7 downto 0) <= axi_to_apb_3_APB_SLAVE_PADDR(7 downto 0);
 axi_to_apb_3_APB_SLAVE_PADDR_0 <= ( axi_to_apb_3_APB_SLAVE_PADDR_0_7to0(7 downto 0) );

----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
-- axi_splitter_0
axi_splitter_0 : entity work.axi_splitter
    generic map( 
        BYTE_SIZE     => ( 8 ),
        REGISTER_SIZE => ( 32 )
        )
    port map( 
        -- Inputs
        M_AWVALID     => riscV_axi_0_BIF_1_AWVALID,
        M_WLAST       => riscV_axi_0_BIF_1_WLAST,
        M_WVALID      => riscV_axi_0_BIF_1_WVALID,
        M_BREADY      => riscV_axi_0_BIF_1_BREADY,
        M_ARVALID     => riscV_axi_0_BIF_1_ARVALID,
        M_RREADY      => riscV_axi_0_BIF_1_RREADY,
        S0_AWREADY    => axi_splitter_0_AXI_SLAVE_0_AWREADY,
        S0_WREADY     => axi_splitter_0_AXI_SLAVE_0_WREADY,
        S0_BVALID     => axi_splitter_0_AXI_SLAVE_0_BVALID,
        S0_ARREADY    => axi_splitter_0_AXI_SLAVE_0_ARREADY,
        S0_RLAST      => GND_net, -- tied to '0' from definition
        S0_RVALID     => axi_splitter_0_AXI_SLAVE_0_RVALID,
        S1_AWREADY    => axi_splitter_0_AXI_SLAVE_1_AWREADY,
        S1_WREADY     => axi_splitter_0_AXI_SLAVE_1_WREADY,
        S1_BVALID     => axi_splitter_0_AXI_SLAVE_1_BVALID,
        S1_ARREADY    => axi_splitter_0_AXI_SLAVE_1_ARREADY,
        S1_RLAST      => axi_splitter_0_AXI_SLAVE_1_RLAST,
        S1_RVALID     => axi_splitter_0_AXI_SLAVE_1_RVALID,
        S2_AWREADY    => axi_splitter_0_AXI_SLAVE_2_AWREADY,
        S2_WREADY     => axi_splitter_0_AXI_SLAVE_2_WREADY,
        S2_BVALID     => axi_splitter_0_AXI_SLAVE_2_BVALID,
        S2_ARREADY    => axi_splitter_0_AXI_SLAVE_2_ARREADY,
        S2_RLAST      => axi_splitter_0_AXI_SLAVE_2_RLAST,
        S2_RVALID     => axi_splitter_0_AXI_SLAVE_2_RVALID,
        S3_AWREADY    => axi_splitter_0_AXI_SLAVE_3_AWREADY,
        S3_WREADY     => axi_splitter_0_AXI_SLAVE_3_WREADY,
        S3_BVALID     => axi_splitter_0_AXI_SLAVE_3_BVALID,
        S3_ARREADY    => axi_splitter_0_AXI_SLAVE_3_ARREADY,
        S3_RLAST      => axi_splitter_0_AXI_SLAVE_3_RLAST,
        S3_RVALID     => axi_splitter_0_AXI_SLAVE_3_RVALID,
        S4_AWREADY    => axi_splitter_0_AXI_SLAVE_4_AWREADY,
        S4_WREADY     => axi_splitter_0_AXI_SLAVE_4_WREADY,
        S4_BVALID     => axi_splitter_0_AXI_SLAVE_4_BVALID,
        S4_ARREADY    => axi_splitter_0_AXI_SLAVE_4_ARREADY,
        S4_RLAST      => axi_splitter_0_AXI_SLAVE_4_RLAST,
        S4_RVALID     => axi_splitter_0_AXI_SLAVE_4_RVALID,
        FLASH_AWREADY => axi_splitter_0_AXI_FLASH_AWREADY,
        FLASH_WREADY  => axi_splitter_0_AXI_FLASH_WREADY,
        FLASH_BVALID  => axi_splitter_0_AXI_FLASH_BVALID,
        FLASH_ARREADY => axi_splitter_0_AXI_FLASH_ARREADY,
        FLASH_RLAST   => axi_splitter_0_AXI_FLASH_RLAST,
        FLASH_RVALID  => axi_splitter_0_AXI_FLASH_RVALID,
        S5_AWREADY    => axi_splitter_0_AXI_SLAVE_5_AWREADY,
        S5_WREADY     => axi_splitter_0_AXI_SLAVE_5_WREADY,
        S5_BVALID     => axi_splitter_0_AXI_SLAVE_5_BVALID,
        S5_ARREADY    => axi_splitter_0_AXI_SLAVE_5_ARREADY,
        S5_RLAST      => axi_splitter_0_AXI_SLAVE_5_RLAST,
        S5_RVALID     => axi_splitter_0_AXI_SLAVE_5_RVALID,
        M_AWID        => riscV_axi_0_BIF_1_AWID,
        M_AWADDR      => riscV_axi_0_BIF_1_AWADDR,
        M_AWLEN       => riscV_axi_0_BIF_1_AWLEN,
        M_AWSIZE      => riscV_axi_0_BIF_1_AWSIZE,
        M_AWBURST     => riscV_axi_0_BIF_1_AWBURST,
        M_AWLOCK      => riscV_axi_0_BIF_1_AWLOCK,
        M_WID         => riscV_axi_0_BIF_1_WID,
        M_WSTRB       => riscV_axi_0_BIF_1_WSTRB,
        M_WDATA       => riscV_axi_0_BIF_1_WDATA,
        M_ARID        => riscV_axi_0_BIF_1_ARID,
        M_ARADDR      => riscV_axi_0_BIF_1_ARADDR,
        M_ARLEN       => riscV_axi_0_BIF_1_ARLEN,
        M_ARSIZE      => riscV_axi_0_BIF_1_ARSIZE,
        M_ARLOCK      => riscV_axi_0_BIF_1_ARLOCK,
        M_ARBURST     => riscV_axi_0_BIF_1_ARBURST,
        S0_BID        => S0_BID_const_net_0, -- tied to X"0" from definition
        S0_BRESP      => axi_splitter_0_AXI_SLAVE_0_BRESP,
        S0_RID        => S0_RID_const_net_0, -- tied to X"0" from definition
        S0_RDATA      => axi_splitter_0_AXI_SLAVE_0_RDATA,
        S0_RRESP      => axi_splitter_0_AXI_SLAVE_0_RRESP,
        S1_BID        => axi_splitter_0_AXI_SLAVE_1_BID,
        S1_BRESP      => axi_splitter_0_AXI_SLAVE_1_BRESP,
        S1_RID        => axi_splitter_0_AXI_SLAVE_1_RID,
        S1_RDATA      => axi_splitter_0_AXI_SLAVE_1_RDATA,
        S1_RRESP      => axi_splitter_0_AXI_SLAVE_1_RRESP,
        S2_BID        => axi_splitter_0_AXI_SLAVE_2_BID,
        S2_BRESP      => axi_splitter_0_AXI_SLAVE_2_BRESP,
        S2_RID        => axi_splitter_0_AXI_SLAVE_2_RID,
        S2_RDATA      => axi_splitter_0_AXI_SLAVE_2_RDATA,
        S2_RRESP      => axi_splitter_0_AXI_SLAVE_2_RRESP,
        S3_BID        => axi_splitter_0_AXI_SLAVE_3_BID,
        S3_BRESP      => axi_splitter_0_AXI_SLAVE_3_BRESP,
        S3_RID        => axi_splitter_0_AXI_SLAVE_3_RID,
        S3_RDATA      => axi_splitter_0_AXI_SLAVE_3_RDATA,
        S3_RRESP      => axi_splitter_0_AXI_SLAVE_3_RRESP,
        S4_BID        => axi_splitter_0_AXI_SLAVE_4_BID,
        S4_BRESP      => axi_splitter_0_AXI_SLAVE_4_BRESP,
        S4_RID        => axi_splitter_0_AXI_SLAVE_4_RID,
        S4_RDATA      => axi_splitter_0_AXI_SLAVE_4_RDATA,
        S4_RRESP      => axi_splitter_0_AXI_SLAVE_4_RRESP,
        FLASH_BID     => axi_splitter_0_AXI_FLASH_BID,
        FLASH_BRESP   => axi_splitter_0_AXI_FLASH_BRESP,
        FLASH_RID     => axi_splitter_0_AXI_FLASH_RID,
        FLASH_RDATA   => axi_splitter_0_AXI_FLASH_RDATA,
        FLASH_RRESP   => axi_splitter_0_AXI_FLASH_RRESP,
        S5_BID        => axi_splitter_0_AXI_SLAVE_5_BID,
        S5_BRESP      => axi_splitter_0_AXI_SLAVE_5_BRESP,
        S5_RID        => axi_splitter_0_AXI_SLAVE_5_RID,
        S5_RDATA      => axi_splitter_0_AXI_SLAVE_5_RDATA,
        S5_RRESP      => axi_splitter_0_AXI_SLAVE_5_RRESP,
        -- Outputs
        M_AWREADY     => riscV_axi_0_BIF_1_AWREADY,
        M_WREADY      => riscV_axi_0_BIF_1_WREADY,
        M_BVALID      => riscV_axi_0_BIF_1_BVALID,
        M_ARREADY     => riscV_axi_0_BIF_1_ARREADY,
        M_RLAST       => riscV_axi_0_BIF_1_RLAST,
        M_RVALID      => riscV_axi_0_BIF_1_RVALID,
        S0_AWVALID    => axi_splitter_0_AXI_SLAVE_0_AWVALID,
        S0_WLAST      => axi_splitter_0_AXI_SLAVE_0_WLAST,
        S0_WVALID     => axi_splitter_0_AXI_SLAVE_0_WVALID,
        S0_BREADY     => axi_splitter_0_AXI_SLAVE_0_BREADY,
        S0_ARVALID    => axi_splitter_0_AXI_SLAVE_0_ARVALID,
        S0_RREADY     => axi_splitter_0_AXI_SLAVE_0_RREADY,
        S1_AWVALID    => axi_splitter_0_AXI_SLAVE_1_AWVALID,
        S1_WLAST      => axi_splitter_0_AXI_SLAVE_1_WLAST,
        S1_WVALID     => axi_splitter_0_AXI_SLAVE_1_WVALID,
        S1_BREADY     => axi_splitter_0_AXI_SLAVE_1_BREADY,
        S1_ARVALID    => axi_splitter_0_AXI_SLAVE_1_ARVALID,
        S1_RREADY     => axi_splitter_0_AXI_SLAVE_1_RREADY,
        S2_AWVALID    => axi_splitter_0_AXI_SLAVE_2_AWVALID,
        S2_WLAST      => axi_splitter_0_AXI_SLAVE_2_WLAST,
        S2_WVALID     => axi_splitter_0_AXI_SLAVE_2_WVALID,
        S2_BREADY     => axi_splitter_0_AXI_SLAVE_2_BREADY,
        S2_ARVALID    => axi_splitter_0_AXI_SLAVE_2_ARVALID,
        S2_RREADY     => axi_splitter_0_AXI_SLAVE_2_RREADY,
        S3_AWVALID    => axi_splitter_0_AXI_SLAVE_3_AWVALID,
        S3_WLAST      => axi_splitter_0_AXI_SLAVE_3_WLAST,
        S3_WVALID     => axi_splitter_0_AXI_SLAVE_3_WVALID,
        S3_BREADY     => axi_splitter_0_AXI_SLAVE_3_BREADY,
        S3_ARVALID    => axi_splitter_0_AXI_SLAVE_3_ARVALID,
        S3_RREADY     => axi_splitter_0_AXI_SLAVE_3_RREADY,
        S4_AWVALID    => axi_splitter_0_AXI_SLAVE_4_AWVALID,
        S4_WLAST      => axi_splitter_0_AXI_SLAVE_4_WLAST,
        S4_WVALID     => axi_splitter_0_AXI_SLAVE_4_WVALID,
        S4_BREADY     => axi_splitter_0_AXI_SLAVE_4_BREADY,
        S4_ARVALID    => axi_splitter_0_AXI_SLAVE_4_ARVALID,
        S4_RREADY     => axi_splitter_0_AXI_SLAVE_4_RREADY,
        FLASH_AWVALID => axi_splitter_0_AXI_FLASH_AWVALID,
        FLASH_WLAST   => axi_splitter_0_AXI_FLASH_WLAST,
        FLASH_WVALID  => axi_splitter_0_AXI_FLASH_WVALID,
        FLASH_BREADY  => axi_splitter_0_AXI_FLASH_BREADY,
        FLASH_ARVALID => axi_splitter_0_AXI_FLASH_ARVALID,
        FLASH_RREADY  => axi_splitter_0_AXI_FLASH_RREADY,
        S5_AWVALID    => axi_splitter_0_AXI_SLAVE_5_AWVALID,
        S5_WLAST      => axi_splitter_0_AXI_SLAVE_5_WLAST,
        S5_WVALID     => axi_splitter_0_AXI_SLAVE_5_WVALID,
        S5_BREADY     => axi_splitter_0_AXI_SLAVE_5_BREADY,
        S5_ARVALID    => axi_splitter_0_AXI_SLAVE_5_ARVALID,
        S5_RREADY     => axi_splitter_0_AXI_SLAVE_5_RREADY,
        M_BID         => riscV_axi_0_BIF_1_BID,
        M_BRESP       => riscV_axi_0_BIF_1_BRESP,
        M_RID         => riscV_axi_0_BIF_1_RID,
        M_RDATA       => riscV_axi_0_BIF_1_RDATA,
        M_RRESP       => riscV_axi_0_BIF_1_RRESP,
        S0_AWID       => axi_splitter_0_AXI_SLAVE_0_AWID,
        S0_AWADDR     => axi_splitter_0_AXI_SLAVE_0_AWADDR,
        S0_AWLEN      => axi_splitter_0_AXI_SLAVE_0_AWLEN,
        S0_AWSIZE     => axi_splitter_0_AXI_SLAVE_0_AWSIZE,
        S0_AWBURST    => axi_splitter_0_AXI_SLAVE_0_AWBURST,
        S0_AWLOCK     => axi_splitter_0_AXI_SLAVE_0_AWLOCK,
        S0_WID        => axi_splitter_0_AXI_SLAVE_0_WID,
        S0_WSTRB      => axi_splitter_0_AXI_SLAVE_0_WSTRB,
        S0_WDATA      => axi_splitter_0_AXI_SLAVE_0_WDATA,
        S0_ARID       => axi_splitter_0_AXI_SLAVE_0_ARID,
        S0_ARADDR     => axi_splitter_0_AXI_SLAVE_0_ARADDR,
        S0_ARLEN      => axi_splitter_0_AXI_SLAVE_0_ARLEN,
        S0_ARSIZE     => axi_splitter_0_AXI_SLAVE_0_ARSIZE,
        S0_ARLOCK     => axi_splitter_0_AXI_SLAVE_0_ARLOCK,
        S0_ARBURST    => axi_splitter_0_AXI_SLAVE_0_ARBURST,
        S1_AWID       => axi_splitter_0_AXI_SLAVE_1_AWID,
        S1_AWADDR     => axi_splitter_0_AXI_SLAVE_1_AWADDR,
        S1_AWLEN      => axi_splitter_0_AXI_SLAVE_1_AWLEN,
        S1_AWSIZE     => axi_splitter_0_AXI_SLAVE_1_AWSIZE,
        S1_AWBURST    => axi_splitter_0_AXI_SLAVE_1_AWBURST,
        S1_AWLOCK     => axi_splitter_0_AXI_SLAVE_1_AWLOCK,
        S1_WID        => axi_splitter_0_AXI_SLAVE_1_WID,
        S1_WSTRB      => axi_splitter_0_AXI_SLAVE_1_WSTRB,
        S1_WDATA      => axi_splitter_0_AXI_SLAVE_1_WDATA,
        S1_ARID       => axi_splitter_0_AXI_SLAVE_1_ARID,
        S1_ARADDR     => axi_splitter_0_AXI_SLAVE_1_ARADDR,
        S1_ARLEN      => axi_splitter_0_AXI_SLAVE_1_ARLEN,
        S1_ARSIZE     => axi_splitter_0_AXI_SLAVE_1_ARSIZE,
        S1_ARLOCK     => axi_splitter_0_AXI_SLAVE_1_ARLOCK,
        S1_ARBURST    => axi_splitter_0_AXI_SLAVE_1_ARBURST,
        S2_AWID       => axi_splitter_0_AXI_SLAVE_2_AWID,
        S2_AWADDR     => axi_splitter_0_AXI_SLAVE_2_AWADDR,
        S2_AWLEN      => axi_splitter_0_AXI_SLAVE_2_AWLEN,
        S2_AWSIZE     => axi_splitter_0_AXI_SLAVE_2_AWSIZE,
        S2_AWBURST    => axi_splitter_0_AXI_SLAVE_2_AWBURST,
        S2_AWLOCK     => axi_splitter_0_AXI_SLAVE_2_AWLOCK,
        S2_WID        => axi_splitter_0_AXI_SLAVE_2_WID,
        S2_WSTRB      => axi_splitter_0_AXI_SLAVE_2_WSTRB,
        S2_WDATA      => axi_splitter_0_AXI_SLAVE_2_WDATA,
        S2_ARID       => axi_splitter_0_AXI_SLAVE_2_ARID,
        S2_ARADDR     => axi_splitter_0_AXI_SLAVE_2_ARADDR,
        S2_ARLEN      => axi_splitter_0_AXI_SLAVE_2_ARLEN,
        S2_ARSIZE     => axi_splitter_0_AXI_SLAVE_2_ARSIZE,
        S2_ARLOCK     => axi_splitter_0_AXI_SLAVE_2_ARLOCK,
        S2_ARBURST    => axi_splitter_0_AXI_SLAVE_2_ARBURST,
        S3_AWID       => axi_splitter_0_AXI_SLAVE_3_AWID,
        S3_AWADDR     => axi_splitter_0_AXI_SLAVE_3_AWADDR,
        S3_AWLEN      => axi_splitter_0_AXI_SLAVE_3_AWLEN,
        S3_AWSIZE     => axi_splitter_0_AXI_SLAVE_3_AWSIZE,
        S3_AWBURST    => axi_splitter_0_AXI_SLAVE_3_AWBURST,
        S3_AWLOCK     => axi_splitter_0_AXI_SLAVE_3_AWLOCK,
        S3_WID        => axi_splitter_0_AXI_SLAVE_3_WID,
        S3_WSTRB      => axi_splitter_0_AXI_SLAVE_3_WSTRB,
        S3_WDATA      => axi_splitter_0_AXI_SLAVE_3_WDATA,
        S3_ARID       => axi_splitter_0_AXI_SLAVE_3_ARID,
        S3_ARADDR     => axi_splitter_0_AXI_SLAVE_3_ARADDR,
        S3_ARLEN      => axi_splitter_0_AXI_SLAVE_3_ARLEN,
        S3_ARSIZE     => axi_splitter_0_AXI_SLAVE_3_ARSIZE,
        S3_ARLOCK     => axi_splitter_0_AXI_SLAVE_3_ARLOCK,
        S3_ARBURST    => axi_splitter_0_AXI_SLAVE_3_ARBURST,
        S4_AWID       => axi_splitter_0_AXI_SLAVE_4_AWID,
        S4_AWADDR     => axi_splitter_0_AXI_SLAVE_4_AWADDR,
        S4_AWLEN      => axi_splitter_0_AXI_SLAVE_4_AWLEN,
        S4_AWSIZE     => axi_splitter_0_AXI_SLAVE_4_AWSIZE,
        S4_AWBURST    => axi_splitter_0_AXI_SLAVE_4_AWBURST,
        S4_AWLOCK     => axi_splitter_0_AXI_SLAVE_4_AWLOCK,
        S4_WID        => axi_splitter_0_AXI_SLAVE_4_WID,
        S4_WSTRB      => axi_splitter_0_AXI_SLAVE_4_WSTRB,
        S4_WDATA      => axi_splitter_0_AXI_SLAVE_4_WDATA,
        S4_ARID       => axi_splitter_0_AXI_SLAVE_4_ARID,
        S4_ARADDR     => axi_splitter_0_AXI_SLAVE_4_ARADDR,
        S4_ARLEN      => axi_splitter_0_AXI_SLAVE_4_ARLEN,
        S4_ARSIZE     => axi_splitter_0_AXI_SLAVE_4_ARSIZE,
        S4_ARLOCK     => axi_splitter_0_AXI_SLAVE_4_ARLOCK,
        S4_ARBURST    => axi_splitter_0_AXI_SLAVE_4_ARBURST,
        FLASH_AWID    => axi_splitter_0_AXI_FLASH_AWID,
        FLASH_AWADDR  => axi_splitter_0_AXI_FLASH_AWADDR,
        FLASH_AWLEN   => axi_splitter_0_AXI_FLASH_AWLEN,
        FLASH_AWSIZE  => axi_splitter_0_AXI_FLASH_AWSIZE,
        FLASH_AWBURST => axi_splitter_0_AXI_FLASH_AWBURST,
        FLASH_AWLOCK  => axi_splitter_0_AXI_FLASH_AWLOCK,
        FLASH_WID     => axi_splitter_0_AXI_FLASH_WID,
        FLASH_WSTRB   => axi_splitter_0_AXI_FLASH_WSTRB,
        FLASH_WDATA   => axi_splitter_0_AXI_FLASH_WDATA,
        FLASH_ARID    => axi_splitter_0_AXI_FLASH_ARID,
        FLASH_ARADDR  => axi_splitter_0_AXI_FLASH_ARADDR,
        FLASH_ARLEN   => axi_splitter_0_AXI_FLASH_ARLEN,
        FLASH_ARSIZE  => axi_splitter_0_AXI_FLASH_ARSIZE,
        FLASH_ARLOCK  => axi_splitter_0_AXI_FLASH_ARLOCK,
        FLASH_ARBURST => axi_splitter_0_AXI_FLASH_ARBURST,
        S5_AWID       => axi_splitter_0_AXI_SLAVE_5_AWID,
        S5_AWADDR     => axi_splitter_0_AXI_SLAVE_5_AWADDR,
        S5_AWLEN      => axi_splitter_0_AXI_SLAVE_5_AWLEN,
        S5_AWSIZE     => axi_splitter_0_AXI_SLAVE_5_AWSIZE,
        S5_AWBURST    => axi_splitter_0_AXI_SLAVE_5_AWBURST,
        S5_AWLOCK     => axi_splitter_0_AXI_SLAVE_5_AWLOCK,
        S5_WID        => axi_splitter_0_AXI_SLAVE_5_WID,
        S5_WSTRB      => axi_splitter_0_AXI_SLAVE_5_WSTRB,
        S5_WDATA      => axi_splitter_0_AXI_SLAVE_5_WDATA,
        S5_ARID       => axi_splitter_0_AXI_SLAVE_5_ARID,
        S5_ARADDR     => axi_splitter_0_AXI_SLAVE_5_ARADDR,
        S5_ARLEN      => axi_splitter_0_AXI_SLAVE_5_ARLEN,
        S5_ARSIZE     => axi_splitter_0_AXI_SLAVE_5_ARSIZE,
        S5_ARLOCK     => axi_splitter_0_AXI_SLAVE_5_ARLOCK,
        S5_ARBURST    => axi_splitter_0_AXI_SLAVE_5_ARBURST 
        );
-- axi_to_apb_0
axi_to_apb_0 : entity work.axi_to_apb
    generic map( 
        BYTE_SIZE     => ( 8 ),
        REGISTER_SIZE => ( 32 )
        )
    port map( 
        -- Inputs
        clk     => my_mss_top_0_FIC_0_CLK,
        aresetn => my_mss_top_0_MSS_READY,
        AWVALID => axi_splitter_0_AXI_SLAVE_2_AWVALID,
        WLAST   => axi_splitter_0_AXI_SLAVE_2_WLAST,
        WVALID  => axi_splitter_0_AXI_SLAVE_2_WVALID,
        BREADY  => axi_splitter_0_AXI_SLAVE_2_BREADY,
        ARVALID => axi_splitter_0_AXI_SLAVE_2_ARVALID,
        RREADY  => axi_splitter_0_AXI_SLAVE_2_RREADY,
        PREADY  => axi_to_apb_0_APB_SLAVE_PREADY,
        AWID    => axi_splitter_0_AXI_SLAVE_2_AWID,
        AWADDR  => axi_splitter_0_AXI_SLAVE_2_AWADDR,
        AWLEN   => axi_splitter_0_AXI_SLAVE_2_AWLEN,
        AWSIZE  => axi_splitter_0_AXI_SLAVE_2_AWSIZE,
        AWBURST => axi_splitter_0_AXI_SLAVE_2_AWBURST,
        AWLOCK  => axi_splitter_0_AXI_SLAVE_2_AWLOCK,
        WID     => axi_splitter_0_AXI_SLAVE_2_WID,
        WSTRB   => axi_splitter_0_AXI_SLAVE_2_WSTRB,
        WDATA   => axi_splitter_0_AXI_SLAVE_2_WDATA,
        ARID    => axi_splitter_0_AXI_SLAVE_2_ARID,
        ARADDR  => axi_splitter_0_AXI_SLAVE_2_ARADDR,
        ARLEN   => axi_splitter_0_AXI_SLAVE_2_ARLEN,
        ARSIZE  => axi_splitter_0_AXI_SLAVE_2_ARSIZE,
        ARLOCK  => axi_splitter_0_AXI_SLAVE_2_ARLOCK,
        ARBURST => axi_splitter_0_AXI_SLAVE_2_ARBURST,
        PRDATA  => axi_to_apb_0_APB_SLAVE_PRDATA_0,
        -- Outputs
        AWREADY => axi_splitter_0_AXI_SLAVE_2_AWREADY,
        WREADY  => axi_splitter_0_AXI_SLAVE_2_WREADY,
        BVALID  => axi_splitter_0_AXI_SLAVE_2_BVALID,
        ARREADY => axi_splitter_0_AXI_SLAVE_2_ARREADY,
        RLAST   => axi_splitter_0_AXI_SLAVE_2_RLAST,
        RVALID  => axi_splitter_0_AXI_SLAVE_2_RVALID,
        PENABLE => axi_to_apb_0_APB_SLAVE_PENABLE,
        PWRITE  => axi_to_apb_0_APB_SLAVE_PWRITE,
        PSEL    => axi_to_apb_0_APB_SLAVE_PSELx,
        BID     => axi_splitter_0_AXI_SLAVE_2_BID,
        BRESP   => axi_splitter_0_AXI_SLAVE_2_BRESP,
        RID     => axi_splitter_0_AXI_SLAVE_2_RID,
        RDATA   => axi_splitter_0_AXI_SLAVE_2_RDATA,
        RRESP   => axi_splitter_0_AXI_SLAVE_2_RRESP,
        PADDR   => axi_to_apb_0_APB_SLAVE_PADDR,
        PWDATA  => axi_to_apb_0_APB_SLAVE_PWDATA 
        );
-- axi_to_apb_1
axi_to_apb_1 : entity work.axi_to_apb
    generic map( 
        BYTE_SIZE     => ( 8 ),
        REGISTER_SIZE => ( 32 )
        )
    port map( 
        -- Inputs
        clk     => my_mss_top_0_FIC_0_CLK,
        aresetn => my_mss_top_0_MSS_READY,
        AWVALID => axi_splitter_0_AXI_SLAVE_3_AWVALID,
        WLAST   => axi_splitter_0_AXI_SLAVE_3_WLAST,
        WVALID  => axi_splitter_0_AXI_SLAVE_3_WVALID,
        BREADY  => axi_splitter_0_AXI_SLAVE_3_BREADY,
        ARVALID => axi_splitter_0_AXI_SLAVE_3_ARVALID,
        RREADY  => axi_splitter_0_AXI_SLAVE_3_RREADY,
        PREADY  => axi_to_apb_1_APB_SLAVE_PREADY,
        AWID    => axi_splitter_0_AXI_SLAVE_3_AWID,
        AWADDR  => axi_splitter_0_AXI_SLAVE_3_AWADDR,
        AWLEN   => axi_splitter_0_AXI_SLAVE_3_AWLEN,
        AWSIZE  => axi_splitter_0_AXI_SLAVE_3_AWSIZE,
        AWBURST => axi_splitter_0_AXI_SLAVE_3_AWBURST,
        AWLOCK  => axi_splitter_0_AXI_SLAVE_3_AWLOCK,
        WID     => axi_splitter_0_AXI_SLAVE_3_WID,
        WSTRB   => axi_splitter_0_AXI_SLAVE_3_WSTRB,
        WDATA   => axi_splitter_0_AXI_SLAVE_3_WDATA,
        ARID    => axi_splitter_0_AXI_SLAVE_3_ARID,
        ARADDR  => axi_splitter_0_AXI_SLAVE_3_ARADDR,
        ARLEN   => axi_splitter_0_AXI_SLAVE_3_ARLEN,
        ARSIZE  => axi_splitter_0_AXI_SLAVE_3_ARSIZE,
        ARLOCK  => axi_splitter_0_AXI_SLAVE_3_ARLOCK,
        ARBURST => axi_splitter_0_AXI_SLAVE_3_ARBURST,
        PRDATA  => axi_to_apb_1_APB_SLAVE_PRDATA_0,
        -- Outputs
        AWREADY => axi_splitter_0_AXI_SLAVE_3_AWREADY,
        WREADY  => axi_splitter_0_AXI_SLAVE_3_WREADY,
        BVALID  => axi_splitter_0_AXI_SLAVE_3_BVALID,
        ARREADY => axi_splitter_0_AXI_SLAVE_3_ARREADY,
        RLAST   => axi_splitter_0_AXI_SLAVE_3_RLAST,
        RVALID  => axi_splitter_0_AXI_SLAVE_3_RVALID,
        PENABLE => axi_to_apb_1_APB_SLAVE_PENABLE,
        PWRITE  => axi_to_apb_1_APB_SLAVE_PWRITE,
        PSEL    => axi_to_apb_1_APB_SLAVE_PSELx,
        BID     => axi_splitter_0_AXI_SLAVE_3_BID,
        BRESP   => axi_splitter_0_AXI_SLAVE_3_BRESP,
        RID     => axi_splitter_0_AXI_SLAVE_3_RID,
        RDATA   => axi_splitter_0_AXI_SLAVE_3_RDATA,
        RRESP   => axi_splitter_0_AXI_SLAVE_3_RRESP,
        PADDR   => axi_to_apb_1_APB_SLAVE_PADDR,
        PWDATA  => axi_to_apb_1_APB_SLAVE_PWDATA 
        );
-- axi_to_apb_2
axi_to_apb_2 : entity work.axi_to_apb
    generic map( 
        BYTE_SIZE     => ( 8 ),
        REGISTER_SIZE => ( 32 )
        )
    port map( 
        -- Inputs
        clk     => my_mss_top_0_FIC_0_CLK,
        aresetn => my_mss_top_0_MSS_READY,
        AWVALID => axi_splitter_0_AXI_SLAVE_4_AWVALID,
        WLAST   => axi_splitter_0_AXI_SLAVE_4_WLAST,
        WVALID  => axi_splitter_0_AXI_SLAVE_4_WVALID,
        BREADY  => axi_splitter_0_AXI_SLAVE_4_BREADY,
        ARVALID => axi_splitter_0_AXI_SLAVE_4_ARVALID,
        RREADY  => axi_splitter_0_AXI_SLAVE_4_RREADY,
        PREADY  => axi_to_apb_2_APB_SLAVE_PREADY,
        AWID    => axi_splitter_0_AXI_SLAVE_4_AWID,
        AWADDR  => axi_splitter_0_AXI_SLAVE_4_AWADDR,
        AWLEN   => axi_splitter_0_AXI_SLAVE_4_AWLEN,
        AWSIZE  => axi_splitter_0_AXI_SLAVE_4_AWSIZE,
        AWBURST => axi_splitter_0_AXI_SLAVE_4_AWBURST,
        AWLOCK  => axi_splitter_0_AXI_SLAVE_4_AWLOCK,
        WID     => axi_splitter_0_AXI_SLAVE_4_WID,
        WSTRB   => axi_splitter_0_AXI_SLAVE_4_WSTRB,
        WDATA   => axi_splitter_0_AXI_SLAVE_4_WDATA,
        ARID    => axi_splitter_0_AXI_SLAVE_4_ARID,
        ARADDR  => axi_splitter_0_AXI_SLAVE_4_ARADDR,
        ARLEN   => axi_splitter_0_AXI_SLAVE_4_ARLEN,
        ARSIZE  => axi_splitter_0_AXI_SLAVE_4_ARSIZE,
        ARLOCK  => axi_splitter_0_AXI_SLAVE_4_ARLOCK,
        ARBURST => axi_splitter_0_AXI_SLAVE_4_ARBURST,
        PRDATA  => axi_to_apb_2_APB_SLAVE_PRDATA,
        -- Outputs
        AWREADY => axi_splitter_0_AXI_SLAVE_4_AWREADY,
        WREADY  => axi_splitter_0_AXI_SLAVE_4_WREADY,
        BVALID  => axi_splitter_0_AXI_SLAVE_4_BVALID,
        ARREADY => axi_splitter_0_AXI_SLAVE_4_ARREADY,
        RLAST   => axi_splitter_0_AXI_SLAVE_4_RLAST,
        RVALID  => axi_splitter_0_AXI_SLAVE_4_RVALID,
        PENABLE => axi_to_apb_2_APB_SLAVE_PENABLE,
        PWRITE  => axi_to_apb_2_APB_SLAVE_PWRITE,
        PSEL    => axi_to_apb_2_APB_SLAVE_PSELx,
        BID     => axi_splitter_0_AXI_SLAVE_4_BID,
        BRESP   => axi_splitter_0_AXI_SLAVE_4_BRESP,
        RID     => axi_splitter_0_AXI_SLAVE_4_RID,
        RDATA   => axi_splitter_0_AXI_SLAVE_4_RDATA,
        RRESP   => axi_splitter_0_AXI_SLAVE_4_RRESP,
        PADDR   => axi_to_apb_2_APB_SLAVE_PADDR,
        PWDATA  => axi_to_apb_2_APB_SLAVE_PWDATA 
        );
-- axi_to_apb_3
axi_to_apb_3 : entity work.axi_to_apb
    generic map( 
        BYTE_SIZE     => ( 8 ),
        REGISTER_SIZE => ( 32 )
        )
    port map( 
        -- Inputs
        clk     => my_mss_top_0_FIC_0_CLK,
        aresetn => my_mss_top_0_MSS_READY,
        AWVALID => axi_splitter_0_AXI_SLAVE_5_AWVALID,
        WLAST   => axi_splitter_0_AXI_SLAVE_5_WLAST,
        WVALID  => axi_splitter_0_AXI_SLAVE_5_WVALID,
        BREADY  => axi_splitter_0_AXI_SLAVE_5_BREADY,
        ARVALID => axi_splitter_0_AXI_SLAVE_5_ARVALID,
        RREADY  => axi_splitter_0_AXI_SLAVE_5_RREADY,
        PREADY  => axi_to_apb_3_APB_SLAVE_PREADY,
        AWID    => axi_splitter_0_AXI_SLAVE_5_AWID,
        AWADDR  => axi_splitter_0_AXI_SLAVE_5_AWADDR,
        AWLEN   => axi_splitter_0_AXI_SLAVE_5_AWLEN,
        AWSIZE  => axi_splitter_0_AXI_SLAVE_5_AWSIZE,
        AWBURST => axi_splitter_0_AXI_SLAVE_5_AWBURST,
        AWLOCK  => axi_splitter_0_AXI_SLAVE_5_AWLOCK,
        WID     => axi_splitter_0_AXI_SLAVE_5_WID,
        WSTRB   => axi_splitter_0_AXI_SLAVE_5_WSTRB,
        WDATA   => axi_splitter_0_AXI_SLAVE_5_WDATA,
        ARID    => axi_splitter_0_AXI_SLAVE_5_ARID,
        ARADDR  => axi_splitter_0_AXI_SLAVE_5_ARADDR,
        ARLEN   => axi_splitter_0_AXI_SLAVE_5_ARLEN,
        ARSIZE  => axi_splitter_0_AXI_SLAVE_5_ARSIZE,
        ARLOCK  => axi_splitter_0_AXI_SLAVE_5_ARLOCK,
        ARBURST => axi_splitter_0_AXI_SLAVE_5_ARBURST,
        PRDATA  => axi_to_apb_3_APB_SLAVE_PRDATA,
        -- Outputs
        AWREADY => axi_splitter_0_AXI_SLAVE_5_AWREADY,
        WREADY  => axi_splitter_0_AXI_SLAVE_5_WREADY,
        BVALID  => axi_splitter_0_AXI_SLAVE_5_BVALID,
        ARREADY => axi_splitter_0_AXI_SLAVE_5_ARREADY,
        RLAST   => axi_splitter_0_AXI_SLAVE_5_RLAST,
        RVALID  => axi_splitter_0_AXI_SLAVE_5_RVALID,
        PENABLE => axi_to_apb_3_APB_SLAVE_PENABLE,
        PWRITE  => axi_to_apb_3_APB_SLAVE_PWRITE,
        PSEL    => axi_to_apb_3_APB_SLAVE_PSELx,
        BID     => axi_splitter_0_AXI_SLAVE_5_BID,
        BRESP   => axi_splitter_0_AXI_SLAVE_5_BRESP,
        RID     => axi_splitter_0_AXI_SLAVE_5_RID,
        RDATA   => axi_splitter_0_AXI_SLAVE_5_RDATA,
        RRESP   => axi_splitter_0_AXI_SLAVE_5_RRESP,
        PADDR   => axi_to_apb_3_APB_SLAVE_PADDR,
        PWDATA  => axi_to_apb_3_APB_SLAVE_PWDATA 
        );
-- CoreGPIO_0   -   Actel:DirectCore:CoreGPIO:3.1.101
CoreGPIO_0 : entity COREGPIO_LIB.CoreGPIO
    generic map( 
        APB_WIDTH       => ( 32 ),
        FAMILY          => ( 19 ),
        FIXED_CONFIG_0  => ( 1 ),
        FIXED_CONFIG_1  => ( 0 ),
        FIXED_CONFIG_2  => ( 0 ),
        FIXED_CONFIG_3  => ( 0 ),
        FIXED_CONFIG_4  => ( 0 ),
        FIXED_CONFIG_5  => ( 0 ),
        FIXED_CONFIG_6  => ( 0 ),
        FIXED_CONFIG_7  => ( 0 ),
        FIXED_CONFIG_8  => ( 0 ),
        FIXED_CONFIG_9  => ( 0 ),
        FIXED_CONFIG_10 => ( 0 ),
        FIXED_CONFIG_11 => ( 0 ),
        FIXED_CONFIG_12 => ( 0 ),
        FIXED_CONFIG_13 => ( 0 ),
        FIXED_CONFIG_14 => ( 0 ),
        FIXED_CONFIG_15 => ( 0 ),
        FIXED_CONFIG_16 => ( 0 ),
        FIXED_CONFIG_17 => ( 0 ),
        FIXED_CONFIG_18 => ( 0 ),
        FIXED_CONFIG_19 => ( 0 ),
        FIXED_CONFIG_20 => ( 0 ),
        FIXED_CONFIG_21 => ( 0 ),
        FIXED_CONFIG_22 => ( 0 ),
        FIXED_CONFIG_23 => ( 0 ),
        FIXED_CONFIG_24 => ( 0 ),
        FIXED_CONFIG_25 => ( 0 ),
        FIXED_CONFIG_26 => ( 0 ),
        FIXED_CONFIG_27 => ( 0 ),
        FIXED_CONFIG_28 => ( 0 ),
        FIXED_CONFIG_29 => ( 0 ),
        FIXED_CONFIG_30 => ( 0 ),
        FIXED_CONFIG_31 => ( 0 ),
        INT_BUS         => ( 0 ),
        IO_INT_TYPE_0   => ( 7 ),
        IO_INT_TYPE_1   => ( 7 ),
        IO_INT_TYPE_2   => ( 7 ),
        IO_INT_TYPE_3   => ( 7 ),
        IO_INT_TYPE_4   => ( 7 ),
        IO_INT_TYPE_5   => ( 7 ),
        IO_INT_TYPE_6   => ( 7 ),
        IO_INT_TYPE_7   => ( 7 ),
        IO_INT_TYPE_8   => ( 7 ),
        IO_INT_TYPE_9   => ( 7 ),
        IO_INT_TYPE_10  => ( 7 ),
        IO_INT_TYPE_11  => ( 7 ),
        IO_INT_TYPE_12  => ( 7 ),
        IO_INT_TYPE_13  => ( 7 ),
        IO_INT_TYPE_14  => ( 7 ),
        IO_INT_TYPE_15  => ( 7 ),
        IO_INT_TYPE_16  => ( 7 ),
        IO_INT_TYPE_17  => ( 7 ),
        IO_INT_TYPE_18  => ( 7 ),
        IO_INT_TYPE_19  => ( 7 ),
        IO_INT_TYPE_20  => ( 7 ),
        IO_INT_TYPE_21  => ( 7 ),
        IO_INT_TYPE_22  => ( 7 ),
        IO_INT_TYPE_23  => ( 7 ),
        IO_INT_TYPE_24  => ( 7 ),
        IO_INT_TYPE_25  => ( 7 ),
        IO_INT_TYPE_26  => ( 7 ),
        IO_INT_TYPE_27  => ( 7 ),
        IO_INT_TYPE_28  => ( 7 ),
        IO_INT_TYPE_29  => ( 7 ),
        IO_INT_TYPE_30  => ( 7 ),
        IO_INT_TYPE_31  => ( 7 ),
        IO_NUM          => ( 1 ),
        IO_TYPE_0       => ( 1 ),
        IO_TYPE_1       => ( 0 ),
        IO_TYPE_2       => ( 0 ),
        IO_TYPE_3       => ( 0 ),
        IO_TYPE_4       => ( 0 ),
        IO_TYPE_5       => ( 0 ),
        IO_TYPE_6       => ( 0 ),
        IO_TYPE_7       => ( 0 ),
        IO_TYPE_8       => ( 0 ),
        IO_TYPE_9       => ( 0 ),
        IO_TYPE_10      => ( 0 ),
        IO_TYPE_11      => ( 0 ),
        IO_TYPE_12      => ( 0 ),
        IO_TYPE_13      => ( 0 ),
        IO_TYPE_14      => ( 0 ),
        IO_TYPE_15      => ( 0 ),
        IO_TYPE_16      => ( 0 ),
        IO_TYPE_17      => ( 0 ),
        IO_TYPE_18      => ( 0 ),
        IO_TYPE_19      => ( 0 ),
        IO_TYPE_20      => ( 0 ),
        IO_TYPE_21      => ( 0 ),
        IO_TYPE_22      => ( 0 ),
        IO_TYPE_23      => ( 0 ),
        IO_TYPE_24      => ( 0 ),
        IO_TYPE_25      => ( 0 ),
        IO_TYPE_26      => ( 0 ),
        IO_TYPE_27      => ( 0 ),
        IO_TYPE_28      => ( 0 ),
        IO_TYPE_29      => ( 0 ),
        IO_TYPE_30      => ( 0 ),
        IO_TYPE_31      => ( 0 ),
        IO_VAL_0        => ( 1 ),
        IO_VAL_1        => ( 0 ),
        IO_VAL_2        => ( 0 ),
        IO_VAL_3        => ( 0 ),
        IO_VAL_4        => ( 0 ),
        IO_VAL_5        => ( 0 ),
        IO_VAL_6        => ( 0 ),
        IO_VAL_7        => ( 0 ),
        IO_VAL_8        => ( 0 ),
        IO_VAL_9        => ( 0 ),
        IO_VAL_10       => ( 0 ),
        IO_VAL_11       => ( 0 ),
        IO_VAL_12       => ( 0 ),
        IO_VAL_13       => ( 0 ),
        IO_VAL_14       => ( 0 ),
        IO_VAL_15       => ( 0 ),
        IO_VAL_16       => ( 0 ),
        IO_VAL_17       => ( 0 ),
        IO_VAL_18       => ( 0 ),
        IO_VAL_19       => ( 0 ),
        IO_VAL_20       => ( 0 ),
        IO_VAL_21       => ( 0 ),
        IO_VAL_22       => ( 0 ),
        IO_VAL_23       => ( 0 ),
        IO_VAL_24       => ( 0 ),
        IO_VAL_25       => ( 0 ),
        IO_VAL_26       => ( 0 ),
        IO_VAL_27       => ( 0 ),
        IO_VAL_28       => ( 0 ),
        IO_VAL_29       => ( 0 ),
        IO_VAL_30       => ( 0 ),
        IO_VAL_31       => ( 0 ),
        OE_TYPE         => ( 1 )
        )
    port map( 
        -- Inputs
        PRESETN    => my_mss_top_0_MSS_READY,
        PCLK       => my_mss_top_0_FIC_0_CLK,
        PSEL       => axi_to_apb_3_APB_SLAVE_PSELx,
        PENABLE    => axi_to_apb_3_APB_SLAVE_PENABLE,
        PWRITE     => axi_to_apb_3_APB_SLAVE_PWRITE,
        PADDR      => axi_to_apb_3_APB_SLAVE_PADDR_0,
        PWDATA     => axi_to_apb_3_APB_SLAVE_PWDATA,
        GPIO_IN(0) => GND_net,
        -- Outputs
        PSLVERR    => axi_to_apb_3_APB_SLAVE_PSLVERR,
        PREADY     => axi_to_apb_3_APB_SLAVE_PREADY,
        INT_OR     => OPEN,
        PRDATA     => axi_to_apb_3_APB_SLAVE_PRDATA,
        INT        => OPEN,
        GPIO_OUT   => SPISS_net_0,
        GPIO_OE    => OPEN 
        );
-- CORESPI_0   -   Actel:DirectCore:CORESPI:5.0.100
CORESPI_0 : CORESPI
    generic map( 
        APB_DWIDTH        => ( 8 ),
        CFG_CLK           => ( 7 ),
        CFG_FIFO_DEPTH    => ( 4 ),
        CFG_FRAME_SIZE    => ( 8 ),
        CFG_MODE          => ( 0 ),
        CFG_MOT_MODE      => ( 0 ),
        CFG_MOT_SSEL      => ( 0 ),
        CFG_NSC_OPERATION => ( 0 ),
        CFG_TI_JMB_FRAMES => ( 0 ),
        CFG_TI_NSC_CUSTOM => ( 0 ),
        CFG_TI_NSC_FRC    => ( 0 ),
        FAMILY            => ( 19 )
        )
    port map( 
        -- Inputs
        PCLK       => my_mss_top_0_FIC_0_CLK,
        PRESETN    => my_mss_top_0_MSS_READY,
        PSEL       => axi_to_apb_1_APB_SLAVE_PSELx,
        PENABLE    => axi_to_apb_1_APB_SLAVE_PENABLE,
        PWRITE     => axi_to_apb_1_APB_SLAVE_PWRITE,
        SPISSI     => VCC_net,
        SPISDI     => SPISDI,
        SPICLKI    => GND_net,
        PADDR      => axi_to_apb_1_APB_SLAVE_PADDR_0,
        PWDATA     => axi_to_apb_1_APB_SLAVE_PWDATA_0,
        -- Outputs
        PREADY     => axi_to_apb_1_APB_SLAVE_PREADY,
        PSLVERR    => axi_to_apb_1_APB_SLAVE_PSLVERR,
        SPIINT     => OPEN,
        SPIRXAVAIL => OPEN,
        SPITXRFM   => OPEN,
        SPISCLKO   => SPISCLKO_net_0,
        SPIOEN     => OPEN,
        SPISDO     => SPISDO_net_0,
        SPIMODE    => OPEN,
        PRDATA     => axi_to_apb_1_APB_SLAVE_PRDATA,
        SPISS      => SPISS_net_3 
        );
-- CoreUARTapb_0   -   Actel:DirectCore:CoreUARTapb:5.5.101
CoreUARTapb_0 : Top_Fabric_Master_CoreUARTapb_0_CoreUARTapb
    generic map( 
        BAUD_VAL_FRCTN    => ( 6 ),
        BAUD_VAL_FRCTN_EN => ( 1 ),
        BAUD_VALUE        => ( 5 ),
        FAMILY            => ( 19 ),
        FIXEDMODE         => ( 1 ),
        PRG_BIT8          => ( 1 ),
        PRG_PARITY        => ( 0 ),
        RX_FIFO           => ( 0 ),
        RX_LEGACY_MODE    => ( 0 ),
        TX_FIFO           => ( 1 )
        )
    port map( 
        -- Inputs
        PCLK        => my_mss_top_0_FIC_0_CLK,
        PRESETN     => my_mss_top_0_MSS_READY,
        PSEL        => axi_to_apb_0_APB_SLAVE_PSELx,
        PENABLE     => axi_to_apb_0_APB_SLAVE_PENABLE,
        PWRITE      => axi_to_apb_0_APB_SLAVE_PWRITE,
        RX          => RX,
        PADDR       => axi_to_apb_0_APB_SLAVE_PADDR_0,
        PWDATA      => axi_to_apb_0_APB_SLAVE_PWDATA_0,
        -- Outputs
        TXRDY       => OPEN,
        RXRDY       => OPEN,
        PARITY_ERR  => OPEN,
        OVERFLOW    => OPEN,
        TX          => TX_net_0,
        PREADY      => axi_to_apb_0_APB_SLAVE_PREADY,
        PSLVERR     => axi_to_apb_0_APB_SLAVE_PSLVERR,
        FRAMING_ERR => OPEN,
        PRDATA      => axi_to_apb_0_APB_SLAVE_PRDATA 
        );
-- fabric_master_0
fabric_master_0 : entity work.fabric_master
    generic map( 
        IRAM_SIZE => ( 8192 ),
        WORD_SIZE => ( 32 )
        )
    port map( 
        -- Inputs
        AWVALID       => axi_splitter_0_AXI_FLASH_AWVALID,
        WLAST         => axi_splitter_0_AXI_FLASH_WLAST,
        WVALID        => axi_splitter_0_AXI_FLASH_WVALID,
        BREADY        => axi_splitter_0_AXI_FLASH_BREADY,
        ARVALID       => axi_splitter_0_AXI_FLASH_ARVALID,
        RREADY        => axi_splitter_0_AXI_FLASH_RREADY,
        HCLK          => my_mss_top_0_FIC_0_CLK,
        HRESETn       => my_mss_top_0_MSS_READY,
        HREADY        => fabric_master_0_BIF_1_HREADY,
        START         => VCC_net,
        AWID          => axi_splitter_0_AXI_FLASH_AWID,
        AWADDR        => axi_splitter_0_AXI_FLASH_AWADDR,
        AWLEN         => axi_splitter_0_AXI_FLASH_AWLEN,
        AWSIZE        => axi_splitter_0_AXI_FLASH_AWSIZE,
        AWBURST       => axi_splitter_0_AXI_FLASH_AWBURST,
        AWLOCK        => axi_splitter_0_AXI_FLASH_AWLOCK,
        WID           => axi_splitter_0_AXI_FLASH_WID,
        WSTRB         => axi_splitter_0_AXI_FLASH_WSTRB,
        WDATA         => axi_splitter_0_AXI_FLASH_WDATA,
        ARID          => axi_splitter_0_AXI_FLASH_ARID,
        ARADDR        => axi_splitter_0_AXI_FLASH_ARADDR,
        ARLEN         => axi_splitter_0_AXI_FLASH_ARLEN,
        ARSIZE        => axi_splitter_0_AXI_FLASH_ARSIZE,
        ARLOCK        => axi_splitter_0_AXI_FLASH_ARLOCK,
        ARBURST       => axi_splitter_0_AXI_FLASH_ARBURST,
        HRDATA        => fabric_master_0_BIF_1_HRDATA,
        HRESP         => fabric_master_0_BIF_1_HRESP,
        -- Outputs
        AWREADY       => axi_splitter_0_AXI_FLASH_AWREADY,
        WREADY        => axi_splitter_0_AXI_FLASH_WREADY,
        BVALID        => axi_splitter_0_AXI_FLASH_BVALID,
        ARREADY       => axi_splitter_0_AXI_FLASH_ARREADY,
        RLAST         => axi_splitter_0_AXI_FLASH_RLAST,
        RVALID        => axi_splitter_0_AXI_FLASH_RVALID,
        HWRITE        => fabric_master_0_BIF_1_HWRITE,
        ahb_busy      => OPEN,
        ram_init_done => OPEN,
        BID           => axi_splitter_0_AXI_FLASH_BID,
        BRESP         => axi_splitter_0_AXI_FLASH_BRESP,
        RID           => axi_splitter_0_AXI_FLASH_RID,
        RDATA         => axi_splitter_0_AXI_FLASH_RDATA,
        RRESP         => axi_splitter_0_AXI_FLASH_RRESP,
        HADDR         => fabric_master_0_BIF_1_HADDR,
        HTRANS        => fabric_master_0_BIF_1_HTRANS,
        HSIZE         => fabric_master_0_BIF_1_HSIZE,
        HBURST        => fabric_master_0_BIF_1_HBURST,
        HPROT         => fabric_master_0_BIF_1_HPROT,
        HWDATA        => fabric_master_0_BIF_1_HWDATA,
        RESP_err      => OPEN 
        );
-- i2s_apb_0
i2s_apb_0 : entity work.i2s_apb
    generic map( 
        DATA_WIDTH    => ( 32 ),
        REGISTER_SIZE => ( 32 )
        )
    port map( 
        -- Inputs
        PCLK      => my_mss_top_0_FIC_0_CLK,
        PRESETN   => my_mss_top_0_MSS_READY,
        PENABLE   => axi_to_apb_2_APB_SLAVE_PENABLE,
        PWRITE    => axi_to_apb_2_APB_SLAVE_PWRITE,
        PSEL      => axi_to_apb_2_APB_SLAVE_PSELx,
        i2s_sd_i  => i2s_sd_i,
        i2s_sck_i => i2s_sck_i,
        i2s_ws_i  => i2s_ws_i,
        PADDR     => axi_to_apb_2_APB_SLAVE_PADDR,
        PWDATA    => axi_to_apb_2_APB_SLAVE_PWDATA,
        -- Outputs
        PREADY    => axi_to_apb_2_APB_SLAVE_PREADY,
        rx_int_i  => OPEN,
        PRDATA    => axi_to_apb_2_APB_SLAVE_PRDATA 
        );
-- my_mss_top_0
my_mss_top_0 : my_mss_top
    port map( 
        -- Inputs
        DEVRST_N                   => DEVRST_N,
        FAB_RESET_N                => VCC_net,
        MMUART_0_RXD_F2M           => GND_net,
        M3_RESET_N                 => GND_net,
        AMBA_MASTER_0_HWRITE_M0    => fabric_master_0_BIF_1_HWRITE,
        AMBA_MASTER_0_HMASTLOCK_M0 => GND_net, -- tied to '0' from definition
        PREADYS1                   => my_mss_top_0_AMBA_SLAVE_0_0_PREADY,
        PSLVERRS1                  => GND_net, -- tied to '0' from definition
        AMBA_MASTER_0_HADDR_M0     => fabric_master_0_BIF_1_HADDR,
        AMBA_MASTER_0_HTRANS_M0    => fabric_master_0_BIF_1_HTRANS,
        AMBA_MASTER_0_HSIZE_M0     => fabric_master_0_BIF_1_HSIZE,
        AMBA_MASTER_0_HBURST_M0    => fabric_master_0_BIF_1_HBURST,
        AMBA_MASTER_0_HPROT_M0     => fabric_master_0_BIF_1_HPROT,
        AMBA_MASTER_0_HWDATA_M0    => fabric_master_0_BIF_1_HWDATA,
        PRDATAS1                   => my_mss_top_0_AMBA_SLAVE_0_0_PRDATA,
        -- Outputs
        MMUART_0_TXD_M2F           => OPEN,
        INIT_DONE                  => OPEN,
        MSS_READY                  => my_mss_top_0_MSS_READY,
        FIC_0_CLK                  => my_mss_top_0_FIC_0_CLK,
        FIC_0_LOCK                 => OPEN,
        POWER_ON_RESET_N           => RESET_OUT_N_net_0,
        GL1                        => my_mss_top_0_GL1,
        AMBA_MASTER_0_HREADY_M0    => fabric_master_0_BIF_1_HREADY,
        PSELS1                     => my_mss_top_0_AMBA_SLAVE_0_0_PSELx,
        PENABLES                   => my_mss_top_0_AMBA_SLAVE_0_0_PENABLE,
        PWRITES                    => my_mss_top_0_AMBA_SLAVE_0_0_PWRITE,
        AMBA_MASTER_0_HRDATA_M0    => fabric_master_0_BIF_1_HRDATA,
        AMBA_MASTER_0_HRESP_M0     => fabric_master_0_BIF_1_HRESP,
        PADDRS                     => my_mss_top_0_AMBA_SLAVE_0_0_PADDR,
        PWDATAS                    => my_mss_top_0_AMBA_SLAVE_0_0_PWDATA 
        );
-- riscV_axi_0
riscV_axi_0 : entity work.riscV_axi
    generic map( 
        BRANCH_PREDICTORS  => ( 0 ),
        BYTE_SIZE          => ( 8 ),
        COUNTER_LENGTH     => ( 64 ),
        DIVIDE_ENABLE      => ( 0 ),
        FORWARD_ALU_ONLY   => ( 1 ),
        IRAM_SIZE          => ( 8192 ),
        MULTIPLY_ENABLE    => ( 0 ),
        PIPELINE_STAGES    => ( 5 ),
        REGISTER_SIZE      => ( 32 ),
        RESET_VECTOR       => ( 512 ),
        SHIFTER_MAX_CYCLES => ( 1 )
        )
    port map( 
        -- Inputs
        clk                 => my_mss_top_0_FIC_0_CLK,
        reset               => reset_IN_POST_INV0_0,
        data_AWREADY        => riscV_axi_0_BIF_1_AWREADY,
        data_WREADY         => riscV_axi_0_BIF_1_WREADY,
        data_BVALID         => riscV_axi_0_BIF_1_BVALID,
        data_ARREADY        => riscV_axi_0_BIF_1_ARREADY,
        data_RLAST          => riscV_axi_0_BIF_1_RLAST,
        data_RVALID         => riscV_axi_0_BIF_1_RVALID,
        nvm_PENABLE         => my_mss_top_0_AMBA_SLAVE_0_0_PENABLE,
        nvm_PWRITE          => my_mss_top_0_AMBA_SLAVE_0_0_PWRITE,
        nvm_PSEL            => my_mss_top_0_AMBA_SLAVE_0_0_PSELx,
        coe_from_host       => coe_from_host_const_net_0,
        data_BID            => riscV_axi_0_BIF_1_BID,
        data_BRESP          => riscV_axi_0_BIF_1_BRESP,
        data_RID            => riscV_axi_0_BIF_1_RID,
        data_RDATA          => riscV_axi_0_BIF_1_RDATA,
        data_RRESP          => riscV_axi_0_BIF_1_RRESP,
        nvm_PADDR           => my_mss_top_0_AMBA_SLAVE_0_0_PADDR,
        nvm_PWDATA          => my_mss_top_0_AMBA_SLAVE_0_0_PWDATA,
        -- Outputs
        data_AWVALID        => riscV_axi_0_BIF_1_AWVALID,
        data_WLAST          => riscV_axi_0_BIF_1_WLAST,
        data_WVALID         => riscV_axi_0_BIF_1_WVALID,
        data_BREADY         => riscV_axi_0_BIF_1_BREADY,
        data_ARVALID        => riscV_axi_0_BIF_1_ARVALID,
        data_RREADY         => riscV_axi_0_BIF_1_RREADY,
        nvm_PREADY          => my_mss_top_0_AMBA_SLAVE_0_0_PREADY,
        coe_to_host         => coe_to_host_net_0,
        coe_program_counter => OPEN,
        data_AWID           => riscV_axi_0_BIF_1_AWID,
        data_AWADDR         => riscV_axi_0_BIF_1_AWADDR,
        data_AWLEN          => riscV_axi_0_BIF_1_AWLEN,
        data_AWSIZE         => riscV_axi_0_BIF_1_AWSIZE,
        data_AWBURST        => riscV_axi_0_BIF_1_AWBURST,
        data_AWLOCK         => riscV_axi_0_BIF_1_AWLOCK,
        data_AWCACHE        => riscV_axi_0_BIF_1_AWCACHE,
        data_AWPROT         => riscV_axi_0_BIF_1_AWPROT,
        data_WID            => riscV_axi_0_BIF_1_WID,
        data_WDATA          => riscV_axi_0_BIF_1_WDATA,
        data_WSTRB          => riscV_axi_0_BIF_1_WSTRB,
        data_ARID           => riscV_axi_0_BIF_1_ARID,
        data_ARADDR         => riscV_axi_0_BIF_1_ARADDR,
        data_ARLEN          => riscV_axi_0_BIF_1_ARLEN,
        data_ARSIZE         => riscV_axi_0_BIF_1_ARSIZE,
        data_ARBURST        => riscV_axi_0_BIF_1_ARBURST,
        data_ARLOCK         => riscV_axi_0_BIF_1_ARLOCK,
        data_ARCACHE        => riscV_axi_0_BIF_1_ARCACHE,
        data_ARPROT         => riscV_axi_0_BIF_1_ARPROT,
        nvm_PRDATA          => my_mss_top_0_AMBA_SLAVE_0_0_PRDATA 
        );
-- vectorblox_mxp_0
vectorblox_mxp_0 : entity work.vectorblox_mxp
    generic map( 
        BURSTLENGTH_BYTES         => ( 32 ),
        C_INSTR_PORT_TYPE         => ( 1 ),
        C_M_AXI_ADDR_WIDTH        => ( 32 ),
        C_M_AXI_DATA_WIDTH        => ( 32 ),
        C_M_AXI_LEN_WIDTH         => ( 8 ),
        C_S_AXI_ADDR_WIDTH        => ( 32 ),
        C_S_AXI_DATA_WIDTH        => ( 32 ),
        C_S_AXI_INSTR_ADDR_WIDTH  => ( 32 ),
        C_S_AXI_INSTR_DATA_WIDTH  => ( 32 ),
        C_S_AXI_INSTR_ID_WIDTH    => ( 4 ),
        MASK_PARTITIONS           => ( 1 ),
        MAX_MASKED_WAVES          => ( 128 ),
        MIN_MULTIPLIER_HW         => ( 0 ),
        MULFXP_BYTE_FRACTION_BITS => ( 4 ),
        MULFXP_HALF_FRACTION_BITS => ( 15 ),
        MULFXP_WORD_FRACTION_BITS => ( 25 ),
        SCRATCHPAD_KB             => ( 8 ),
        VECTOR_LANES              => ( 1 )
        )
    port map( 
        -- Inputs
        core_clk            => my_mss_top_0_FIC_0_CLK,
        core_clk_2x         => my_mss_top_0_GL1,
        aresetn             => my_mss_top_0_MSS_READY,
        s_axi_instr_awvalid => axi_splitter_0_AXI_SLAVE_1_AWVALID,
        s_axi_instr_wvalid  => axi_splitter_0_AXI_SLAVE_1_WVALID,
        s_axi_instr_wlast   => axi_splitter_0_AXI_SLAVE_1_WLAST,
        s_axi_instr_bready  => axi_splitter_0_AXI_SLAVE_1_BREADY,
        s_axi_instr_arvalid => axi_splitter_0_AXI_SLAVE_1_ARVALID,
        s_axi_instr_rready  => axi_splitter_0_AXI_SLAVE_1_RREADY,
        m_axi_arready       => GND_net, -- tied to '0' from definition
        m_axi_rvalid        => GND_net, -- tied to '0' from definition
        m_axi_rlast         => GND_net, -- tied to '0' from definition
        m_axi_awready       => GND_net, -- tied to '0' from definition
        m_axi_wready        => GND_net, -- tied to '0' from definition
        m_axi_bvalid        => GND_net, -- tied to '0' from definition
        s_axi_awvalid       => axi_splitter_0_AXI_SLAVE_0_AWVALID,
        s_axi_wvalid        => axi_splitter_0_AXI_SLAVE_0_WVALID,
        s_axi_bready        => axi_splitter_0_AXI_SLAVE_0_BREADY,
        s_axi_arvalid       => axi_splitter_0_AXI_SLAVE_0_ARVALID,
        s_axi_rready        => axi_splitter_0_AXI_SLAVE_0_RREADY,
        s_axi_instr_awaddr  => axi_splitter_0_AXI_SLAVE_1_AWADDR,
        s_axi_instr_awid    => axi_splitter_0_AXI_SLAVE_1_AWID,
        s_axi_instr_awlen   => axi_splitter_0_AXI_SLAVE_1_AWLEN_0,
        s_axi_instr_awsize  => axi_splitter_0_AXI_SLAVE_1_AWSIZE,
        s_axi_instr_awburst => axi_splitter_0_AXI_SLAVE_1_AWBURST,
        s_axi_instr_wdata   => axi_splitter_0_AXI_SLAVE_1_WDATA,
        s_axi_instr_wstrb   => axi_splitter_0_AXI_SLAVE_1_WSTRB,
        s_axi_instr_araddr  => axi_splitter_0_AXI_SLAVE_1_ARADDR,
        s_axi_instr_arid    => axi_splitter_0_AXI_SLAVE_1_ARID,
        s_axi_instr_arlen   => axi_splitter_0_AXI_SLAVE_1_ARLEN_0,
        s_axi_instr_arsize  => axi_splitter_0_AXI_SLAVE_1_ARSIZE,
        s_axi_instr_arburst => axi_splitter_0_AXI_SLAVE_1_ARBURST,
        m_axi_rdata         => m_axi_rdata_const_net_0, -- tied to X"0" from definition
        m_axi_rresp         => m_axi_rresp_const_net_0, -- tied to X"0" from definition
        m_axi_bresp         => m_axi_bresp_const_net_0, -- tied to X"0" from definition
        s_axi_awaddr        => axi_splitter_0_AXI_SLAVE_0_AWADDR,
        s_axi_wdata         => axi_splitter_0_AXI_SLAVE_0_WDATA,
        s_axi_wstrb         => axi_splitter_0_AXI_SLAVE_0_WSTRB,
        s_axi_araddr        => axi_splitter_0_AXI_SLAVE_0_ARADDR,
        -- Outputs
        s_axi_instr_awready => axi_splitter_0_AXI_SLAVE_1_AWREADY,
        s_axi_instr_wready  => axi_splitter_0_AXI_SLAVE_1_WREADY,
        s_axi_instr_bvalid  => axi_splitter_0_AXI_SLAVE_1_BVALID,
        s_axi_instr_arready => axi_splitter_0_AXI_SLAVE_1_ARREADY,
        s_axi_instr_rvalid  => axi_splitter_0_AXI_SLAVE_1_RVALID,
        s_axi_instr_rlast   => axi_splitter_0_AXI_SLAVE_1_RLAST,
        m_axi_arvalid       => OPEN,
        m_axi_rready        => OPEN,
        m_axi_awvalid       => OPEN,
        m_axi_wvalid        => OPEN,
        m_axi_wlast         => OPEN,
        m_axi_bready        => OPEN,
        s_axi_awready       => axi_splitter_0_AXI_SLAVE_0_AWREADY,
        s_axi_wready        => axi_splitter_0_AXI_SLAVE_0_WREADY,
        s_axi_bvalid        => axi_splitter_0_AXI_SLAVE_0_BVALID,
        s_axi_arready       => axi_splitter_0_AXI_SLAVE_0_ARREADY,
        s_axi_rvalid        => axi_splitter_0_AXI_SLAVE_0_RVALID,
        s_axi_instr_bresp   => axi_splitter_0_AXI_SLAVE_1_BRESP,
        s_axi_instr_bid     => axi_splitter_0_AXI_SLAVE_1_BID,
        s_axi_instr_rdata   => axi_splitter_0_AXI_SLAVE_1_RDATA,
        s_axi_instr_rresp   => axi_splitter_0_AXI_SLAVE_1_RRESP,
        s_axi_instr_rid     => axi_splitter_0_AXI_SLAVE_1_RID,
        m_axi_araddr        => OPEN,
        m_axi_arlen         => OPEN,
        m_axi_arsize        => OPEN,
        m_axi_arburst       => OPEN,
        m_axi_arprot        => OPEN,
        m_axi_arcache       => OPEN,
        m_axi_awaddr        => OPEN,
        m_axi_awlen         => OPEN,
        m_axi_awsize        => OPEN,
        m_axi_awburst       => OPEN,
        m_axi_awprot        => OPEN,
        m_axi_awcache       => OPEN,
        m_axi_wdata         => OPEN,
        m_axi_wstrb         => OPEN,
        s_axi_bresp         => axi_splitter_0_AXI_SLAVE_0_BRESP,
        s_axi_rdata         => axi_splitter_0_AXI_SLAVE_0_RDATA,
        s_axi_rresp         => axi_splitter_0_AXI_SLAVE_0_RRESP 
        );

end RTL;
