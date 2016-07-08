library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.rv_components.all;
use work.top_util_pkg.all;

entity fabric_master is
  generic (
    WORD_SIZE : integer := 32;
    IRAM_SIZE : integer := 8192 -- bytes
  );
  port (

    AWID     : in std_logic_vector(3 downto 0);
    AWADDR   : in std_logic_vector(WORD_SIZE-1 downto 0);
    AWLEN    : in std_logic_vector(3 downto 0);
    AWSIZE   : in std_logic_vector(2 downto 0);
    AWBURST  : in std_logic_vector(1 downto 0);
    AWLOCK   : in std_logic_vector(1 downto 0);
    AWVALID  : in std_logic;
    AWREADY  : out std_logic;
                                               
    WID      : in std_logic_vector(3 downto 0);
    WSTRB    : in std_logic_vector(WORD_SIZE/8 -1 downto 0);
    WLAST    : in std_logic;
    WVALID   : in std_logic;
    WDATA    : in std_logic_vector(WORD_SIZE-1 downto 0);
    WREADY   : out std_logic;
                                                                         
    BID      : out std_logic_vector(3 downto 0);
    BRESP    : out std_logic_vector(1 downto 0);
    BVALID   : out std_logic;
    BREADY   : in std_logic;
                                                                         
    ARID     : in std_logic_vector(3 downto 0);
    ARADDR   : in std_logic_vector(WORD_SIZE-1 downto 0);
    ARLEN    : in std_logic_vector(3 downto 0);
    ARSIZE   : in std_logic_vector(2 downto 0);
    ARLOCK   : in std_logic_vector(1 downto 0);
    ARBURST  : in std_logic_vector(1 downto 0);
    ARVALID  : in std_logic;
    ARREADY  : out std_logic;
                                                                         
    RID      : out std_logic_vector(3 downto 0);
    RDATA    : out std_logic_vector(WORD_SIZE-1 downto 0);
    RRESP    : out std_logic_vector(1 downto 0);
    RLAST    : out std_logic;
    RVALID   : out std_logic;
    RREADY   : in std_logic;

    HCLK : in std_logic;
    HRESETn : in std_logic;

    HRDATA  : in std_logic_vector(31 downto 0);
    HREADY  : in std_logic;
    HRESP   : in std_logic_vector(1 downto 0);

    START   : in std_logic;

    HADDR   : out std_logic_vector(31 downto 0);
    HTRANS  : out std_logic_vector(1 downto 0);
    HWRITE  : out std_logic;
    HSIZE   : out std_logic_vector(2 downto 0);
    HBURST  : out std_logic_vector(2 downto 0);
    HPROT   : out std_logic_vector(3 downto 0);
    HWDATA  : out std_logic_vector(31 downto 0);

    RESP_err : out std_logic_vector(1 downto 0);
    ahb_busy  : out std_logic;
    ram_init_done : out std_logic
  );
end entity;

architecture rtl of fabric_master is
  type state_t is (IDLE,
                   NVM_FAB_AC_0,
                   NVM_FAB_AC_1,
                   NVM_FAB_AC_2,
                   NVM_AC_READ_0,
                   NVM_AC_READ_1,
                   NVM_AC_READ_2,
                   NVM_AC_CHECK,
                   NVM_READY_0,
                   NVM_READY_1,
                   NVM_READY_2,
                   NVM_READY_CHECK,
                   READ_NVM_0,
                   READ_NVM_1,
                   READ_NVM_2,
                   WRITE_RAM_0,
                   WRITE_RAM_1,
                   WRITE_RAM_2,
                   WRITE_RAM_3,
                   WRITE_RAM_4,
                   WRITE_RAM_5,
                   WRITE_RAM_6,
                   WRITE_RAM_7,
                   WRITE_RAM_8,
                   WRITE_RAM_9,
                   WRITE_RAM_10,
                   WRITE_RAM_11,
                   DONE_0,
                   DONE_1,
                   DONE_2,
                   RISC_IDLE,
                   RISC_AC_0,
                   RISC_AC_1,
                   RISC_AC_2,
                   RISC_AC_READ_0,
                   RISC_AC_READ_1,
                   RISC_AC_READ_2,
                   RISC_AC_CHECK,
                   RISC_READY_0,
                   RISC_READY_1,
                   RISC_READY_2,
                   RISC_READY_CHECK,
                   RISC_READ_NVM_0,
                   RISC_READ_NVM_1,
                   RISC_READ_NVM_2,
                   RISC_RRESP,
                   RISC_DONE_0,
                   RISC_DONE_1);
  
  signal state : state_t;
  signal HSIZE_INT  : std_logic_vector(2 downto 0);
  signal init_done  : std_logic;
  signal NVM_ADDR   : std_logic_vector(31 downto 0);
  signal RAM_ADDR   : std_logic_vector(31 downto 0);
  signal DATAOUT    : std_logic_vector(31 downto 0);

  
  constant BURST : std_logic_vector(2 downto 0) := "000";
  constant PROT  : std_logic_vector(3 downto 0) := "0011";
  constant OFFSET : unsigned(31 downto 0) := to_unsigned(IRAM_SIZE, 32) - to_unsigned(4, 32);
  constant START_ADDR : unsigned(31 downto 0) := x"10000000";
  constant FINAL_ADDR : std_logic_vector(31 downto 0) := std_logic_vector(START_ADDR + OFFSET);
  constant NVM_CTRL : std_logic_vector(31 downto 0) := x"600801FC"; 
  constant NVM_STATUS : std_logic_vector(31 downto 0) := x"60080120";
 
begin
  
  HSIZE_INT <= "000" when WORD_SIZE = 8
          else "001" when WORD_SIZE = 16
          else "010" when WORD_SIZE = 32;
  HBURST <= BURST;
  HPROT <= PROT;

  process(HCLK)
  begin
    if rising_edge(HCLK) then
      if HRESETn = '0' then
        HADDR <= x"00000000";
        HTRANS <= "00";
        HWRITE <= '0';
        HSIZE <= "010";
        HWDATA <= x"00000000";
        DATAOUT <= x"00000000";
        state <= IDLE;
        ahb_busy <= '0';
        NVM_ADDR <= x"60000000";
        RAM_ADDR <= x"10000000";
        init_done <= '0';
        ram_init_done <= '0';

        -- AXI signals
        AWREADY <= '0';
        WREADY <= '0';
        BID <= "0000";
        BRESP <= "00"; 
        BVALID <= '0';
        ARREADY <= '0';
        RID <= "0000";
        RDATA <= (others => '0');
        RRESP <= "00";
        RLAST <= '0';
        RVALID <= '0';
      else
        HADDR <= x"00000000";
        HTRANS <= "00";
        HWRITE <= '0';
        HSIZE <= "010";
        HWDATA <= x"00000000";
        state <= state;
        ahb_busy <= '0';
        init_done <= init_done;
        ram_init_done <= '0';

        -- AXI signals
        AWREADY <= '0';
        WREADY <= '0';
        BID <= "0000";
        BRESP <= "00"; 
        BVALID <= '0';
        ARREADY <= '0';
        RID <= "0000";
        RDATA <= (others => '0');
        RRESP <= "00";
        RLAST <= '0';
        RVALID <= '0';

        case (state) is
          when IDLE =>
            if (init_done = '0') and (START = '1') then
              state <= NVM_FAB_AC_0;
              HADDR <= NVM_CTRL;
              ahb_busy <= '1';
            else
              state <= RISC_IDLE;
              ahb_busy <= '0';
            end if; 
          
          when NVM_FAB_AC_0 =>
            HTRANS <= "10";
            HSIZE <= "010";
            HWRITE <= '1';
            HADDR <= NVM_CTRL;
            HWDATA <= x"00000001";
            state <= NVM_FAB_AC_1;
          
          when NVM_FAB_AC_1 =>
            HTRANS <= "00";
            HSIZE <= "010";
            HWRITE <= '1';
            HADDR <= NVM_CTRL;
            HWDATA <= x"00000001";
            if (HREADY = '1') then
              state <= NVM_FAB_AC_2;
            else
              state <= NVM_FAB_AC_1;
            end if;
          
          when NVM_FAB_AC_2 =>
            HTRANS <= "00";
            HSIZE <= "010";
            HWRITE <= '1';
            HADDR <= NVM_CTRL;
            HWDATA <= x"00000001";
            if (HREADY = '1') then
              state <= NVM_AC_READ_0;
              HADDR <= NVM_CTRL;
            else
              state <= NVM_FAB_AC_2;
            end if;
          
          when NVM_AC_READ_0 =>
            HTRANS <= "10";
            HSIZE <= "010";
            HWRITE <= '0';
            HADDR <= NVM_CTRL;
            state <= NVM_AC_READ_1;
          
          when NVM_AC_READ_1 =>
            HTRANS <= "00";
            HSIZE <= "010";
            HWRITE <= '0';
            HADDR <= NVM_CTRL;
            if (HREADY = '1') then
              state <= NVM_AC_READ_2;
            else
              state <= NVM_AC_READ_1;
            end if;
          
          when NVM_AC_READ_2 =>
            HTRANS <= "00";
            HSIZE <= "010";
            HWRITE <= '0';
            HADDR <= NVM_CTRL;
            if (HREADY = '1') then
              DATAOUT <= HRDATA;
              state <= NVM_AC_CHECK;
            else
              state <= NVM_AC_READ_2;
            end if; 

          when NVM_AC_CHECK =>
            if (DATAOUT(2 downto 0) = "110") then -- NVM is accessible by fabric
              state <= NVM_READY_0;
              HADDR <= NVM_STATUS;
            else
              state <= NVM_FAB_AC_0;
              HADDR <= NVM_CTRL;
            end if;

          when NVM_READY_0 =>
            HTRANS <= "10";
            HSIZE <= "010";
            HWRITE <= '0';
            HADDR <= NVM_STATUS;
            state <= NVM_READY_1;    

          when NVM_READY_1 =>
            HTRANS <= "00";
            HSIZE <= "010";
            HWRITE <= '0';
            HADDR <= NVM_STATUS;
            if (HREADY = '1') then
              state <= NVM_READY_2;
            else
              state <= NVM_READY_1;
            end if;

          when NVM_READY_2 =>
            HTRANS <= "00";
            HSIZE <= "010";
            HWRITE <= '0';
            HADDR <= NVM_STATUS;
            if (HREADY = '1') then
              DATAOUT <= HRDATA;
              state <= NVM_READY_CHECK;
            else
              state <= NVM_READY_2;
            end if;

          when NVM_READY_CHECK =>
            if (DATAOUT(0) = '1') then -- NVM is ready for read
              state <= READ_NVM_0;
              HADDR <= NVM_ADDR;
            else
              state <= NVM_READY_0;
              HADDR <= NVM_STATUS;
            end if;

          when READ_NVM_0 =>
            HTRANS <= "10";
            HSIZE <= "010";
            HWRITE <= '0';
            HADDR <= NVM_ADDR;
            state <= READ_NVM_1;

          when READ_NVM_1 =>
            HTRANS <= "00";
            HSIZE <= "010";
            HWRITE <= '0';
            HADDR <= NVM_ADDR;
            if (HREADY = '1') then
              state <= READ_NVM_2;
            else
              state <= READ_NVM_1;
            end if;

          when READ_NVM_2 =>
            HTRANS <= "00";
            HSIZE <= "010";
            HWRITE <= '0';
            HADDR <= NVM_ADDR;
            if (HREADY = '1') then
              DATAOUT <= HRDATA;
              state <= WRITE_RAM_0;
            else
              state <= READ_NVM_2;
            end if;

          when WRITE_RAM_0 => -- put all 32 bits on the ram bus
            HWDATA <= DATAOUT;
            HSIZE <= HSIZE_INT;
            HADDR <= RAM_ADDR;
            HWRITE <= '1';
            state <= WRITE_RAM_1;

          when WRITE_RAM_1 =>
            HWDATA <= DATAOUT;
            HSIZE <= HSIZE_INT;
            HADDR <= RAM_ADDR;
            HWRITE <= '1';
            HTRANS <= "10";
            if (HREADY = '0') then
              state <= WRITE_RAM_1;
            else
              state <= WRITE_RAM_2;
            end if;

          when WRITE_RAM_2 =>
            HWDATA <= DATAOUT;
            HSIZE <= HSIZE_INT;
            HADDR <= RAM_ADDR;
            HWRITE <= '1';
            HTRANS <= "00";
            if (HREADY = '0') then
              state <= WRITE_RAM_2;
            else
              if (RAM_ADDR = FINAL_ADDR) then
                init_done <= '0';
                ram_init_done <= '0';
                ahb_busy <= '1';
                HADDR <= NVM_CTRL;
                state <= DONE_0;
              else
                ahb_busy <= '1';
                init_done <= '0';
                NVM_ADDR <= std_logic_vector(unsigned(NVM_ADDR) + x"00000004");
                RAM_ADDR <= std_logic_vector(unsigned(RAM_ADDR) + x"00000004");
                state <= NVM_READY_0;
                HADDR <= NVM_STATUS;
              end if;
            end if;

          when DONE_0 =>
            HTRANS <= "10";
            HSIZE <= "010";
            HWRITE <= '1';
            HADDR <= NVM_CTRL;
            HWDATA <= x"00000000";
            state <= DONE_1;

          when DONE_1 =>
            HTRANS <= "00";
            HSIZE <= "010";
            HWRITE <= '1';
            HADDR <= NVM_CTRL;
            HWDATA <= x"00000000";
            state <= DONE_1;
            if (HREADY = '1') then
              ahb_busy <= '0';
              init_done <= '1';
              ram_init_done <= '0';
              state <= DONE_2;
            end if;

          when DONE_2 =>
            ahb_busy <= '0';
            init_done <= '1';
            ram_init_done <= '0';
            state <= RISC_IDLE;

          when RISC_IDLE =>
            -- AXI signals (note: no write ability in this state machine, always returns error)
            AWREADY <= '1';
            WREADY <= '1';
            BID <= "0000";
            BRESP <= "10"; -- error return, no writes allowed
            BVALID <= '1';
            ARREADY <= '1';
            RID <= "0000";
            RDATA <= (others => '0');
            RRESP <= "00";
            RLAST <= '0';
            RVALID <= '0';
            if (ARVALID = '1') then
              ARREADY <= '0';
              -- offset from the base address in flash
              NVM_ADDR <= std_logic_vector(unsigned(x"0" & ARADDR(27 downto 0)) + unsigned'(x"60000000")); 
              state <= RISC_AC_0;
            end if;
          
          when RISC_AC_0 =>
            ARREADY <= '0';
            HTRANS <= "10";
            HSIZE <= "010";
            HWRITE <= '1';
            HADDR <= NVM_CTRL;
            HWDATA <= x"00000001";
            state <= RISC_AC_1;

          when RISC_AC_1 =>
            ARREADY <= '0';
            HTRANS <= "00";
            HSIZE <= "010";
            HWRITE <= '1';
            HADDR <= NVM_CTRL;
            HWDATA <= x"00000001";
            if (HREADY = '1') then
              state <= RISC_AC_2;
            else
              state <= RISC_AC_1;
            end if;

          when RISC_AC_2 =>
            ARREADY <= '0';
            HTRANS <= "00";
            HSIZE <= "010";
            HWRITE <= '1';
            HADDR <= NVM_CTRL;
            HWDATA <= x"00000001";
            if (HREADY = '1') then
              state <= RISC_AC_READ_0;
              HADDR <= NVM_CTRL;
            else
              state <= RISC_AC_2;
            end if;

          when RISC_AC_READ_0 =>
            ARREADY <= '0';
            HTRANS <= "10";
            HSIZE <= "010";
            HWRITE <= '0';
            HADDR <= NVM_CTRL;
            state <= RISC_AC_READ_1;
            
          when RISC_AC_READ_1 =>
            ARREADY <= '0';
            HTRANS <= "00";
            HSIZE <= "010";
            HWRITE <= '0';
            HADDR <= NVM_CTRL;
            if (HREADY = '1') then
              state <= RISC_AC_READ_2;
            else
              state <= RISC_AC_READ_1;
            end if;

          when RISC_AC_READ_2 =>
            ARREADY <= '0';
            HTRANS <= "00";
            HSIZE <= "010";
            HWRITE <= '0';
            HADDR <= NVM_CTRL;
            if (HREADY = '1') then
              DATAOUT <= HRDATA;
              state <= RISC_AC_CHECK;
            else
              state <= RISC_AC_READ_2;
            end if;

          when RISC_AC_CHECK =>
            ARREADY <= '0';
            if (DATAOUT(2 downto 0) = "110") then -- NVM is accessible by RISC-V 
              state <= RISC_READY_0;
              HADDR <= NVM_STATUS;
            else
              state <= RISC_AC_0;
              HADDR <= NVM_CTRL;
            end if;

          when RISC_READY_0 =>
            ARREADY <= '0';
            HTRANS <= "10";
            HSIZE <= "010";
            HWRITE <= '0';
            HADDR <= NVM_STATUS;
            state <= RISC_READY_1;    

          when RISC_READY_1 =>
            ARREADY <= '0';
            HTRANS <= "00";
            HSIZE <= "010";
            HWRITE <= '0';
            HADDR <= NVM_STATUS;
            if (HREADY = '1') then
              state <= RISC_READY_2;
            else
              state <= RISC_READY_1;
            end if;

          when RISC_READY_2 =>
            ARREADY <= '0';
            HTRANS <= "00";
            HSIZE <= "010";
            HWRITE <= '0';
            HADDR <= NVM_STATUS;
            if (HREADY = '1') then
              DATAOUT <= HRDATA;
              state <= RISC_READY_CHECK;
            else
              state <= RISC_READY_2;
            end if;

          when RISC_READY_CHECK =>
            ARREADY <= '0';
            if (DATAOUT(0) = '1') then -- NVM is ready for read
              state <= RISC_READ_NVM_0;
              HADDR <= NVM_ADDR;
            else
              state <= RISC_READY_0;
              HADDR <= NVM_STATUS;
            end if;

          when RISC_READ_NVM_0 =>
            ARREADY <= '0';
            HTRANS <= "10";
            HSIZE <= "010";
            HWRITE <= '0';
            HADDR <= NVM_ADDR;
            state <= RISC_READ_NVM_1;

          when RISC_READ_NVM_1 =>
            ARREADY <= '0';
            HTRANS <= "00";
            HSIZE <= "010";
            HWRITE <= '0';
            HADDR <= NVM_ADDR;
            if (HREADY = '1') then
              state <= RISC_READ_NVM_2;
            else
              state <= RISC_READ_NVM_1;
            end if;

          when RISC_READ_NVM_2 =>
            ARREADY <= '0';
            HTRANS <= "00";
            HSIZE <= "010";
            HWRITE <= '0';
            HADDR <= NVM_ADDR;
            if (HREADY = '1') then
              -- latch in data into data out
              DATAOUT <= HRDATA;
              RDATA <= HRDATA;
              RVALID <= '1';
              RLAST <= '1';
              state <= RISC_RRESP;
            else
              state <= RISC_READ_NVM_2;
            end if;

          when RISC_RRESP =>
            ARREADY <= '0';
            RDATA <= DATAOUT;
            RVALID <= '1';
            RLAST <= '1';
            if (RREADY = '1') then
              RVALID <= '0';
              RLAST <= '0';
              HADDR <= NVM_CTRL;
              state <= RISC_DONE_0;
            else
              state <= RISC_RRESP;
            end if;

          when RISC_DONE_0 =>
            ARREADY <= '0';
            HTRANS <= "10";
            HSIZE <= "010";
            HWRITE <= '1';
            HADDR <= NVM_CTRL;
            HWDATA <= x"00000000";
            state <= RISC_DONE_1;

          when RISC_DONE_1 =>
            ARREADY <= '0';
            HTRANS <= "00";
            HSIZE <= "010";
            HWRITE <= '1';
            HADDR <= NVM_CTRL;
            HWDATA <= x"00000000";
            state <= RISC_DONE_1;
            if (HREADY = '1') then
              ARREADY <= '1';
              state <= RISC_IDLE;
            end if;

          when others =>
            state <= IDLE;
        
        end case;
      end if;
    end if;
  end process;
end architecture rtl;
