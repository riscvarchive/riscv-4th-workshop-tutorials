library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.rv_components.all;

entity axi_master is
  generic (
    REGISTER_SIZE : integer := 32;
    BYTE_SIZE : integer := 8
  );

  port (
    ACLK : in std_logic;
    ARESETN : in std_logic;
    -- AVALON BUS IN
    avm_data_address : in std_logic_vector(REGISTER_SIZE-1 downto 0);
    avm_data_byteenable : in std_logic_vector(REGISTER_SIZE/BYTE_SIZE -1 downto 0);
    avm_data_read : in std_logic;
    avm_data_readdata : out std_logic_vector(REGISTER_SIZE-1 downto 0);
    avm_data_response : out std_logic_vector(1 downto 0);
    avm_data_write : in std_logic;
    avm_data_writedata : in std_logic_vector(REGISTER_SIZE-1 downto 0);
    avm_data_lock : in std_logic;
    avm_data_waitrequest : out std_logic;
    avm_data_readdatavalid : out std_logic;

    -- AXI BUS OUT
    AWID : out std_logic_vector(3 downto 0);
    AWADDR : out std_logic_vector(REGISTER_SIZE-1 downto 0);
    AWLEN : out std_logic_vector(3 downto 0);
    AWSIZE : out std_logic_vector(2 downto 0);
    AWBURST : out std_logic_vector(1 downto 0);
    AWLOCK : out std_logic_vector(1 downto 0);
    AWVALID : out std_logic;
    AWREADY : in std_logic;

    WID : out std_logic_vector(3 downto 0);
    WSTRB : out std_logic_vector(REGISTER_SIZE/BYTE_SIZE -1 downto 0);
    WLAST : out std_logic;
    WVALID : out std_logic;
    WDATA : out std_logic_vector(REGISTER_SIZE-1 downto 0);
    WREADY : in std_logic;
    
    BID : in std_logic_vector(3 downto 0);
    BRESP : in std_logic_vector(1 downto 0);
    BVALID : in std_logic;
    BREADY : out std_logic;

    ARID : out std_logic_vector(3 downto 0);
    ARADDR : out std_logic_vector(REGISTER_SIZE-1 downto 0);
    ARLEN : out std_logic_vector(3 downto 0);
    ARSIZE : out std_logic_vector(2 downto 0);
    ARLOCK : out std_logic_vector(1 downto 0);
    ARBURST : out std_logic_vector(1 downto 0);
    ARVALID : out std_logic;
    ARREADY : in std_logic;

    RID : in std_logic_vector(3 downto 0);
    RDATA : in std_logic_vector(REGISTER_SIZE-1 downto 0);
    RRESP : in std_logic_vector(1 downto 0);
    RLAST : in std_logic;
    RVALID : in std_logic;
    RREADY : out std_logic;

    NEXT_DATA_IN : out std_logic;
    DATA_BURST_NUM : buffer std_logic_vector(3 downto 0)
  );
    
end entity axi_master;

architecture rtl of axi_master is
  type w_state_t is (IDLE_0,
                     IDLE_1,
                     WRITE_0,
                     --WRITE_1, 
                     WRITE_2,
                     BRESP_0,
                     BRESP_1);
  type r_state_t is (READ_0,
                     READ_1,
                     READ_2,
                     READ_3,
                     READ_4);

  signal write_state : w_state_t;
  signal read_state : r_state_t;
  signal w_tr_length : std_logic_vector(3 downto 0);
  signal r_tr_length : std_logic_vector(3 downto 0);
  signal AXI_WC_BUSY : std_logic;
  signal AXI_RC_BUSY : std_logic;

  signal write_finished : std_logic;
  signal read_finished : std_logic;

  -- 1 transfer
  constant BURST_LEN    : std_logic_vector(3 downto 0) := "0000";
  -- 4 bytes in transfer
  constant BURST_SIZE   : std_logic_vector(2 downto 0) := "010";
  -- incremental bursts
  constant BURST_INCR   : std_logic_vector(1 downto 0) := "01";



begin
  AWLEN <= BURST_LEN;
  AWLOCK <= "00";
  AWID <= "0000";
  WID <= "0000";
  ARLEN <= BURST_LEN;
  ARLOCK <= "00";
  ARID <= "0000";
  
  AXI_WC_BUSY <= avm_data_write and (not write_finished);
  AXI_RC_BUSY <= avm_data_read and (not read_finished);
 
  avm_data_waitrequest <= AXI_WC_BUSY or AXI_RC_BUSY;

  avm_data_response <= BRESP when (avm_data_write = '1') else
                       RRESP when (avm_data_read = '1') else
                       "00";

  process(ACLK)
  variable aw_done : std_logic := '0';
  variable w_done : std_logic := '0';
  begin
    if rising_edge(ACLK) then
      if (ARESETN = '0') then
        aw_done := '0';
        w_done := '0';
        AWSIZE <=  "000";
        AWBURST <= BURST_INCR;
        AWVALID <= '0';
        AWADDR <= (others => '0');
        WSTRB <= "0000";
        WVALID <= '0';
        WLAST <= '0';
        WDATA <= (others => '0');
        BREADY <= '0';
        write_state <= IDLE_0;
        w_tr_length <= "0000";
        NEXT_DATA_IN <= '0';
        write_finished <= '0';
      else
        case (write_state) is
          when IDLE_0 =>
            write_state <= IDLE_1;
            w_tr_length <= "0000";
            w_done := '0';
            aw_done := '0';
            write_finished <= '0';

          when IDLE_1 =>
            BREADY <= '0';
            w_tr_length <= "0000";
            write_finished <= '0';
            w_done := '0';
            aw_done := '0';
            if (avm_data_write = '1') then
              -- address bus
              AWSIZE <= BURST_SIZE;
              AWBURST <= BURST_INCR;
              AWADDR <= avm_data_address;
              AWVALID <= '1';
              -- write bus
              WSTRB <= avm_data_byteenable;
              WDATA <= avm_data_writedata;
              if (w_tr_length = BURST_LEN) then
                WLAST <= '1';
              else
                WLAST <= '0';
              end if;
              WVALID <= '1';
              write_state <= WRITE_0;
            else
              write_state <= IDLE_1;
            end if;
          
          when WRITE_0 =>
            if (AWREADY = '1') then
              AWVALID <= '0';
              aw_done := '1';
            end if;
            if (WREADY = '1') then
              WVALID <= '0';
              w_done := '1';
            end if;
            if ((aw_done = '1') and (w_done = '1')) then
              aw_done := '0';
              w_done := '0';
              NEXT_DATA_IN <= '0';
              if (w_tr_length = BURST_LEN) then
                WLAST <= '0';
                write_state <= BRESP_0;
              else
                write_state <= WRITE_2;
                w_tr_length <= std_logic_vector(unsigned(w_tr_length) + to_unsigned(1, 4)); 
                NEXT_DATA_IN <= '1';
              end if;
            end if;
            --if (AWREADY = '1') then
            --  --AWVALID <= '0'; address lines still valid
            --  write_state <= WRITE_1;
            --  WVALID <= '1';
            --  if (w_tr_length = BURST_LEN) then
            --    WLAST <= '1';
            --  end if;
            --else
            --  write_state <= WRITE_0;
            --end if;
            
          --when WRITE_1 =>
          --  if (WREADY = '1') then
          --    WVALID <= '0';
          --    NEXT_DATA_IN <= '0';
          --    if (w_tr_length = BURST_LEN) then
          --      write_state <= BRESP_0;
          --      WLAST <= '0';
          --    else
          --      write_state <= WRITE_2;
          --      AXI_WC_BUSY <= '1';
          --      w_tr_length <= std_logic_vector(unsigned(w_tr_length) + to_unsigned(1, 4)); 
          --      NEXT_DATA_IN <= '1';
          --    end if;     
          --  end if;

          when WRITE_2 =>
            WDATA <= avm_data_writedata;
            WSTRB <= avm_data_byteenable;
            WVALID <= '1';
            w_done := '0';
            write_state <= WRITE_0;
            NEXT_DATA_IN <= '0';
            if (w_tr_length = BURST_LEN) then
              WLAST <= '1';
            else
              WLAST <= '0';
            end if;

          when BRESP_0 =>
            if (BVALID = '1') then
              BREADY <= '1';
              write_finished <= '1';
              write_state <= BRESP_1;
            else
              write_state <= BRESP_0;
            end if;

          when BRESP_1 =>
            write_finished <= '0';
            BREADY <= '0';
            write_state <= IDLE_1;
             
        end case;
      end if;
    end if;
  end process;

  process(ACLK)
  begin
    if rising_edge(ACLK) then
      if (ARESETN = '0') then
        ARSIZE <= "000";
        ARBURST <= BURST_INCR;
        ARVALID <= '0';
        RREADY <= '0';
        ARADDR <= (others => '0');
        read_state <= READ_0;
        r_tr_length <= "0000";
        DATA_BURST_NUM <= "0000";
        avm_data_readdatavalid <= '0';
        read_finished <= '0';
      else
        case (read_state) is
          when READ_0 =>
            ARVALID <= '0';
            RREADY <= '0';
            r_tr_length <= "0000";
            DATA_BURST_NUM <= "0000";
            avm_data_readdatavalid <= '0';
            read_finished <= '0';
            if (avm_data_read = '1') then
              read_state <= READ_2;
              ARSIZE <= BURST_SIZE;
              ARBURST <= BURST_INCR;
              ARADDR <= avm_data_address;
              RREADY <= '0';
              ARVALID <= '1';
            else
              read_state <= READ_0;
            end if;

          when READ_1 =>
            ARSIZE <= BURST_SIZE;
            ARBURST <= BURST_INCR;
            ARADDR <= avm_data_address;
            RREADY <= '0';
            ARVALID <= '1';
            read_state <= READ_2;

          when READ_2 =>
            if (ARREADY = '1') then
              ARVALID <= '0';
              RREADY <= '1';
              read_state <= READ_3;
            else
              read_state <= READ_2;
            end if;

          when READ_3 =>
            if ((RVALID = '1') and (r_tr_length = BURST_LEN)) then
              read_state <= READ_4;
              avm_data_readdata <= RDATA;
              read_finished <= '1';
              RREADY <= '0';
              DATA_BURST_NUM <= std_logic_vector(unsigned(DATA_BURST_NUM) + to_unsigned(1, 4));
              avm_data_readdatavalid <= '0';
            elsif ((RVALID = '1') and (r_tr_length /= BURST_LEN)) then
              r_tr_length <= std_logic_vector(unsigned(r_tr_length) + to_unsigned(1, 4));
              DATA_BURST_NUM <= std_logic_vector(unsigned(DATA_BURST_NUM) + to_unsigned(1, 4));
              read_state <= READ_3;
              avm_data_readdata <= RDATA;
              avm_data_readdatavalid <= '1';
            else
              read_state <= READ_3;
            end if;

          when READ_4 => -- this is here to handle pipelined reads
            avm_data_readdatavalid <= '1';
            read_finished <= '0';
            read_state <= READ_0;

        end case;
      end if;
    end if;
  end process;


end architecture;
