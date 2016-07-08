library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.rv_components.all;

entity riscV_axi is

  generic (
    REGISTER_SIZE      : integer              := 32;
    RESET_VECTOR       : natural              := 16#00000200#;
    MULTIPLY_ENABLE    : natural range 0 to 1 := 0;
    DIVIDE_ENABLE      : natural range 0 to 1 := 0;
    SHIFTER_MAX_CYCLES : natural              := 1;
    COUNTER_LENGTH     : natural              := 64;
    BRANCH_PREDICTORS  : natural              := 0;
    PIPELINE_STAGES    : natural range 4 to 5 := 5;
    FORWARD_ALU_ONLY   : natural range 0 to 1 := 1;
    IRAM_SIZE          : natural              := 8192;
    BYTE_SIZE          : integer              := 8);

  port (clk : in std_logic;
        reset : in std_logic;

        --conduit end point
        coe_to_host         : out std_logic_vector(REGISTER_SIZE -1 downto 0);
        coe_from_host       : in  std_logic_vector(REGISTER_SIZE -1 downto 0);
        coe_program_counter : out std_logic_vector(REGISTER_SIZE -1 downto 0);
        
        -- DATA DDR2 OUTPUT
        -- Write address channel ---------------------------------------------------------
        data_AWID    : out std_logic_vector(3 downto 0); -- ID for write address signals
        data_AWADDR  : out std_logic_vector(REGISTER_SIZE -1 downto 0); -- Address of the first transferin a burst
        data_AWLEN   : out std_logic_vector(3 downto 0); -- Number of transfers in a burst, burst must not cross 4 KB boundary, burst length of 1 to 16 transfers in AXI3
        data_AWSIZE  : out std_logic_vector(2 downto 0); -- Maximum number of bytes to transfer in each data transfer (beat) in a burst 
        -- See Table A3-2 for AxSIZE encoding
        -- 0b010 => 4 bytes in a transfer
        data_AWBURST : out std_logic_vector(1 downto 0); -- defines the burst type, fixed, incr, or wrap
        -- fixed accesses the same address repeatedly, incr increments the address for each transfer, wrap = incr except rolls over to lower address if upper limit is reached
        -- see table A3-3 for AxBURST encoding
        data_AWLOCK  : out std_logic_vector(1 downto 0); -- Ensures that only the master can access the targeted slave region
        data_AWCACHE : out std_logic_vector(3 downto 0); -- specifies memory type, see Table A4-5
        data_AWPROT  : out std_logic_vector(2 downto 0); -- specifies access permission, see Table A4-6
        data_AWVALID : out std_logic; -- Valid address and control information on bus, asserted until slave asserts AWREADY
        data_AWREADY : in std_logic; -- Slave is ready to accept address and control signals

        -- Write data channel ------------------------------------------------------------
        data_WID     : out std_logic_vector(3 downto 0); -- ID for write data signals
        data_WDATA   : out std_logic_vector(REGISTER_SIZE -1 downto 0);
        data_WSTRB   : out std_logic_vector(REGISTER_SIZE/BYTE_SIZE -1 downto 0); -- Specifies which byte lanes contain valid information
        data_WLAST   : out std_logic; -- Asserted when master is driving the final write transfer in the burst
        data_WVALID  : out std_logic; -- Valid data available on bus, asserted until slave asserts WREADY
        data_WREADY  : in std_logic; -- Slave is now available to accept write data

        -- Write response channel ---------------------------------------------------------
        data_BID     : in std_logic_vector(3 downto 0); -- ID for write response
        data_BRESP   : in std_logic_vector(1 downto 0); -- Slave response (with error codes) to a write
        data_BVALID  : in std_logic; -- Indicates that the channel is signaling a valid write response
        data_BREADY  : out std_logic; -- Indicates that master has acknowledged write response

        -- Read address channel ------------------------------------------------------------
        data_ARID    : out std_logic_vector(3 downto 0);
        data_ARADDR  : out std_logic_vector(REGISTER_SIZE -1 downto 0);
        data_ARLEN   : out std_logic_vector(3 downto 0);
        data_ARSIZE  : out std_logic_vector(2 downto 0);
        data_ARBURST : out std_logic_vector(1 downto 0);
        data_ARLOCK  : out std_logic_vector(1 downto 0);
        data_ARCACHE : out std_logic_vector(3 downto 0);
        data_ARPROT  : out std_logic_vector(2 downto 0);
        data_ARVALID : out std_logic;
        data_ARREADY : in std_logic;

        -- Read data channel -----------------------------------------------------------------
        data_RID     : in std_logic_vector(3 downto 0);
        data_RDATA   : in std_logic_vector(REGISTER_SIZE -1 downto 0);
        data_RRESP   : in std_logic_vector(1 downto 0);
        data_RLAST   : in std_logic;
        data_RVALID  : in std_logic;
        data_RREADY  : out std_logic;

        -- INSTRUCTION 
        -- state machine feeds into mux (include SEL)
        -- avalon feeds into mux
        -- mux feeds into RAM
        
        -- INSTRUCTION NVM INPUT
        -- feeds into state machine so init can access IRAM
        nvm_PADDR : in std_logic_vector(REGISTER_SIZE-1 downto 0);
        nvm_PENABLE : in std_logic;
        nvm_PWRITE : in std_logic;
        nvm_PRDATA : out std_logic_vector(REGISTER_SIZE-1 downto 0);
        nvm_PWDATA : in std_logic_vector(REGISTER_SIZE-1 downto 0);
        nvm_PREADY : out std_logic;
        nvm_PSEL : in std_logic
      );

end entity riscV_axi;

architecture rtl of riscV_axi is

  signal orca_reset             : std_logic;

  signal avm_data_address       : std_logic_vector(REGISTER_SIZE-1 downto 0);
  signal avm_data_byteenable    : std_logic_vector(REGISTER_SIZE/BYTE_SIZE -1 downto 0);
  signal avm_data_read          : std_logic;
  signal avm_data_readdata      : std_logic_vector(REGISTER_SIZE-1 downto 0);
  signal avm_data_response      : std_logic_vector(1 downto 0);
  signal avm_data_write         : std_logic;
  signal avm_data_writedata     : std_logic_vector(REGISTER_SIZE-1 downto 0);
  signal avm_data_lock          : std_logic;
  signal avm_data_waitrequest   : std_logic;
  signal avm_data_readdatavalid : std_logic;

  signal axi_data_address       : std_logic_vector(REGISTER_SIZE-1 downto 0);
  signal axi_data_byteenable    : std_logic_vector(REGISTER_SIZE/BYTE_SIZE -1 downto 0);
  signal axi_data_read          : std_logic;
  signal axi_data_readdata      : std_logic_vector(REGISTER_SIZE-1 downto 0);
  signal axi_data_response      : std_logic_vector(1 downto 0);
  signal axi_data_write         : std_logic;
  signal axi_data_writedata     : std_logic_vector(REGISTER_SIZE-1 downto 0);
  signal axi_data_lock          : std_logic;
  signal axi_data_waitrequest   : std_logic;
  signal axi_data_readdatavalid : std_logic;

  signal avm_instruction_address       : std_logic_vector(REGISTER_SIZE-1 downto 0);
  signal avm_instruction_byteenable    : std_logic_vector(REGISTER_SIZE/BYTE_SIZE -1 downto 0);
  signal avm_instruction_read          : std_logic;
  signal avm_instruction_readdata      : std_logic_vector(REGISTER_SIZE-1 downto 0);
  signal avm_instruction_response      : std_logic_vector(1 downto 0);
  signal avm_instruction_write         : std_logic;
  signal avm_instruction_writedata     : std_logic_vector(REGISTER_SIZE-1 downto 0);
  signal avm_instruction_lock          : std_logic;
  signal avm_instruction_waitrequest   : std_logic;
  signal avm_instruction_readdatavalid : std_logic;

  signal user_instruction_address       : std_logic_vector(REGISTER_SIZE-1 downto 0);
  signal user_instruction_byteenable    : std_logic_vector(REGISTER_SIZE/BYTE_SIZE -1 downto 0);
  signal user_instruction_read          : std_logic;
  signal user_instruction_readdata      : std_logic_vector(REGISTER_SIZE-1 downto 0);
  signal user_instruction_response      : std_logic_vector(1 downto 0);
  signal user_instruction_write         : std_logic;
  signal user_instruction_writedata     : std_logic_vector(REGISTER_SIZE-1 downto 0);
  signal user_instruction_lock          : std_logic;
  signal user_instruction_waitrequest   : std_logic;
  signal user_instruction_readdatavalid : std_logic;
  
  signal instr_readvalid_mask : std_logic;
  signal instr_readdatavalid  : std_logic;
  signal instr_saved_data     : std_logic_vector(REGISTER_SIZE-1 downto 0);
  signal instr_was_waiting    : std_logic;
  signal instr_delayed_valid  : std_logic;
  signal instr_suppress_valid : std_logic;
 
  -- APB bus
  signal nvm_addr : std_logic_vector(REGISTER_SIZE-1 downto 0);
  signal nvm_wdata : std_logic_vector(REGISTER_SIZE-1 downto 0);
  signal nvm_wen : std_logic;
  signal nvm_byte_sel : std_logic_vector(REGISTER_SIZE/8 -1 downto 0);
  signal nvm_strb : std_logic;
  signal nvm_ack : std_logic;
  signal nvm_rdata : std_logic_vector(REGISTER_SIZE-1 downto 0);
  
  -- INSTR MUX
  signal SEL : std_logic;
  signal ram_addr : std_logic_vector(REGISTER_SIZE-1 downto 0);
  signal ram_wdata : std_logic_vector(REGISTER_SIZE-1 downto 0);
  signal ram_wen : std_logic;
  signal ram_byte_sel : std_logic_vector(REGISTER_SIZE/BYTE_SIZE -1 downto 0);
  signal ram_strb : std_logic;
  signal ram_ack : std_logic;
  signal ram_rdata : std_logic_vector(REGISTER_SIZE-1 downto 0);
  signal data_ram_addr : std_logic_vector(REGISTER_SIZE-1 downto 0);
  signal data_ram_wdata : std_logic_vector(REGISTER_SIZE-1 downto 0);
  signal data_ram_wen : std_logic;
  signal data_ram_byte_sel : std_logic_vector(REGISTER_SIZE/BYTE_SIZE -1 downto 0);
  signal data_ram_strb : std_logic;
  signal data_ram_ack : std_logic;
  signal data_ram_rdata : std_logic_vector(REGISTER_SIZE-1 downto 0);



  -- AXI Bus signals 
  signal ARESETN : std_logic;
  signal data_sel : std_logic;
  signal data_sel_prev : std_logic;

  constant BURST_LEN    : std_logic_vector(3 downto 0) := "0001";
  constant BURST_SIZE   : std_logic_vector(2 downto 0) := "010";
  constant BURST_FIXED  : std_logic_vector(1 downto 0) := "00";
  constant DATA_ACCESS  : std_logic_vector(2 downto 0) := "001";
  constant INSTR_ACCESS : std_logic_vector(2 downto 0) := "101"; 
  constant NORMAL_MEM   : std_logic_vector(3 downto 0) := "0011";

begin

  ARESETN <= not reset;

  rv : entity work.orca(rtl)
    generic map (
      REGISTER_SIZE      => REGISTER_SIZE,
      RESET_VECTOR       => RESET_VECTOR,
      MULTIPLY_ENABLE    => MULTIPLY_ENABLE,
      DIVIDE_ENABLE      => DIVIDE_ENABLE,
      SHIFTER_MAX_CYCLES => SHIFTER_MAX_CYCLES,
      COUNTER_LENGTH     => COUNTER_LENGTH,
      BRANCH_PREDICTORS  => BRANCH_PREDICTORS,
      PIPELINE_STAGES    => PIPELINE_STAGES,
      FORWARD_ALU_ONLY   => FORWARD_ALU_ONLY)
    port map (
      clk => clk,
      reset => orca_reset, -- while the iram is being initialized, don't start

      --conduit end point
      coe_to_host         => coe_to_host,
      coe_from_host       => coe_from_host,
      coe_program_counter => coe_program_counter,

      --avalon master bus
      avm_data_address       => avm_data_address,
      avm_data_byteenable    => avm_data_byteenable,
      avm_data_read          => avm_data_read,
      avm_data_readdata      => avm_data_readdata,
      avm_data_response      => avm_data_response,
      avm_data_write         => avm_data_write,
      avm_data_writedata     => avm_data_writedata,
      avm_data_lock          => avm_data_lock,
      avm_data_waitrequest   => avm_data_waitrequest,
      avm_data_readdatavalid => avm_data_readdatavalid,

      --avalon master bus                     --avalon master bus
      avm_instruction_address       => avm_instruction_address,
      avm_instruction_byteenable    => avm_instruction_byteenable,
      avm_instruction_read          => avm_instruction_read,
      avm_instruction_readdata      => avm_instruction_readdata,
      avm_instruction_response      => avm_instruction_response,
      avm_instruction_write         => avm_instruction_write,
      avm_instruction_writedata     => avm_instruction_writedata,
      avm_instruction_lock          => avm_instruction_lock,
      avm_instruction_waitrequest   => avm_instruction_waitrequest,
      avm_instruction_readdatavalid => avm_instruction_readdatavalid
      );

  mux : entity work.ram_mux(rtl)
    generic map (
      DATA_WIDTH => REGISTER_SIZE,
      ADDR_WIDTH => REGISTER_SIZE
    )
    port map (
      nvm_addr => nvm_addr,
      nvm_wdata => nvm_wdata,
      nvm_wen => nvm_wen,
      nvm_byte_sel => nvm_byte_sel,
      nvm_strb => nvm_strb,
      nvm_ack => nvm_ack,
      nvm_rdata => nvm_rdata,
      user_instruction_address       => user_instruction_address,
      user_instruction_byteenable    => user_instruction_byteenable,
      user_instruction_read          => user_instruction_read,
      user_instruction_readdata      => user_instruction_readdata,
      user_instruction_response      => user_instruction_response,
      user_instruction_write         => user_instruction_write,
      user_instruction_writedata     => user_instruction_writedata,
      user_instruction_lock          => user_instruction_lock,
      user_instruction_waitrequest   => user_instruction_waitrequest,
      user_instruction_readdatavalid => user_instruction_readdatavalid,
      SEL => SEL,
      ram_addr => ram_addr,
      ram_wdata => ram_wdata, 
      ram_wen => ram_wen,
      ram_byte_sel => ram_byte_sel,
      ram_strb => ram_strb,
      ram_ack => ram_ack,
      ram_rdata => ram_rdata
    );

  apb_bus : entity work.apb_to_ram(rtl)
    generic map (
      REGISTER_SIZE => REGISTER_SIZE,
      RAM_SIZE => IRAM_SIZE
    )
    port map (
      reset => reset,
      clk => clk,
      SEL => SEL,
      nvm_PADDR => nvm_PADDR,
      nvm_PENABLE => nvm_PENABLE,
      nvm_PWRITE => nvm_PWRITE,
      nvm_PRDATA => nvm_PRDATA,
      nvm_PWDATA => nvm_PWDATA,
      nvm_PREADY => nvm_PREADY,
      nvm_PSEL => nvm_PSEL,
      nvm_addr => nvm_addr,
      nvm_wdata => nvm_wdata,
      nvm_wen => nvm_wen,
      nvm_byte_sel => nvm_byte_sel,
      nvm_strb => nvm_strb,
      nvm_ack => nvm_ack,
      nvm_rdata => nvm_rdata
    );

  iram : entity work.iram(rtl)
    generic map (
      SIZE => IRAM_SIZE,
      RAM_WIDTH => REGISTER_SIZE,
      BYTE_SIZE => BYTE_SIZE 
    )
    port map (
      clk => clk,
      addr => ram_addr,
      wdata => ram_wdata,
      wen => ram_wen,
      byte_sel => ram_byte_sel,
      strb => ram_strb,
      ack => ram_ack,
      rdata => ram_rdata,
      data_addr =>     data_ram_addr,
      data_wdata =>    data_ram_wdata,
      data_wen =>      data_ram_wen,
      data_byte_sel => data_ram_byte_sel,
      data_strb =>     data_ram_strb,
      data_ack =>      data_ram_ack,
      data_rdata =>    data_ram_rdata
    );

  orca_reset <= reset or (not SEL);

  -- AXI3 Data Bus ----------------------------------------------------------------------

  -- Handle AXI handshake between master and data slave  
  --data_sel <= avm_data_address(REGISTER_SIZE-1 downto REGISTER_SIZE-4);
  data_sel <= '1' when unsigned(avm_data_address) >= IRAM_SIZE
         else '0';

  process(clk)
  begin
    if rising_edge(clk) then
      data_sel_prev <= data_sel;
    end if;
  end process;

  data_splitter : process (data_sel,
                          avm_data_address,
                          avm_data_byteenable,
                          avm_data_read,
                          avm_data_write,
                          avm_data_writedata,
                          avm_data_lock,
                          data_ram_rdata,
                          data_ram_ack,
                          axi_data_readdata,
                          axi_data_response,
                          axi_data_waitrequest,
                          axi_data_readdatavalid
                          )
  begin
    axi_data_address <= x"00000000";
    axi_data_byteenable <= x"0";
    axi_data_read <= '0';
    axi_data_write <= '0';
    axi_data_writedata <= (others => '0');
    axi_data_lock <= '0';
    data_ram_addr <= (others => '0');
    data_ram_wdata <= (others => '0');
    data_ram_wen <= '0';
    data_ram_byte_sel <= (others => '0');
    data_ram_strb <= '0';
    avm_data_readdata <= (others => '0');
    avm_data_response <= (others => '0');
    avm_data_waitrequest <= '0';
    avm_data_readdatavalid <= '0';

    case (data_sel) is
      when '0' =>
        data_ram_addr <= avm_data_address;
        data_ram_wdata <= avm_data_writedata;
        data_ram_wen <= avm_data_write and (not avm_data_read);
        data_ram_byte_sel <= avm_data_byteenable;
        data_ram_strb <= avm_data_write or avm_data_read;
        avm_data_waitrequest <= '0';
      when others =>
        axi_data_address <= avm_data_address;
        axi_data_byteenable <= avm_data_byteenable;
        axi_data_read <= avm_data_read;
        axi_data_write <= avm_data_write;
        axi_data_writedata <= avm_data_writedata;
        axi_data_lock <= avm_data_lock; 
        avm_data_waitrequest <= axi_data_waitrequest;
    end case;
    case (data_sel_prev) is
      when '0' =>
        avm_data_readdata <= data_ram_rdata;
        avm_data_response <= (others => '0');
        avm_data_readdatavalid <= data_ram_ack;
      when others =>
        avm_data_readdata <= axi_data_readdata;
        avm_data_response <= axi_data_response; 
        avm_data_readdatavalid <= axi_data_readdatavalid;
    end case;
  end process;

  data_bus : entity work.axi_master(rtl) 
    generic map (
      REGISTER_SIZE => REGISTER_SIZE,
      BYTE_SIZE => BYTE_SIZE
    )
    port map (
      ACLK => clk,
      ARESETN => ARESETN,
      
      avm_data_address => axi_data_address,
      avm_data_byteenable => axi_data_byteenable,
      avm_data_read => axi_data_read,
      avm_data_readdata => axi_data_readdata,
      avm_data_response => axi_data_response, 
      avm_data_write => axi_data_write,
      avm_data_writedata => axi_data_writedata,
      avm_data_lock => axi_data_lock,
      avm_data_waitrequest => axi_data_waitrequest,
      avm_data_readdatavalid => axi_data_readdatavalid,

      DATA_BURST_NUM => OPEN,
      NEXT_DATA_IN => OPEN,

      AWID => data_AWID, 
      AWADDR => data_AWADDR,
      AWLEN => data_AWLEN,
      AWSIZE => data_AWSIZE,
      AWLOCK =>  data_AWLOCK,
      AWBURST => data_AWBURST, 
      AWVALID =>   data_AWVALID, 
      AWREADY => data_AWREADY,
                            
      WID =>     data_WID,
      WSTRB =>   data_WSTRB, 
      WLAST =>   data_WLAST, 
      WVALID =>  data_WVALID,
      WDATA =>   data_WDATA, 
      WREADY =>  data_WREADY,
                 
      BID =>     data_BID,
      BRESP =>   data_BRESP, 
      BVALID =>  data_BVALID,
      BREADY =>  data_BREADY,
                            
      ARID =>    data_ARID,
      ARADDR =>  data_ARADDR,
      ARLEN =>   data_ARLEN, 
      ARSIZE =>  data_ARSIZE,
      ARLOCK =>  data_ARLOCK,
      ARBURST =>  data_ARBURST,
      ARVALID =>  data_ARVALID,
      ARREADY => data_ARREADY,
                            
      RID =>     data_RID,
      RDATA =>   data_RDATA, 
      RRESP =>   data_RRESP, 
      RLAST =>   data_RLAST, 
      RVALID =>  data_RVALID,
      RREADY =>  data_RREADY
    );
     
  -- Instruction Bus ---------------------------------------------------------------
  -- output
  user_instruction_address <= avm_instruction_address;
  user_instruction_writedata <= avm_instruction_writedata;
  user_instruction_write <= avm_instruction_write;
  user_instruction_byteenable <= avm_instruction_byteenable;
  user_instruction_write <= avm_instruction_write;
  user_instruction_read <= avm_instruction_read;
  -- input 
  avm_instruction_readdata      <= instr_saved_data when instr_delayed_valid = '1' else user_instruction_readdata;
  avm_instruction_waitrequest   <= user_instruction_waitrequest;
  instr_readdatavalid           <= user_instruction_readdatavalid and instr_readvalid_mask;
  avm_instruction_readdatavalid <= (instr_readdatavalid and not instr_suppress_valid) or instr_delayed_valid;

  process(clk)
  begin
    if rising_edge(clk) then
      if avm_instruction_read = '1' then
        instr_readvalid_mask <= '1';
      elsif avm_instruction_readdatavalid = '1' then
        instr_readvalid_mask <= '0';
      end if;
      if reset = '1' then
        instr_readvalid_mask <= '0';
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      instr_was_waiting   <= user_instruction_waitrequest;
      instr_delayed_valid <= instr_suppress_valid;
      instr_saved_data    <= user_instruction_readdata;
    end if;
  end process;

  instr_suppress_valid <= instr_was_waiting and instr_readdatavalid;

end architecture rtl;



