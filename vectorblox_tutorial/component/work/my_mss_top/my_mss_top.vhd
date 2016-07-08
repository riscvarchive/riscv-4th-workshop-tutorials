----------------------------------------------------------------------
-- Created by SmartDesign Sat Jul  9 11:12:26 2016
-- Version: v11.7 11.7.0.119
----------------------------------------------------------------------

----------------------------------------------------------------------
-- Libraries
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library smartfusion2;
use smartfusion2.all;
----------------------------------------------------------------------
-- my_mss_top entity declaration
----------------------------------------------------------------------
entity my_mss_top is
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
end my_mss_top;
----------------------------------------------------------------------
-- my_mss_top architecture body
----------------------------------------------------------------------
architecture RTL of my_mss_top is
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------
-- my_mss
component my_mss
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
----------------------------------------------------------------------
-- Signal declarations
----------------------------------------------------------------------
signal AMBA_MASTER_0_HRDATA          : std_logic_vector(31 downto 0);
signal AMBA_MASTER_0_HREADY          : std_logic;
signal AMBA_MASTER_0_HRESP           : std_logic_vector(1 downto 0);
signal AMBA_SLAVE_0_10_PADDR         : std_logic_vector(31 downto 0);
signal AMBA_SLAVE_0_10_PENABLE       : std_logic;
signal AMBA_SLAVE_0_10_PSELx         : std_logic;
signal AMBA_SLAVE_0_10_PWDATA        : std_logic_vector(31 downto 0);
signal AMBA_SLAVE_0_10_PWRITE        : std_logic;
signal FIC_0_CLK_0                   : std_logic;
signal FIC_0_LOCK_0                  : std_logic;
signal GL1_net_0                     : std_logic;
signal INIT_DONE_net_0               : std_logic;
signal MMUART_0_TXD_M2F_net_0        : std_logic;
signal MSS_READY_net_0               : std_logic;
signal POWER_ON_RESET_N_net_0        : std_logic;
signal MMUART_0_TXD_M2F_net_1        : std_logic;
signal INIT_DONE_net_1               : std_logic;
signal MSS_READY_net_1               : std_logic;
signal FIC_0_CLK_0_net_0             : std_logic;
signal FIC_0_LOCK_0_net_0            : std_logic;
signal POWER_ON_RESET_N_net_1        : std_logic;
signal GL1_net_1                     : std_logic;
signal AMBA_MASTER_0_HREADY_net_0    : std_logic;
signal AMBA_SLAVE_0_10_PSELx_net_0   : std_logic;
signal AMBA_SLAVE_0_10_PENABLE_net_0 : std_logic;
signal AMBA_SLAVE_0_10_PWRITE_net_0  : std_logic;
signal AMBA_MASTER_0_HRDATA_net_0    : std_logic_vector(31 downto 0);
signal AMBA_MASTER_0_HRESP_net_0     : std_logic_vector(1 downto 0);
signal AMBA_SLAVE_0_10_PADDR_net_0   : std_logic_vector(31 downto 0);
signal AMBA_SLAVE_0_10_PWDATA_net_0  : std_logic_vector(31 downto 0);

begin
----------------------------------------------------------------------
-- Top level output port assignments
----------------------------------------------------------------------
 MMUART_0_TXD_M2F_net_1               <= MMUART_0_TXD_M2F_net_0;
 MMUART_0_TXD_M2F                     <= MMUART_0_TXD_M2F_net_1;
 INIT_DONE_net_1                      <= INIT_DONE_net_0;
 INIT_DONE                            <= INIT_DONE_net_1;
 MSS_READY_net_1                      <= MSS_READY_net_0;
 MSS_READY                            <= MSS_READY_net_1;
 FIC_0_CLK_0_net_0                    <= FIC_0_CLK_0;
 FIC_0_CLK                            <= FIC_0_CLK_0_net_0;
 FIC_0_LOCK_0_net_0                   <= FIC_0_LOCK_0;
 FIC_0_LOCK                           <= FIC_0_LOCK_0_net_0;
 POWER_ON_RESET_N_net_1               <= POWER_ON_RESET_N_net_0;
 POWER_ON_RESET_N                     <= POWER_ON_RESET_N_net_1;
 GL1_net_1                            <= GL1_net_0;
 GL1                                  <= GL1_net_1;
 AMBA_MASTER_0_HREADY_net_0           <= AMBA_MASTER_0_HREADY;
 AMBA_MASTER_0_HREADY_M0              <= AMBA_MASTER_0_HREADY_net_0;
 AMBA_SLAVE_0_10_PSELx_net_0          <= AMBA_SLAVE_0_10_PSELx;
 PSELS1                               <= AMBA_SLAVE_0_10_PSELx_net_0;
 AMBA_SLAVE_0_10_PENABLE_net_0        <= AMBA_SLAVE_0_10_PENABLE;
 PENABLES                             <= AMBA_SLAVE_0_10_PENABLE_net_0;
 AMBA_SLAVE_0_10_PWRITE_net_0         <= AMBA_SLAVE_0_10_PWRITE;
 PWRITES                              <= AMBA_SLAVE_0_10_PWRITE_net_0;
 AMBA_MASTER_0_HRDATA_net_0           <= AMBA_MASTER_0_HRDATA;
 AMBA_MASTER_0_HRDATA_M0(31 downto 0) <= AMBA_MASTER_0_HRDATA_net_0;
 AMBA_MASTER_0_HRESP_net_0            <= AMBA_MASTER_0_HRESP;
 AMBA_MASTER_0_HRESP_M0(1 downto 0)   <= AMBA_MASTER_0_HRESP_net_0;
 AMBA_SLAVE_0_10_PADDR_net_0          <= AMBA_SLAVE_0_10_PADDR;
 PADDRS(31 downto 0)                  <= AMBA_SLAVE_0_10_PADDR_net_0;
 AMBA_SLAVE_0_10_PWDATA_net_0         <= AMBA_SLAVE_0_10_PWDATA;
 PWDATAS(31 downto 0)                 <= AMBA_SLAVE_0_10_PWDATA_net_0;
----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
-- my_mss_0
my_mss_0 : my_mss
    port map( 
        -- Inputs
        FAB_RESET_N                => FAB_RESET_N,
        AMBA_MASTER_0_HWRITE_M0    => AMBA_MASTER_0_HWRITE_M0,
        AMBA_MASTER_0_HMASTLOCK_M0 => AMBA_MASTER_0_HMASTLOCK_M0,
        DEVRST_N                   => DEVRST_N,
        MMUART_0_RXD_F2M           => MMUART_0_RXD_F2M,
        M3_RESET_N                 => M3_RESET_N,
        PREADYS1                   => PREADYS1,
        PSLVERRS1                  => PSLVERRS1,
        AMBA_MASTER_0_HADDR_M0     => AMBA_MASTER_0_HADDR_M0,
        AMBA_MASTER_0_HTRANS_M0    => AMBA_MASTER_0_HTRANS_M0,
        AMBA_MASTER_0_HSIZE_M0     => AMBA_MASTER_0_HSIZE_M0,
        AMBA_MASTER_0_HBURST_M0    => AMBA_MASTER_0_HBURST_M0,
        AMBA_MASTER_0_HPROT_M0     => AMBA_MASTER_0_HPROT_M0,
        AMBA_MASTER_0_HWDATA_M0    => AMBA_MASTER_0_HWDATA_M0,
        PRDATAS1                   => PRDATAS1,
        -- Outputs
        POWER_ON_RESET_N           => POWER_ON_RESET_N_net_0,
        INIT_DONE                  => INIT_DONE_net_0,
        FIC_0_CLK                  => FIC_0_CLK_0,
        FIC_0_LOCK                 => FIC_0_LOCK_0,
        MSS_READY                  => MSS_READY_net_0,
        AMBA_MASTER_0_HREADY_M0    => AMBA_MASTER_0_HREADY,
        MMUART_0_TXD_M2F           => MMUART_0_TXD_M2F_net_0,
        GL1                        => GL1_net_0,
        PSELS1                     => AMBA_SLAVE_0_10_PSELx,
        PENABLES                   => AMBA_SLAVE_0_10_PENABLE,
        PWRITES                    => AMBA_SLAVE_0_10_PWRITE,
        AMBA_MASTER_0_HRDATA_M0    => AMBA_MASTER_0_HRDATA,
        AMBA_MASTER_0_HRESP_M0     => AMBA_MASTER_0_HRESP,
        PADDRS                     => AMBA_SLAVE_0_10_PADDR,
        PWDATAS                    => AMBA_SLAVE_0_10_PWDATA 
        );

end RTL;
