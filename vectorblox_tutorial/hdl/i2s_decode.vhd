library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;



entity i2s_decode_slave is

  port (
    clk   : in std_logic;
    reset : in std_logic;

    ws   : in std_logic;
    sd   : in std_logic;
    sclk : in std_logic;

    clk_divider : in  std_logic_vector(31 downto 0);
    pdata       : out std_logic_vector(31 downto 0);
    data_valid  : out std_logic);

end entity i2s_decode_slave;

architecture rtl of i2s_decode_slave is
  signal old_sclk : std_logic;
  signal old_ws   : std_logic;

  signal internal_data       : std_logic_vector(pdata'length/2 -1 downto 0);
  signal internal_data_left  : std_logic_vector(pdata'length/2 -1 downto 0);
  signal internal_data_right : std_logic_vector(pdata'length/2-1 downto 0);

  signal bit_select : std_logic_vector(pdata'length/2 -1 downto 0);
  constant WS_LEFT  : std_logic := '1';
  constant WS_RIGHT : std_logic := '0';
  signal sd_vector  : std_logic_vector(bit_select'range);

begin  -- architecture rtl
  sd_vector <= (others => '0')when sd = '0' else (others => '1');

  process(clk)

  begin
    if rising_edge(clk) then
      old_sclk   <= sclk;
      data_valid <= '0';
      if old_sclk /= sclk and sclk = '1' then  --rising edge sclk
        old_ws     <= ws;
        if old_ws = WS_LEFT then 
          internal_data_left <= internal_data_left(internal_data_left'left-1 downto 0) & sd;
        else
          internal_data_right <= internal_data_right(internal_data_right'left-1 downto 0) & sd;
        end if;
        if ws /= old_ws and ws = WS_LEFT then
          data_valid                                   <= '1';
        end if;
      end if;

    end if;
  end process;
  pdata <= internal_data_left& internal_data_right;
end architecture rtl;
