library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.utils.all;

entity iram is

  generic (
    SIZE        : integer := 4096;
    RAM_WIDTH   : integer := 32;
    BYTE_SIZE   : integer := 8);    
  port (
    clk : in std_logic;

    addr : in std_logic_vector(RAM_WIDTH-1 downto 0);
    wdata : in std_logic_vector(RAM_WIDTH-1 downto 0);
    wen  : in std_logic;
    byte_sel : in std_logic_vector(RAM_WIDTH/8-1 downto 0);
    strb  : in std_logic;
    ack   : out std_logic;
    rdata   : out std_logic_vector(RAM_WIDTH-1 downto 0);
    
    data_addr : in std_logic_vector(RAM_WIDTH-1 downto 0);
    data_wdata : in std_logic_vector(RAM_WIDTH-1 downto 0);
    data_wen : in std_logic;
    data_byte_sel : in std_logic_vector(RAM_WIDTH/BYTE_SIZE -1 downto 0);
    data_strb : in std_logic;
    data_ack : out std_logic;
    data_rdata : out std_logic_vector(RAM_WIDTH-1 downto 0)

  );
end entity iram;

architecture rtl of iram is

  constant BYTES_PER_WORD : integer := RAM_WIDTH/8;

  signal address : std_logic_vector(log2(SIZE/BYTES_PER_WORD)-1 downto 0);
  signal write_en : std_logic;
  signal data_address : std_logic_vector(log2(SIZE/BYTES_PER_WORD)-1 downto 0);
  signal data_write_en : std_logic;
begin  
  
  address <= addr(address'left+log2(BYTES_PER_WORD) downto log2(BYTES_PER_WORD));
  write_en <= wen and strb; 

  data_address <= data_addr(address'left+log2(BYTES_PER_WORD) downto log2(BYTES_PER_WORD));
  data_write_en <= data_wen and data_strb;

  ram : entity work.bram_microsemi
    generic map (
      RAM_DEPTH => SIZE/4,
      RAM_WIDTH => RAM_WIDTH,
      BYTE_SIZE => BYTE_SIZE)
    port map (
      clock    => clk,

      address  => address,
      data_in  => wdata,
      we       => write_en,
      be       => byte_sel,
      readdata => rdata,

      data_address => data_address,
      data_data_in => data_wdata,
      data_we => data_write_en,
      data_be => data_byte_sel,
      data_readdata => data_rdata
      );
    process(clk)
    begin
      if rising_edge(clk) then
        ack <= strb and (not wen);
        data_ack <= data_strb and (not data_wen);
      end if;
    end process;

end architecture rtl;
