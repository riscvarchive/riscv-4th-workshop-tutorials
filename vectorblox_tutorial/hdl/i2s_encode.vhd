library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;



entity i2s_encode is

  port (
    clk   : in std_logic;
    reset : in std_logic;

    ws   : out std_logic;
    sd   : out  std_logic;
    sclk : out std_logic;

    clk_divider : in  std_logic_vector(31 downto 0);
    pdata       : out std_logic_vector(31 downto 0);
    data_valid  : out std_logic);

end entity i2s_encode;

architecture rtl of i2s_encode is
  signal count        : unsigned(clk_divider'range) := (others => '0');
  signal word_select  : std_logic;
  signal serial_clock : std_logic;
  signal bit_count    : unsigned(4 downto 0);

  signal internal_data : std_logic_vector(pdata'range);
begin  -- architecture rtl


  process(clk)
  begin
    if rising_edge(clk) then
      count      <= count +1;
      data_valid <= '0';
      if count > unsigned(clk_divider) then
        count        <= (others => '0');
        serial_clock <= not serial_clock;
        if serial_clock = '1' then
          bit_count     <= bit_count +1;
          internal_data <= internal_data(internal_data'left -1 downto 0) & sd;
          if bit_count = 1 then         --lsb happens one cycle after ws transitions
            data_valid  <= '1';
          end if;
        end if;

      end if;
      if reset = '1' then
        count        <= (others => '0');
        bit_count    <= (others => '0');
        word_select  <= '0';
        serial_clock <= '0';
        internal_data <= x"00000000" ;
      end if;
    end if;
  end process;

  ws    <= bit_count(bit_count'left);
  sclk  <= serial_clock;
  pdata <= internal_data;
end architecture rtl;
