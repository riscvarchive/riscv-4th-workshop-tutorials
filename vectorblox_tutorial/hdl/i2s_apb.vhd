library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;


library work;
use work.top_util_pkg.all;
-------------------------------------------------------------------------------
-- Address Map
-- 0x00 Version
-- 0x04 clock_divider
-- 0x08 DATA
-------------------------------------------------------------------------------address


entity i2s_apb is
  generic (REGISTER_SIZE : integer                := 32;
           DATA_WIDTH    : integer range 16 to 32 := 32);
  port (
    PCLK    : in std_logic;
    PRESETN : in std_logic;

    PADDR   : in  std_logic_vector(REGISTER_SIZE -1 downto 0);
    PENABLE : in  std_logic;
    PWRITE  : in  std_logic;
    PRDATA  : out std_logic_vector(REGISTER_SIZE-1 downto 0);
    PWDATA  : in  std_logic_vector(REGISTER_SIZE-1 downto 0);
    PREADY  : out std_logic;
    PSEL    : in  std_logic;

    i2s_sd_i  : in  std_logic;          -- I2S data input
    rx_int_i  : out std_logic;          -- Interrupt line
    i2s_sck_i : in  std_logic;          -- I2S clock out
    i2s_ws_i  : in  std_logic);         -- I2S word select out

end entity i2s_apb;


architecture rtl of i2s_apb is
  alias clk : std_logic is PCLK;

  component i2s_decode_slave is

    port (
      clk         : in  std_logic;
      reset       : in  std_logic;
      ws          : in  std_logic;
      sd          : in  std_logic;
      sclk        : in  std_logic;
      clk_divider : in  std_logic_vector(31 downto 0);
      pdata       : out std_logic_vector(31 downto 0);
      data_valid  : out std_logic);

  end component i2s_decode_slave;

  constant CLOCK_DIVIDER : integer := 12000000/(8000*64*2);

  constant FIFO_DEPTH   : integer := 32;
  signal i2s_data       : std_logic_vector(31 downto 0);
  signal i2s_data_valid : std_logic;

  signal write_ptr : unsigned(log2(FIFO_DEPTH)-1 downto 0);
  signal read_ptr  : unsigned(log2(FIFO_DEPTH)-1 downto 0);


  type dpram is array(FIFO_DEPTH downto 0) of std_logic_vector(DATA_WIDTH-1 downto 0);
  signal fifo : dpram := (others => (others => '0'));

  signal fifo_full    : boolean;
  signal fifo_empty   : boolean;
  signal fifo_dataout : std_logic_vector(fifo(0)'range);

  signal do_read : boolean;

  signal reset : std_logic;
  type state_t is (IDLE,
                   READ_0,
                   READ_1
                   );
  signal state     : state_t;
  signal read_done : std_logic;


  constant REGISTER_NAME_SIZE     : integer                                 := 4;
  constant VERSION_REGISTER       : unsigned(REGISTER_NAME_SIZE-1 downto 0) := x"0";
  constant CLOCK_DIVIDER_REGISTER : unsigned(REGISTER_NAME_SIZE-1 downto 0) := x"4";
  constant DATA_REGISTER          : unsigned(REGISTER_NAME_SIZE-1 downto 0) := x"8";
  signal addr                     : unsigned(REGISTER_NAME_SIZE-1 downto 0);

begin  -- architecture rtl

  reset <= not PRESETN;

  dec : i2s_decode_slave
    port map (
      clk   => PCLK,
      reset => reset,
      ws    => i2s_ws_i,
      sd    => i2s_sd_i,
      sclk  => i2s_sck_i,

      clk_divider => std_logic_vector(to_unsigned(CLOCK_DIVIDER, 32)),
      pdata       => i2s_data,
      data_valid  => i2s_data_valid);

  --write pointer increment after write
  --read pointer increment after read
  fifo_empty <= write_ptr = read_ptr;
  fifo_full  <= write_ptr + 1 = read_ptr;

  --write pointer control
  process(clk)
  begin
    if rising_edge(clk) then
      if i2s_data_valid = '1' and not fifo_full then
        write_ptr <= write_ptr +1;
      end if;
      if reset = '1' then
        write_ptr <= to_unsigned(0, write_ptr'length);
      end if;
    end if;
  end process;

  --fifo read and write
  process(clk)
  begin
    if rising_edge(clk) then
      if i2s_data_valid = '1' and not fifo_full then
        fifo(to_integer(write_ptr)) <= i2s_data;
      end if;
      fifo_dataout <= fifo(to_integer(read_ptr));
      if read_ptr = write_ptr then      --read_during write
        fifo_dataout <= i2s_data;
      end if;
    end if;
  end process;

  PREADY <= (not PENABLE) or read_done;
  addr   <= unsigned(PADDR(addr'range));
  process(clk)
  begin
    if rising_edge(clk) then
      if (reset = '1') then
        read_ptr  <= to_unsigned(0, read_ptr'length);
        state     <= IDLE;
        PRDATA    <= (others => '0');
        read_done <= '0';
      else
        state     <= state;
        PRDATA    <= (others => '0');
        read_done <= '0';
        case (state) is
          when IDLE =>
            read_done <= '0';
            if (PENABLE = '1' and PWRITE = '0') then
              state <= READ_0;
            end if;

          when READ_0 =>
            case (addr) is
              when VERSION_REGISTER =>
                PRDATA    <= x"00010000";
                read_done <= '1';
                state     <= READ_1;
              when CLOCK_DIVIDER_REGISTER =>
                PRDATA    <= std_logic_vector(to_unsigned(CLOCK_DIVIDER, 32));
                read_done <= '1';
                state     <= READ_1;
              when DATA_REGISTER =>
                PRDATA    <= fifo_dataout;
                read_done <= '0';
                if not fifo_empty then
                  read_done <= '1';
                  read_ptr  <= read_ptr + 1;
                  state     <= READ_1;
                end if;
              when others =>
                PRDATA    <= (others => '0');
                read_done <= '1';
                state     <= READ_1;
            end case;

          when READ_1 =>                -- let PENABLE come low
            read_done <= '0';
            state     <= IDLE;

          when others =>
            state <= IDLE;
        end case;
      end if;
    end if;
  end process;



--  do_read    <= (wb_cyc_i and wb_stb_i and not wb_we_i) = '1';
--  wb_stall_o <= '1' when fifo_empty and do_read and unsigned(wb_adr_i) = DATA_REGISTER else '0';
--  addr       <= unsigned(wb_adr_i(addr'range));
--  process(clk)
--  begin
--    if rising_edge(clk) then
--      wb_ack_o <= '0';
--      wb_dat_o <= (others => '-');
--      if do_read then
--        case addr is
--          when VERSION_REGISTER =>
--            wb_dat_o <= x"00010000";
--            wb_ack_o <= '1';
--          when CLOCK_DIVIDER_REGISTER =>
--            wb_dat_o <= std_logic_vector(to_unsigned(CLOCK_DIVIDER, 32));
--            wb_ack_o <= '1';
--          when DATA_REGISTER =>
--            wb_dat_o <= fifo_dataout;
--            if not fifo_empty then
--              wb_ack_o <= '1';
--              read_ptr <= read_ptr +1;
--            end if;
--          when others => null;
--        end case;
--      end if;
--      if reset = '1' then
--        read_ptr  <= to_unsigned(0, read_ptr'length);
--      end if;
--    end if;
--  end process;

end architecture rtl;
