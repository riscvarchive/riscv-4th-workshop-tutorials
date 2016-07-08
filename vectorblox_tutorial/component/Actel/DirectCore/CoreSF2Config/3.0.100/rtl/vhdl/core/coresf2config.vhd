-- ***********************************************************************/
-- Microsemi Corporation Proprietary and Confidential
-- Copyright 2012 Microsemi Corporation.  All rights reserved.
--
-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.
--
-- Description:	CoreSF2Config
--				Soft IP core for facilitating configuration of peripheral
--              blocks (MDDR, FDDR, SERDESIF) on a SmartFusion2 device.
--
-- SVN Revision Information:
-- SVN $Revision: 20291 $
-- SVN $Date: 2013-04-26 11:31:52 -0700 (Fri, 26 Apr 2013) $
--
-- Notes:
--
-- ***********************************************************************/

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CoreSF2Config is
    generic(
    FAMILY                  : integer := 19
    );
    port(
    -- APB_2 interface from MSS
    FIC_2_APB_M_PRESET_N    : in  std_logic;
    FIC_2_APB_M_PCLK        : in  std_logic;
    FIC_2_APB_M_PSEL        : in  std_logic;
    FIC_2_APB_M_PENABLE     : in  std_logic;
    FIC_2_APB_M_PWRITE      : in  std_logic;
    FIC_2_APB_M_PADDR       : in  std_logic_vector(16 downto 2);
    FIC_2_APB_M_PWDATA      : in  std_logic_vector(31 downto 0);
    FIC_2_APB_M_PRDATA      : out std_logic_vector(31 downto 0);
    FIC_2_APB_M_PREADY      : out std_logic;
    FIC_2_APB_M_PSLVERR     : out std_logic;
    -- Clock and reset to slaves
    APB_S_PCLK              : out std_logic;
    APB_S_PRESET_N          : out std_logic;
    -- MDDR
    MDDR_PSEL               : out std_logic;
    MDDR_PENABLE            : out std_logic;
    MDDR_PWRITE             : out std_logic;
    MDDR_PADDR              : out std_logic_vector(15 downto 2);
    MDDR_PWDATA             : out std_logic_vector(31 downto 0);
    MDDR_PRDATA             : in  std_logic_vector(31 downto 0);
    MDDR_PREADY             : in  std_logic;
    MDDR_PSLVERR            : in  std_logic;
    -- FDDR
    FDDR_PSEL               : out std_logic;
    FDDR_PENABLE            : out std_logic;
    FDDR_PWRITE             : out std_logic;
    FDDR_PADDR              : out std_logic_vector(15 downto 2);
    FDDR_PWDATA             : out std_logic_vector(31 downto 0);
    FDDR_PRDATA             : in  std_logic_vector(31 downto 0);
    FDDR_PREADY             : in  std_logic;
    FDDR_PSLVERR            : in  std_logic;
    -- SERDESIF_0
    SDIF0_PSEL              : out std_logic;
    SDIF0_PENABLE           : out std_logic;
    SDIF0_PWRITE            : out std_logic;
    SDIF0_PADDR             : out std_logic_vector(15 downto 2);
    SDIF0_PWDATA            : out std_logic_vector(31 downto 0);
    SDIF0_PRDATA            : in  std_logic_vector(31 downto 0);
    SDIF0_PREADY            : in  std_logic;
    SDIF0_PSLVERR           : in  std_logic;
    -- SERDESIF_1
    SDIF1_PSEL              : out std_logic;
    SDIF1_PENABLE           : out std_logic;
    SDIF1_PWRITE            : out std_logic;
    SDIF1_PADDR             : out std_logic_vector(15 downto 2);
    SDIF1_PWDATA            : out std_logic_vector(31 downto 0);
    SDIF1_PRDATA            : in  std_logic_vector(31 downto 0);
    SDIF1_PREADY            : in  std_logic;
    SDIF1_PSLVERR           : in  std_logic;
    -- SERDESIF_2
    SDIF2_PSEL              : out std_logic;
    SDIF2_PENABLE           : out std_logic;
    SDIF2_PWRITE            : out std_logic;
    SDIF2_PADDR             : out std_logic_vector(15 downto 2);
    SDIF2_PWDATA            : out std_logic_vector(31 downto 0);
    SDIF2_PRDATA            : in  std_logic_vector(31 downto 0);
    SDIF2_PREADY            : in  std_logic;
    SDIF2_PSLVERR           : in  std_logic;
    -- SERDESIF_3
    SDIF3_PSEL              : out std_logic;
    SDIF3_PENABLE           : out std_logic;
    SDIF3_PWRITE            : out std_logic;
    SDIF3_PADDR             : out std_logic_vector(15 downto 2);
    SDIF3_PWDATA            : out std_logic_vector(31 downto 0);
    SDIF3_PRDATA            : in  std_logic_vector(31 downto 0);
    SDIF3_PREADY            : in  std_logic;
    SDIF3_PSLVERR           : in  std_logic;

    CONFIG_DONE             : out std_logic;
    INIT_DONE               : in  std_logic;
    CLR_INIT_DONE           : out std_logic
    );
end CoreSF2Config;

architecture rtl of CoreSF2Config is

    -- Parameters for state machine states
    constant S0 : std_logic_vector(1 downto 0) := "00";
    constant S1 : std_logic_vector(1 downto 0) := "01";
    constant S2 : std_logic_vector(1 downto 0) := "10";

    signal state                    : std_logic_vector(1 downto 0);
    signal next_state               : std_logic_vector(1 downto 0);
    signal next_FIC_2_APB_M_PREADY  : std_logic;
    signal psel                     : std_logic;
    signal d_psel                   : std_logic;
    signal d_penable                : std_logic;
    signal pready                   : std_logic;
    signal pslverr                  : std_logic;
    signal prdata                   : std_logic_vector(31 downto 0);
    signal int_prdata               : std_logic_vector(31 downto 0);
    signal int_psel                 : std_logic;
    signal control_reg_1            : std_logic;
    signal control_reg_2            : std_logic;
    signal paddr                    : std_logic_vector(16 downto 2);
    signal pwdata                   : std_logic_vector(31 downto 0);
    signal pwrite                   : std_logic;
    signal mddr_sel                 : std_logic;
    signal fddr_sel                 : std_logic;
    signal sdif0_sel                : std_logic;
    signal sdif1_sel                : std_logic;
    signal sdif2_sel                : std_logic;
    signal sdif3_sel                : std_logic;
    signal int_sel                  : std_logic;
    signal INIT_DONE_q1             : std_logic;
    signal INIT_DONE_q2             : std_logic;
    signal INIT_DONE_q3             : std_logic;

    signal FIC_2_APB_M_PRDATA_0     : std_logic_vector(31 downto 0);
    signal FIC_2_APB_M_PREADY_0     : std_logic;
    signal FIC_2_APB_M_PSLVERR_0    : std_logic;
    signal APB_S_PCLK_0             : std_logic;
    signal APB_S_PRESET_N_0         : std_logic;
    signal MDDR_PSEL_0              : std_logic;
    signal MDDR_PENABLE_0           : std_logic;
    signal MDDR_PWRITE_0            : std_logic;
    signal MDDR_PADDR_0             : std_logic_vector(15 downto 2);
    signal MDDR_PWDATA_0            : std_logic_vector(31 downto 0);
    signal FDDR_PSEL_0              : std_logic;
    signal FDDR_PENABLE_0           : std_logic;
    signal FDDR_PWRITE_0            : std_logic;
    signal FDDR_PADDR_0             : std_logic_vector(15 downto 2);
    signal FDDR_PWDATA_0            : std_logic_vector(31 downto 0);
    signal SDIF0_PSEL_0             : std_logic;
    signal SDIF0_PENABLE_0          : std_logic;
    signal SDIF0_PWRITE_0           : std_logic;
    signal SDIF0_PADDR_0            : std_logic_vector(15 downto 2);
    signal SDIF0_PWDATA_0           : std_logic_vector(31 downto 0);
    signal SDIF1_PSEL_0             : std_logic;
    signal SDIF1_PENABLE_0          : std_logic;
    signal SDIF1_PWRITE_0           : std_logic;
    signal SDIF1_PADDR_0            : std_logic_vector(15 downto 2);
    signal SDIF1_PWDATA_0           : std_logic_vector(31 downto 0);
    signal SDIF2_PSEL_0             : std_logic;
    signal SDIF2_PENABLE_0          : std_logic;
    signal SDIF2_PWRITE_0           : std_logic;
    signal SDIF2_PADDR_0            : std_logic_vector(15 downto 2);
    signal SDIF2_PWDATA_0           : std_logic_vector(31 downto 0);
    signal SDIF3_PSEL_0             : std_logic;
    signal SDIF3_PENABLE_0          : std_logic;
    signal SDIF3_PWRITE_0           : std_logic;
    signal SDIF3_PADDR_0            : std_logic_vector(15 downto 2);
    signal SDIF3_PWDATA_0           : std_logic_vector(31 downto 0);

    signal CONFIG_DONE_0            : std_logic;

begin
    FIC_2_APB_M_PRDATA  <= FIC_2_APB_M_PRDATA_0;
    FIC_2_APB_M_PREADY  <= FIC_2_APB_M_PREADY_0;
    FIC_2_APB_M_PSLVERR <= FIC_2_APB_M_PSLVERR_0;
    APB_S_PCLK          <= APB_S_PCLK_0;
    APB_S_PRESET_N      <= APB_S_PRESET_N_0;
    MDDR_PSEL           <= MDDR_PSEL_0;
    MDDR_PENABLE        <= MDDR_PENABLE_0;
    MDDR_PWRITE         <= MDDR_PWRITE_0;
    MDDR_PADDR          <= MDDR_PADDR_0;
    MDDR_PWDATA         <= MDDR_PWDATA_0;
    FDDR_PSEL           <= FDDR_PSEL_0;
    FDDR_PENABLE        <= FDDR_PENABLE_0;
    FDDR_PWRITE         <= FDDR_PWRITE_0;
    FDDR_PADDR          <= FDDR_PADDR_0;
    FDDR_PWDATA         <= FDDR_PWDATA_0;
    SDIF0_PSEL          <= SDIF0_PSEL_0;
    SDIF0_PENABLE       <= SDIF0_PENABLE_0;
    SDIF0_PWRITE        <= SDIF0_PWRITE_0;
    SDIF0_PADDR         <= SDIF0_PADDR_0;
    SDIF0_PWDATA        <= SDIF0_PWDATA_0;
    SDIF1_PSEL          <= SDIF1_PSEL_0;
    SDIF1_PENABLE       <= SDIF1_PENABLE_0;
    SDIF1_PWRITE        <= SDIF1_PWRITE_0;
    SDIF1_PADDR         <= SDIF1_PADDR_0;
    SDIF1_PWDATA        <= SDIF1_PWDATA_0;
    SDIF2_PSEL          <= SDIF2_PSEL_0;
    SDIF2_PENABLE       <= SDIF2_PENABLE_0;
    SDIF2_PWRITE        <= SDIF2_PWRITE_0;
    SDIF2_PADDR         <= SDIF2_PADDR_0;
    SDIF2_PWDATA        <= SDIF2_PWDATA_0;
    SDIF3_PSEL          <= SDIF3_PSEL_0;
    SDIF3_PENABLE       <= SDIF3_PENABLE_0;
    SDIF3_PWRITE        <= SDIF3_PWRITE_0;
    SDIF3_PADDR         <= SDIF3_PADDR_0;
    SDIF3_PWDATA        <= SDIF3_PWDATA_0;
    CONFIG_DONE         <= CONFIG_DONE_0;

    -----------------------------------------------------------------------
    -- Drive APB_S_PCLK signal to slaves.
    -----------------------------------------------------------------------
    process (FIC_2_APB_M_PCLK)
    begin
        APB_S_PCLK_0 <= FIC_2_APB_M_PCLK;
    end process;

    -----------------------------------------------------------------------
    -- Drive APB_S_PRESET_N signal to slaves.
    -----------------------------------------------------------------------
    process (FIC_2_APB_M_PRESET_N)
    begin
        APB_S_PRESET_N_0 <= FIC_2_APB_M_PRESET_N;
    end process;

    -----------------------------------------------------------------------
    -- PADDR, PWRITE and PWDATA from master registered before passing on to
    -- slaves.
    -----------------------------------------------------------------------
    process (FIC_2_APB_M_PCLK, FIC_2_APB_M_PRESET_N)
    begin
        if (FIC_2_APB_M_PRESET_N = '0') then
            paddr  <= "000000000000000";
            pwrite <= '0';
            pwdata <= "00000000000000000000000000000000";
        elsif (FIC_2_APB_M_PCLK'event and FIC_2_APB_M_PCLK = '1') then
            if (state = S0) then
                paddr  <= FIC_2_APB_M_PADDR;
                pwrite <= FIC_2_APB_M_PWRITE;
                pwdata <= FIC_2_APB_M_PWDATA;
            end if;
        end if;
    end process;

    process (paddr, pwrite, pwdata)
    begin
        MDDR_PADDR_0   <= paddr(15 downto 2);
        FDDR_PADDR_0   <= paddr(15 downto 2);
        SDIF0_PADDR_0  <= paddr(15 downto 2);
        SDIF1_PADDR_0  <= paddr(15 downto 2);
        SDIF2_PADDR_0  <= paddr(15 downto 2);
        SDIF3_PADDR_0  <= paddr(15 downto 2);
        MDDR_PWRITE_0  <= pwrite;
        FDDR_PWRITE_0  <= pwrite;
        SDIF0_PWRITE_0 <= pwrite;
        SDIF1_PWRITE_0 <= pwrite;
        SDIF2_PWRITE_0 <= pwrite;
        SDIF3_PWRITE_0 <= pwrite;
        MDDR_PWDATA_0  <= pwdata;
        FDDR_PWDATA_0  <= pwdata;
        SDIF0_PWDATA_0 <= pwdata;
        SDIF1_PWDATA_0 <= pwdata;
        SDIF2_PWDATA_0 <= pwdata;
        SDIF3_PWDATA_0 <= pwdata;
    end process;

    -----------------------------------------------------------------------
    -- Decode master address to produce slave selects
    -----------------------------------------------------------------------

    --                                          111111     111111
    --                                          54321098   54321098
    -- -------------------------------------------------------------
    -- MDDR         0x40020000 - 0x40020FFF     00000000 - 00001111
    -- FDDR         0x40021000 - 0x40021FFF     00010000 - 00011111
    -- Internal     0x40022000 - 0x40023FFF     00100000 - 00111111
    -- (Unused)     0x40024000 - 0x40027FFF     01000000 - 01111111
    -- SERDESIF_0   0x40028000 - 0x4002BFFF     10000000 - 10111111
    -- SERDESIF_1   0x4002C000 - 0x4002FFFF     11000000 - 11111111
    --
    -- SERDES 2 and 3 will be present in future, larger devices.
    -- An extra address bit (FIC_2_APB_M_PADDR[16]) will be brought
    -- into this block in that case so that these additional two
    -- SERDES blocks will appear at the following locations in the
    -- system address map:
    --
    -- SERDESIF_2   0x40030000 - 0x40033FFF    100000000 -100111111
    -- SERDESIF_3   0x40034000 - 0x40037FFF    101000000 -101111111
    --
    -- Note: System registers (not particular to this block) begin
    --       at address 0x40038000 in the system memory map.
    --
    -- Note: Aliases of MDDR, FDDR and internal registers will appear
    --       in the address space labelled Unused above.
    -- -------------------------------------------------------------
    process (paddr)
    begin
        mddr_sel  <= '0';
        fddr_sel  <= '0';
        int_sel   <= '0';
        sdif0_sel <= '0';
        sdif1_sel <= '0';
        sdif2_sel <= '0';
        sdif3_sel <= '0';
        if (paddr(16 downto 15) = "10") then
            if (paddr(14) = '1') then
                sdif3_sel <= '1';
            else
                sdif2_sel <= '1';
            end if;
       else
            if (paddr(15) = '1') then
                if (paddr(14) = '1') then
                    sdif1_sel <= '1';
                else
                    sdif0_sel <= '1';
                end if;
            else
                if (paddr(13) = '1') then
                    int_sel <= '1';
                else
                    if (paddr(12) = '1') then
                        fddr_sel <= '1';
                    else
                        mddr_sel <= '1';
                    end if;
                end if;
            end if;
        end if;
    end process;

    process (psel, mddr_sel, fddr_sel, sdif0_sel, sdif1_sel, sdif2_sel, sdif3_sel, int_sel)
    begin
        if (psel = '1') then
            MDDR_PSEL_0  <= mddr_sel;
            FDDR_PSEL_0  <= fddr_sel;
            SDIF0_PSEL_0 <= sdif0_sel;
            SDIF1_PSEL_0 <= sdif1_sel;
            SDIF2_PSEL_0 <= sdif2_sel;
            SDIF3_PSEL_0 <= sdif3_sel;
            int_psel     <= int_sel;
        else
            MDDR_PSEL_0  <= '0';
            FDDR_PSEL_0  <= '0';
            SDIF0_PSEL_0 <= '0';
            SDIF1_PSEL_0 <= '0';
            SDIF2_PSEL_0 <= '0';
            SDIF3_PSEL_0 <= '0';
            int_psel     <= '0';
        end if;
    end process;

    -----------------------------------------------------------------------
    -- State machine
    -----------------------------------------------------------------------
    process (
        state,
        FIC_2_APB_M_PREADY_0,
        FIC_2_APB_M_PSEL,
        FIC_2_APB_M_PENABLE,
        pready
    )
    begin
        next_state <= state;
        next_FIC_2_APB_M_PREADY <= FIC_2_APB_M_PREADY_0;
        d_psel <= '0';
        d_penable <= '0';
        case state is
            when S0 =>
                if (FIC_2_APB_M_PSEL = '1' and FIC_2_APB_M_PENABLE = '0') then
                    next_state <= S1;
                    next_FIC_2_APB_M_PREADY <= '0';
                end if;
            when S1 =>
                next_state <= S2;
                d_psel <= '1';
            when S2 =>
                d_psel <= '1';
                d_penable <= '1';
                if (pready = '1') then
                    next_FIC_2_APB_M_PREADY <= '1';
                    next_state <= S0;
                end if;
            when others =>
                next_state <= S0;
        end case;
    end process;

    process (FIC_2_APB_M_PCLK, FIC_2_APB_M_PRESET_N)
    begin
        if (FIC_2_APB_M_PRESET_N = '0') then
            state <= S0;
            FIC_2_APB_M_PREADY_0 <= '1';
        elsif (FIC_2_APB_M_PCLK'event and FIC_2_APB_M_PCLK = '1') then
            state <= next_state;
            FIC_2_APB_M_PREADY_0 <= next_FIC_2_APB_M_PREADY;
        end if;
    end process;

    process (FIC_2_APB_M_PCLK, FIC_2_APB_M_PRESET_N)
    begin
        if (FIC_2_APB_M_PRESET_N = '0') then
            psel <= '0';
            MDDR_PENABLE_0  <= '0';
            FDDR_PENABLE_0  <= '0';
            SDIF0_PENABLE_0 <= '0';
            SDIF1_PENABLE_0 <= '0';
            SDIF2_PENABLE_0 <= '0';
            SDIF3_PENABLE_0 <= '0';
        elsif (FIC_2_APB_M_PCLK'event and FIC_2_APB_M_PCLK = '0') then
            psel <= d_psel;
            MDDR_PENABLE_0  <= d_penable and mddr_sel;
            FDDR_PENABLE_0  <= d_penable and fddr_sel;
            SDIF0_PENABLE_0 <= d_penable and sdif0_sel;
            SDIF1_PENABLE_0 <= d_penable and sdif1_sel;
            SDIF2_PENABLE_0 <= d_penable and sdif2_sel;
            SDIF3_PENABLE_0 <= d_penable and sdif3_sel;
        end if;
    end process;
    -----------------------------------------------------------------------

    -----------------------------------------------------------------------
    -- Mux signals from slaves.
    -----------------------------------------------------------------------
    process (
        MDDR_PSEL_0,
        FDDR_PSEL_0,
        SDIF0_PSEL_0,
        SDIF1_PSEL_0,
        SDIF2_PSEL_0,
        SDIF3_PSEL_0,
        int_psel,
        MDDR_PRDATA,
        MDDR_PSLVERR,
        MDDR_PREADY,
        FDDR_PRDATA,
        FDDR_PSLVERR,
        FDDR_PREADY,
        SDIF0_PRDATA,
        SDIF0_PSLVERR,
        SDIF0_PREADY,
        SDIF1_PRDATA,
        SDIF1_PSLVERR,
        SDIF1_PREADY,
        SDIF2_PRDATA,
        SDIF2_PSLVERR,
        SDIF2_PREADY,
        SDIF3_PRDATA,
        SDIF3_PSLVERR,
        SDIF3_PREADY,
        int_prdata
    )
    variable temp_sel : std_logic_vector(6 downto 0);
    begin
        temp_sel := MDDR_PSEL_0 & FDDR_PSEL_0 & SDIF0_PSEL_0 & SDIF1_PSEL_0 & SDIF2_PSEL_0 & SDIF3_PSEL_0 & int_psel;
        if (std_match(temp_sel, "1------")) then
            prdata  <= MDDR_PRDATA;
            pslverr <= MDDR_PSLVERR;
            pready  <= MDDR_PREADY;
        elsif (std_match(temp_sel, "-1-----")) then
            prdata  <= FDDR_PRDATA;
            pslverr <= FDDR_PSLVERR;
            pready  <= FDDR_PREADY;
        elsif (std_match(temp_sel, "--1----")) then
            prdata  <= SDIF0_PRDATA;
            pslverr <= SDIF0_PSLVERR;
            pready  <= SDIF0_PREADY;
        elsif (std_match(temp_sel, "---1---")) then
            prdata  <= SDIF1_PRDATA;
            pslverr <= SDIF1_PSLVERR;
            pready  <= SDIF1_PREADY;
        elsif (std_match(temp_sel, "----1--")) then
            prdata  <= SDIF2_PRDATA;
            pslverr <= SDIF2_PSLVERR;
            pready  <= SDIF2_PREADY;
        elsif (std_match(temp_sel, "-----1-")) then
            prdata  <= SDIF3_PRDATA;
            pslverr <= SDIF3_PSLVERR;
            pready  <= SDIF3_PREADY;
        elsif (std_match(temp_sel, "------1")) then
            prdata  <= int_prdata;
            pslverr <= '0';
            pready  <= '1';
        else
            prdata  <= int_prdata;
            pslverr <= '0';
            pready  <= '1';
        end if;
    end process;

    -----------------------------------------------------------------------
    -- Register read data from slaves.
    -----------------------------------------------------------------------
    process (FIC_2_APB_M_PCLK, FIC_2_APB_M_PRESET_N)
    begin
        if (FIC_2_APB_M_PRESET_N = '0') then
            FIC_2_APB_M_PRDATA_0  <= "00000000000000000000000000000000";
            FIC_2_APB_M_PSLVERR_0 <= '0';
        elsif (FIC_2_APB_M_PCLK'event and FIC_2_APB_M_PCLK = '1') then
            if (state = S2) then
                FIC_2_APB_M_PRDATA_0  <= prdata;
                FIC_2_APB_M_PSLVERR_0 <= pslverr;
            end if;
        end if;
    end process;

    -----------------------------------------------------------------------
    -- Synchronize INIT_DONE input to FIC_2_APB_M_PCLK domain.
    -----------------------------------------------------------------------
    process (FIC_2_APB_M_PCLK, FIC_2_APB_M_PRESET_N)
    begin
        if (FIC_2_APB_M_PRESET_N = '0') then
            INIT_DONE_q1 <= '0';
            INIT_DONE_q2 <= '0';
            INIT_DONE_q3 <= '0';
        elsif (FIC_2_APB_M_PCLK'event and FIC_2_APB_M_PCLK = '1') then
            INIT_DONE_q1 <= INIT_DONE;
            INIT_DONE_q2 <= INIT_DONE_q1;
            INIT_DONE_q3 <= INIT_DONE_q2;
        end if;
    end process;

    -----------------------------------------------------------------------
    -- Internal registers
    -----------------------------------------------------------------------
    -- Control register 1
    --    [0] = CONFIG_DONE
    process (FIC_2_APB_M_PCLK, FIC_2_APB_M_PRESET_N)
    begin
        if (FIC_2_APB_M_PRESET_N = '0') then
            control_reg_1 <= '0';
        elsif (FIC_2_APB_M_PCLK'event and FIC_2_APB_M_PCLK = '1') then
            if (int_psel = '1' and FIC_2_APB_M_PENABLE = '1' and FIC_2_APB_M_PWRITE = '1'
                and FIC_2_APB_M_PADDR(3 downto 2) = "00"
            ) then
                control_reg_1 <= FIC_2_APB_M_PWDATA(0);
            end if;
        end if;
    end process;
    process (control_reg_1)
    begin
        CONFIG_DONE_0 <= control_reg_1;
    end process;

    -- Control register 2
    --    [0] = Write '1' to clear INIT_DONE status bit
    process (FIC_2_APB_M_PCLK, FIC_2_APB_M_PRESET_N)
    begin
        if (FIC_2_APB_M_PRESET_N = '0') then
            control_reg_2 <= '0';
        elsif (FIC_2_APB_M_PCLK'event and FIC_2_APB_M_PCLK = '1') then
            if (int_psel = '1' and FIC_2_APB_M_PENABLE = '1' and FIC_2_APB_M_PWRITE = '1'
                and FIC_2_APB_M_PADDR(3 downto 2) = "10"
                and FIC_2_APB_M_PWDATA(0) = '1'
            ) then
                control_reg_2 <= '1';
            else
                -- Clear CLR_INIT_DONE bit when a falling edge is observed
                -- on INIT_DONE input.
                if (INIT_DONE_q3 = '1' and INIT_DONE_q2 = '0') then
                    control_reg_2 <= '0';
                end if;
            end if;
        end if;
    end process;
    process (control_reg_2)
    begin
        CLR_INIT_DONE <= control_reg_2;
    end process;

    -- Read data from internal registers
    process (FIC_2_APB_M_PADDR, control_reg_1, INIT_DONE_q2, control_reg_2)
    begin
        case FIC_2_APB_M_PADDR(3 downto 2) is
            when "00" =>
                int_prdata <= "0000000000000000000000000000000" & control_reg_1;
            when "01" =>
                int_prdata <= "0000000000000000000000000000000" & INIT_DONE_q2;
            when "10" =>
                int_prdata <= "0000000000000000000000000000000" & control_reg_2;
            when others =>
                int_prdata <= "00000000000000000000000000000000";
        end case;
    end process;

end rtl;
