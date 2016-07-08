library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.rv_components.all;
use work.top_util_pkg.all;

entity apb_to_ram is
  generic (
    REGISTER_SIZE : integer := 32;
    RAM_SIZE : integer :=  4096 -- number of bytes
  );
  port (
    reset : in std_logic;
    clk : in std_logic;
    SEL : out std_logic; -- signal to show when init is done

    -- connections from apb bus
    nvm_PADDR : in std_logic_vector(REGISTER_SIZE-1 downto 0);
    nvm_PENABLE : in std_logic;
    nvm_PWRITE : in std_logic;
    nvm_PRDATA : out std_logic_vector(REGISTER_SIZE-1 downto 0);
    nvm_PWDATA : in std_logic_vector(REGISTER_SIZE-1 downto 0);
    nvm_PREADY : out std_logic;
    nvm_PSEL : in std_logic;
    
    -- connections to MUX => BRAM
    nvm_addr : out std_logic_vector(REGISTER_SIZE-1 downto 0);
    nvm_wdata : out std_logic_vector(REGISTER_SIZE-1 downto 0);
    nvm_wen : out std_logic;
    nvm_byte_sel : out std_logic_vector(REGISTER_SIZE/8 -1 downto 0);
    nvm_strb : out std_logic;
    nvm_ack : in std_logic;
    nvm_rdata : in  std_logic_vector(REGISTER_SIZE-1 downto 0)
  );
end entity apb_to_ram;

architecture rtl of apb_to_ram is
  signal state : std_logic_vector(1 downto 0);
  --constant DONE_ADDR : std_logic_vector(REGISTER_SIZE-1 downto 0) := (log2(RAM_SIZE)-1 downto 2 => '1', others => '0');
  --constant DONE_ADDR : std_logic_vector(REGISTER_SIZE-1 downto 0) := X"000012FC";
  constant DONE_ADDR : std_logic_vector(REGISTER_SIZE-1 downto 0) := 
    std_logic_vector(to_unsigned(RAM_SIZE, 32) - to_unsigned(4, 32));
begin
  nvm_addr <= nvm_PADDR and X"0000FFFF";
  nvm_wdata <=  nvm_PWDATA;
  nvm_PRDATA <= nvm_rdata; 

  process(clk)
  begin
    if rising_edge(clk) then
      if (reset = '1') then
        state <= "00";
        nvm_wen <= '0';
        nvm_byte_sel <= (others => '0');
        nvm_strb <= '0';
        SEL <= '0';
      else
        case(state) is
          when "00" =>
            if (nvm_PSEL = '0') then
              state <= "00";
              --SEL <= '0';
            else
              state <= "01";
              --SEL <= '0';
              if (nvm_PWRITE = '1') then
                nvm_wen <= '1';
                nvm_strb <= '1';
                nvm_PREADY <= '1';
                nvm_byte_sel <= "1111";
              else
                nvm_wen <= '0';
                nvm_strb <= '1';
                nvm_PREADY <= '0';
                nvm_byte_sel <= "1111";
              end if;            
            end if;

          when "01" =>
            if (nvm_PWRITE = '1') then
              nvm_wen <= '0';
              nvm_strb <= '0';
              nvm_PREADY <= '1';
              state <= "00";
              nvm_byte_sel <= "0000";
              if ((nvm_PADDR and X"0000FFFF") = DONE_ADDR) then
                SEL <= '1';
              --else
                --SEL <= '0';
              end if;
            else 
              nvm_wen <= '0';
              nvm_strb <= '0';
              nvm_PREADY <= '0';
              state <= "10";
            end if;

          when "10" =>
            state <= "11";
            nvm_PREADY <= '1';
            
          when "11" =>
            state <= "00";
            nvm_wen <= '0';
            nvm_byte_sel <= "0000"; 

          when others =>
            state <= "00";
            nvm_wen <= '0';
            nvm_byte_sel <= (others => '0');
            nvm_strb <= '0';
        end case;
      end if;
    end if;
  end process;



end architecture rtl;
