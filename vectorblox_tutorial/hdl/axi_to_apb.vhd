library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity axi_to_apb is
  generic (
    REGISTER_SIZE : integer := 32;
    BYTE_SIZE : integer := 8
  );
  port (
    clk : in std_logic;
    aresetn : in std_logic;

    AWID : in std_logic_vector(3 downto 0);
    AWADDR : in std_logic_vector(REGISTER_SIZE-1 downto 0);
    AWLEN : in std_logic_vector(3 downto 0);
    AWSIZE : in std_logic_vector(2 downto 0);
    AWBURST : in std_logic_vector(1 downto 0);
    AWLOCK : in std_logic_vector(1 downto 0);
    AWVALID : in std_logic;
    AWREADY : out std_logic;

    WID : in std_logic_vector(3 downto 0);
    WSTRB : in std_logic_vector(REGISTER_SIZE/BYTE_SIZE -1 downto 0);
    WLAST : in std_logic;
    WVALID : in std_logic;
    WDATA : in std_logic_vector(REGISTER_SIZE-1 downto 0);
    WREADY : out std_logic;
    
    BID : out std_logic_vector(3 downto 0);
    BRESP : out std_logic_vector(1 downto 0);
    BVALID : out std_logic;
    BREADY : in std_logic;

    ARID : in std_logic_vector(3 downto 0);
    ARADDR : in std_logic_vector(REGISTER_SIZE-1 downto 0);
    ARLEN : in std_logic_vector(3 downto 0);
    ARSIZE : in std_logic_vector(2 downto 0);
    ARLOCK : in std_logic_vector(1 downto 0);
    ARBURST : in std_logic_vector(1 downto 0);
    ARVALID : in std_logic;
    ARREADY : out std_logic;

    RID : out std_logic_vector(3 downto 0);
    RDATA : out std_logic_vector(REGISTER_SIZE-1 downto 0);
    RRESP : out std_logic_vector(1 downto 0);
    RLAST : out std_logic;
    RVALID : out std_logic;
    RREADY : in std_logic;

    PADDR : out std_logic_vector(REGISTER_SIZE-1 downto 0);
    PENABLE : out std_logic;
    PWRITE : out std_logic;
    PRDATA : in std_logic_vector(REGISTER_SIZE-1 downto 0);
    PWDATA : out std_logic_vector(REGISTER_SIZE-1 downto 0);
    PREADY : in std_logic;
    PSEL : out std_logic
  );
end entity axi_to_apb;

architecture rtl of axi_to_apb is

  type state_t is (IDLE,
                   WRITE_0,
                   WRITE_1,
                   BRESP_0,
                   READ_0,
                   READ_1,
                   RRESP_0);
  signal state : state_t;

begin

  process(clk)
  begin
  
    if rising_edge(clk) then
      if (aresetn = '0') then
        state <= IDLE;
        PADDR <= (others => '0');
        PENABLE <= '0';
        PWRITE <= '0';
        PWDATA <= (others => '0');
        PSEL <= '0';
        AWREADY <= '0';
        WREADY <= '0';
        BID <= (others => '0');
        BRESP <= (others => '0');
        BVALID <= '0';
        RID <= (others => '0');
        RDATA <= (others => '0');
        RRESP <= (others => '0');
        RLAST <= '0';
        RVALID <= '0';

      else
        case state is
          when IDLE =>
            PENABLE <= '0';
            if (PREADY = '1') then
              AWREADY <= '1';
              WREADY <= '1';
              ARREADY <= '1';
              if (AWVALID = '1' and WVALID = '1') then        
                AWREADY <= '0';
                WREADY <= '0';
                ARREADY <= '0';
                PADDR <= AWADDR;
                PWDATA <= WDATA;
                PWRITE <= '1';
                PSEL <= '1';
                state <= WRITE_0;
              elsif (ARVALID = '1') then
                AWREADY <= '0';
                WREADY <= '0';
                ARREADY <= '0';
                PADDR <= ARADDR;
                PWRITE <= '0';
                PSEL <= '1';
                state <= READ_0;
              end if;
            else
              AWREADY <= '0';
              WREADY <= '0';
              ARREADY <= '0';
            end if;

          when WRITE_0 =>
            PENABLE <= '1';
            state <= WRITE_1;
          
          when WRITE_1 =>
            if (PREADY = '1') then
              PSEL <= '0';
              PENABLE <= '0';
              BVALID <= '1';
              BRESP <= "00";
              state <= BRESP_0;
            end if;

          when BRESP_0 => 
            if (BREADY = '1') then
              BVALID <= '0';
              AWREADY <= '1';
              WREADY <= '1';
              ARREADY <= '1';
              state <= IDLE;
            end if;

          when READ_0 =>
            PENABLE <= '1';
            state <= READ_1;

          when READ_1 =>
            if (PREADY = '1') then
              PSEL <= '0';
              PENABLE <= '0';
              RDATA <= PRDATA;
              RVALID <= '1';
              RRESP <= "00";
              state <= RRESP_0;
            end if;

          when RRESP_0 =>
            if (RREADY = '1') then
              RVALID <= '0';
              AWREADY <= '1';
              WREADY <= '1';
              ARREADY <= '1';
              state <= IDLE;
            end if;

        end case;      
      end if;
    end if;
  end process;
end architecture;


