----------------------------------------------------------------------
-- Created by SmartDesign Tue May 31 11:20:57 2016
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
-- my_testbench entity declaration
----------------------------------------------------------------------
entity my_testbench is
    -- Port list
    port(
        -- Outputs
        LED1_GREEN : out std_logic;
        LED2_RED   : out std_logic;
        LED5B      : out std_logic;
        LED5G      : out std_logic;
        LED5R      : out std_logic
        );
end my_testbench;
----------------------------------------------------------------------
-- my_testbench architecture body
----------------------------------------------------------------------
architecture RTL of my_testbench is
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------
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
        DEVRST_N   : in  std_logic;
        -- Outputs
        LED1_GREEN : out std_logic;
        LED2_RED   : out std_logic;
        LED5B      : out std_logic;
        LED5G      : out std_logic;
        LED5R      : out std_logic
        );
end component;
----------------------------------------------------------------------
-- Signal declarations
----------------------------------------------------------------------
signal LED1_GREEN_net_0  : std_logic;
signal LED2_RED_net_0    : std_logic;
signal LED5B_net_0       : std_logic;
signal LED5G_net_0       : std_logic;
signal LED5R_net_0       : std_logic;
signal RESET_GEN_0_RESET : std_logic;
signal LED2_RED_net_1    : std_logic;
signal LED5B_net_1       : std_logic;
signal LED1_GREEN_net_1  : std_logic;
signal LED5G_net_1       : std_logic;
signal LED5R_net_1       : std_logic;

begin
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
----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
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
        DEVRST_N   => RESET_GEN_0_RESET,
        -- Outputs
        LED2_RED   => LED2_RED_net_0,
        LED5B      => LED5B_net_0,
        LED1_GREEN => LED1_GREEN_net_0,
        LED5G      => LED5G_net_0,
        LED5R      => LED5R_net_0 
        );

end RTL;
