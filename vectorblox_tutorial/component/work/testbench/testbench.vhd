----------------------------------------------------------------------
-- Created by SmartDesign Fri Jul  8 17:02:44 2016
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
-- testbench entity declaration
----------------------------------------------------------------------
entity testbench is
    -- Port list
    port(
        -- Inputs
        RX         : in  std_logic;
        SPISDI     : in  std_logic;
        -- Outputs
        LED1_GREEN : out std_logic;
        LED2_RED   : out std_logic;
        LED5B      : out std_logic;
        LED5G      : out std_logic;
        LED5R      : out std_logic;
        SPISCLKO   : out std_logic;
        SPISDO     : out std_logic;
        SPISS      : out std_logic;
        SPISS_COPY : out std_logic;
        TX         : out std_logic
        );
end testbench;
----------------------------------------------------------------------
-- testbench architecture body
----------------------------------------------------------------------
architecture RTL of testbench is
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------
-- CLK_GEN   -   Actel:Simulation:CLK_GEN:1.0.1
component CLK_GEN
    generic( 
        CLK_PERIOD : integer := 1000000 ;
        DUTY_CYCLE : integer := 50 
        );
    -- Port list
    port(
        -- Outputs
        CLK : out std_logic
        );
end component;
-- RESET_GEN   -   Actel:Simulation:RESET_GEN:1.0.1
component RESET_GEN
    generic( 
        DELAY       : integer := 1000 ;
        LOGIC_LEVEL : integer := 0 
        );
    -- Port list
    port(
        -- Outputs
        RESET : out std_logic
        );
end component;
-- Top_Fabric_Master
component Top_Fabric_Master
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
end component;
----------------------------------------------------------------------
-- Signal declarations
----------------------------------------------------------------------
signal CLK_GEN_0_CLK     : std_logic;
signal CLK_GEN_1_CLK     : std_logic;
signal LED1_GREEN_net_0  : std_logic;
signal LED2_RED_net_0    : std_logic;
signal LED5B_net_0       : std_logic;
signal LED5G_net_0       : std_logic;
signal LED5R_net_0       : std_logic;
signal RESET_GEN_0_RESET : std_logic;
signal SPISCLKO_net_0    : std_logic;
signal SPISDO_net_0      : std_logic;
signal SPISS_net_0       : std_logic;
signal SPISS_COPY_net_0  : std_logic;
signal TX_0              : std_logic;
signal LED2_RED_net_1    : std_logic;
signal LED5B_net_1       : std_logic;
signal LED1_GREEN_net_1  : std_logic;
signal LED5G_net_1       : std_logic;
signal LED5R_net_1       : std_logic;
signal TX_0_net_0        : std_logic;
signal SPISCLKO_net_1    : std_logic;
signal SPISS_net_1       : std_logic;
signal SPISDO_net_1      : std_logic;
signal SPISS_COPY_net_1  : std_logic;
----------------------------------------------------------------------
-- TiedOff Signals
----------------------------------------------------------------------
signal VCC_net           : std_logic;

begin
----------------------------------------------------------------------
-- Constant assignments
----------------------------------------------------------------------
 VCC_net <= '1';
----------------------------------------------------------------------
-- Top level output port assignments
----------------------------------------------------------------------
 LED2_RED_net_1   <= LED2_RED_net_0;
 LED2_RED         <= LED2_RED_net_1;
 LED5B_net_1      <= LED5B_net_0;
 LED5B            <= LED5B_net_1;
 LED1_GREEN_net_1 <= LED1_GREEN_net_0;
 LED1_GREEN       <= LED1_GREEN_net_1;
 LED5G_net_1      <= LED5G_net_0;
 LED5G            <= LED5G_net_1;
 LED5R_net_1      <= LED5R_net_0;
 LED5R            <= LED5R_net_1;
 TX_0_net_0       <= TX_0;
 TX               <= TX_0_net_0;
 SPISCLKO_net_1   <= SPISCLKO_net_0;
 SPISCLKO         <= SPISCLKO_net_1;
 SPISS_net_1      <= SPISS_net_0;
 SPISS            <= SPISS_net_1;
 SPISDO_net_1     <= SPISDO_net_0;
 SPISDO           <= SPISDO_net_1;
 SPISS_COPY_net_1 <= SPISS_COPY_net_0;
 SPISS_COPY       <= SPISS_COPY_net_1;
----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
-- CLK_GEN_0   -   Actel:Simulation:CLK_GEN:1.0.1
CLK_GEN_0 : CLK_GEN
    generic map( 
        CLK_PERIOD => ( 1000000 ),
        DUTY_CYCLE => ( 50 )
        )
    port map( 
        -- Outputs
        CLK => CLK_GEN_0_CLK 
        );
-- CLK_GEN_1   -   Actel:Simulation:CLK_GEN:1.0.1
CLK_GEN_1 : CLK_GEN
    generic map( 
        CLK_PERIOD => ( 16000000 ),
        DUTY_CYCLE => ( 50 )
        )
    port map( 
        -- Outputs
        CLK => CLK_GEN_1_CLK 
        );
-- RESET_GEN_0   -   Actel:Simulation:RESET_GEN:1.0.1
RESET_GEN_0 : RESET_GEN
    generic map( 
        DELAY       => ( 1000 ),
        LOGIC_LEVEL => ( 0 )
        )
    port map( 
        -- Outputs
        RESET => RESET_GEN_0_RESET 
        );
-- Top_Fabric_Master_0
Top_Fabric_Master_0 : Top_Fabric_Master
    port map( 
        -- Inputs
        DEVRST_N     => RESET_GEN_0_RESET,
        RX           => RX,
        SPISDI       => SPISDI,
        i2s_ws_i     => CLK_GEN_1_CLK,
        i2s_sck_i    => CLK_GEN_0_CLK,
        i2s_sd_i     => VCC_net,
        -- Outputs
        LED2_RED     => LED2_RED_net_0,
        LED5B        => LED5B_net_0,
        LED1_GREEN   => LED1_GREEN_net_0,
        LED5G        => LED5G_net_0,
        LED5R        => LED5R_net_0,
        TX           => TX_0,
        SPISCLKO     => SPISCLKO_net_0,
        SPISS        => SPISS_net_0,
        SPISDO       => SPISDO_net_0,
        SPISS_COPY   => SPISS_COPY_net_0,
        RESET_OUT_N  => OPEN,
        i2s_sd_copy  => OPEN,
        i2s_sck_copy => OPEN,
        i2s_ws_copy  => OPEN 
        );

end RTL;
