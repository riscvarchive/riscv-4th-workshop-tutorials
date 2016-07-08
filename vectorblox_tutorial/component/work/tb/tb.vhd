----------------------------------------------------------------------
-- Created by SmartDesign Sat Jul  9 09:29:07 2016
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
-- tb entity declaration
----------------------------------------------------------------------
entity tb is
end tb;
----------------------------------------------------------------------
-- tb architecture body
----------------------------------------------------------------------
architecture RTL of tb is
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
        DELAY       : integer := 500 ;
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
signal CLK_GEN_2_CLK     : std_logic;
signal RESET_GEN_0_RESET : std_logic;
----------------------------------------------------------------------
-- TiedOff Signals
----------------------------------------------------------------------
signal GND_net           : std_logic;
signal VCC_net           : std_logic;

begin
----------------------------------------------------------------------
-- Constant assignments
----------------------------------------------------------------------
 GND_net <= '0';
 VCC_net <= '1';
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
-- CLK_GEN_2   -   Actel:Simulation:CLK_GEN:1.0.1
CLK_GEN_2 : CLK_GEN
    generic map( 
        CLK_PERIOD => ( 32000000 ),
        DUTY_CYCLE => ( 50 )
        )
    port map( 
        -- Outputs
        CLK => CLK_GEN_2_CLK 
        );
-- RESET_GEN_0   -   Actel:Simulation:RESET_GEN:1.0.1
RESET_GEN_0 : RESET_GEN
    generic map( 
        DELAY       => ( 500 ),
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
        RX           => GND_net,
        SPISDI       => GND_net,
        i2s_ws_i     => CLK_GEN_2_CLK,
        i2s_sck_i    => CLK_GEN_0_CLK,
        i2s_sd_i     => VCC_net,
        -- Outputs
        LED2_RED     => OPEN,
        LED5B        => OPEN,
        LED1_GREEN   => OPEN,
        LED5G        => OPEN,
        LED5R        => OPEN,
        TX           => OPEN,
        SPISCLKO     => OPEN,
        SPISS        => OPEN,
        SPISDO       => OPEN,
        SPISS_COPY   => OPEN,
        RESET_OUT_N  => OPEN,
        i2s_sd_copy  => OPEN,
        i2s_sck_copy => OPEN,
        i2s_ws_copy  => OPEN 
        );

end RTL;
