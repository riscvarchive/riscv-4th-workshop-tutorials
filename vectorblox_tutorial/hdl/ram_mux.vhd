library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.utils.all;

entity ram_mux is
  generic (
    DATA_WIDTH : natural := 32;
    ADDR_WIDTH : natural := 32
  );
  port (
    -- init signals
    nvm_addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
    nvm_wdata : in std_logic_vector(DATA_WIDTH-1 downto 0);
    nvm_wen : in std_logic;
    nvm_byte_sel : in std_logic_vector(DATA_WIDTH/8 -1 downto 0);
    nvm_strb : in std_logic;
    nvm_ack : out std_logic;
    nvm_rdata : out std_logic_vector(DATA_WIDTH-1 downto 0);

    -- user signals
    user_instruction_address       : in std_logic_vector(ADDR_WIDTH-1 downto 0);
    user_instruction_byteenable    : in std_logic_vector(DATA_WIDTH/8 -1 downto 0);
    user_instruction_read          : in std_logic;
    user_instruction_readdata      : out std_logic_vector(DATA_WIDTH-1 downto 0);
    user_instruction_response      : out std_logic_vector(1 downto 0);
    user_instruction_write         : in std_logic;
    user_instruction_writedata     : in std_logic_vector(DATA_WIDTH-1 downto 0);
    user_instruction_lock          : in std_logic; -- undriven
    user_instruction_waitrequest   : out std_logic; 
    user_instruction_readdatavalid : out std_logic; 
    
    -- mux signals/ram inputs
    SEL : in std_logic;
    ram_addr : out std_logic_vector(ADDR_WIDTH-1 downto 0);
    ram_wdata : out std_logic_vector(DATA_WIDTH-1 downto 0);
    ram_wen : out std_logic;
    ram_byte_sel : out std_logic_vector(DATA_WIDTH/8-1 downto 0);
    ram_strb : out std_logic;
    ram_ack : in std_logic;
    ram_rdata : in std_logic_vector(DATA_WIDTH-1 downto 0)
  );  
end entity ram_mux;

architecture rtl of ram_mux is
begin
  ram_addr <= nvm_addr when (SEL = '0') else user_instruction_address;
  ram_wdata <= nvm_wdata when (SEL = '0') else user_instruction_writedata;
  ram_wen <= nvm_wen when (SEL = '0') else ((not user_instruction_read) and (user_instruction_write));
  ram_byte_sel <= nvm_byte_sel when (SEL = '0') else user_instruction_byteenable;
  nvm_rdata <= ram_rdata when (SEL = '0') else (others => '0');
  user_instruction_readdata <= ram_rdata when (SEL = '1') else (others => '0');
  ram_strb <= nvm_strb when (SEL = '0') else (user_instruction_read or user_instruction_write); 
  nvm_ack <= ram_ack when (SEL = '0') else '0';

  user_instruction_waitrequest <= not SEL;
  user_instruction_readdatavalid <= SEL and ram_ack;
  user_instruction_response <= "00";
    
end architecture rtl;
