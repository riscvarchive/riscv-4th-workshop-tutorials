library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.utils.all;

entity bram_microsemi is
  generic (
    RAM_DEPTH       : integer := 1024; -- this is the maximum
    RAM_WIDTH       : integer := 32;
    BYTE_SIZE       : integer := 8
    );
  port (
    clock    : in  std_logic;

    address  : in  std_logic_vector(log2(RAM_DEPTH)-1 downto 0);
    data_in  : in  std_logic_vector(RAM_WIDTH-1 downto 0);
    we       : in  std_logic;
    be       : in  std_logic_vector(RAM_WIDTH/BYTE_SIZE-1 downto 0);
    readdata : out std_logic_vector(RAM_WIDTH-1 downto 0);

    data_address  : in  std_logic_vector(log2(RAM_DEPTH)-1 downto 0);
    data_data_in  : in  std_logic_vector(RAM_WIDTH-1 downto 0);
    data_we       : in  std_logic;
    data_be       : in  std_logic_vector(RAM_WIDTH/BYTE_SIZE-1 downto 0);
    data_readdata : out std_logic_vector(RAM_WIDTH-1 downto 0)
    );
end entity bram_microsemi;

architecture rtl of bram_microsemi is
  type ram_type is array (RAM_DEPTH-1 downto 0) of std_logic_vector(BYTE_SIZE-1 downto 0);

  signal ram3     : ram_type := (others => (others => '0'));
  signal byte_we3 : std_logic;
  signal data_byte_we3 : std_logic;
  signal reg_address3 : std_logic_vector(log2(RAM_DEPTH)-1 downto 0);
  signal reg_data_address3 : std_logic_vector(log2(RAM_DEPTH)-1 downto 0);
  signal ram2     : ram_type := (others => (others => '0'));
  signal byte_we2 : std_logic;
  signal data_byte_we2 : std_logic;
  signal reg_address2 : std_logic_vector(log2(RAM_DEPTH)-1 downto 0);
  signal reg_data_address2 : std_logic_vector(log2(RAM_DEPTH)-1 downto 0);
  signal ram1     : ram_type := (others => (others => '0'));
  signal byte_we1 : std_logic;
  signal data_byte_we1 : std_logic;
  signal reg_address1 : std_logic_vector(log2(RAM_DEPTH)-1 downto 0);
  signal reg_data_address1 : std_logic_vector(log2(RAM_DEPTH)-1 downto 0);
  signal ram0     : ram_type := (others => (others => '0'));
  signal byte_we0 : std_logic;
  signal data_byte_we0 : std_logic;
  signal reg_address0 : std_logic_vector(log2(RAM_DEPTH)-1 downto 0);
  signal reg_data_address0 : std_logic_vector(log2(RAM_DEPTH)-1 downto 0);

  -- Uses RAM1K18
  attribute syn_ramstyle : string;
  attribute syn_preserve : boolean;
  attribute syn_ramstyle of ram3 : signal is "lsram";
  attribute syn_preserve of ram3 : signal is true;
  attribute syn_ramstyle of ram2 : signal is "lsram";
  attribute syn_preserve of ram2 : signal is true;
  attribute syn_ramstyle of ram1 : signal is "lsram";
  attribute syn_preserve of ram1 : signal is true;
  attribute syn_ramstyle of ram0 : signal is "lsram";
  attribute syn_preserve of ram0 : signal is true;

begin

  byte_we3 <= we and be(3);
  data_byte_we3 <= data_we and data_be(3);
  process (clock)
  begin
    if rising_edge(clock) then
      reg_address3 <= address;
      if byte_we3 = '1' then
        ram3(to_integer(unsigned(address))) <= data_in(31 downto 24);
      end if;

      reg_data_address3 <= data_address;
      if data_byte_we3 = '1' then
        ram3(to_integer(unsigned(data_address))) <= data_data_in(31 downto 24);
      end if;
    end if;
  end process;

  byte_we2 <= we and be(2);
  data_byte_we2 <= data_we and data_be(2);
  process (clock)
  begin
    if rising_edge(clock) then
      reg_address2 <= address;
      if byte_we2 = '1' then
        ram2(to_integer(unsigned(address))) <= data_in(23 downto 16);
      end if;

      reg_data_address2 <= data_address;
      if data_byte_we2 = '1' then
        ram2(to_integer(unsigned(data_address))) <= data_data_in(23 downto 16);
      end if;
    end if;
  end process;

  byte_we1 <= we and be(1);
  data_byte_we1 <= data_we and data_be(1);
  process (clock)
  begin
    if rising_edge(clock) then
      reg_address1 <= address;
      if byte_we1 = '1' then
        ram1(to_integer(unsigned(address))) <= data_in(15 downto 8);
      end if;

      reg_data_address1 <= data_address;
      if data_byte_we1 = '1' then
        ram1(to_integer(unsigned(data_address))) <= data_data_in(15 downto 8);
      end if;
    end if;
  end process;

  byte_we0 <= we and be(0);
  data_byte_we0 <= data_we and data_be(0);
  process (clock)
  begin
    if rising_edge(clock) then
      reg_address0 <= address;
      if byte_we0 = '1' then
        ram0(to_integer(unsigned(address))) <= data_in(7 downto 0);
      end if;
      
      reg_data_address0 <= data_address;
      if data_byte_we0 = '1' then
        ram0(to_integer(unsigned(data_address))) <= data_data_in(7 downto 0);
      end if;
    end if;
  end process;
  
  readdata <= ram3(to_integer(unsigned(reg_address3))) & 
              ram2(to_integer(unsigned(reg_address2))) &
              ram1(to_integer(unsigned(reg_address1))) &
              ram0(to_integer(unsigned(reg_address0)));
  data_readdata <= ram3(to_integer(unsigned(reg_data_address3))) & 
                   ram2(to_integer(unsigned(reg_data_address2))) &
                   ram1(to_integer(unsigned(reg_data_address1))) &
                   ram0(to_integer(unsigned(reg_data_address0)));
end architecture rtl;
