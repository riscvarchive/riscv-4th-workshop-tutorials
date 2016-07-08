library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity axi_splitter is
  generic (
    REGISTER_SIZE : integer := 32;
    BYTE_SIZE : integer := 8
  );
  port (
    -- Master
    M_AWID     : in std_logic_vector(3 downto 0); 
    M_AWADDR   : in std_logic_vector(REGISTER_SIZE-1 downto 0);
    M_AWLEN    : in std_logic_vector(3 downto 0); 
    M_AWSIZE   : in std_logic_vector(2 downto 0);
    M_AWBURST  : in std_logic_vector(1 downto 0);
    M_AWLOCK   : in std_logic_vector(1 downto 0);
    M_AWVALID  : in std_logic;
    M_AWREADY  : out std_logic;

    M_WID      : in std_logic_vector(3 downto 0);
    M_WSTRB    : in std_logic_vector(REGISTER_SIZE/BYTE_SIZE -1 downto 0);
    M_WLAST    : in std_logic;
    M_WVALID   : in std_logic;
    M_WDATA    : in std_logic_vector(REGISTER_SIZE-1 downto 0);
    M_WREADY   : out std_logic;

    M_BID      : out std_logic_vector(3 downto 0);
    M_BRESP    : out std_logic_vector(1 downto 0);
    M_BVALID   : out std_logic;
    M_BREADY   : in std_logic;

    M_ARID     : in std_logic_vector(3 downto 0);
    M_ARADDR   : in std_logic_vector(REGISTER_SIZE-1 downto 0);
    M_ARLEN    : in std_logic_vector(3 downto 0);
    M_ARSIZE   : in std_logic_vector(2 downto 0);
    M_ARLOCK   : in std_logic_vector(1 downto 0);
    M_ARBURST  : in std_logic_vector(1 downto 0);
    M_ARVALID  : in std_logic;
    M_ARREADY  : out std_logic;

    M_RID      : out std_logic_vector(3 downto 0);
    M_RDATA    : out std_logic_vector(REGISTER_SIZE-1 downto 0);
    M_RRESP    : out std_logic_vector(1 downto 0);
    M_RLAST    : out std_logic;
    M_RVALID   : out std_logic;
    M_RREADY   : in std_logic;

    -- Slave 0 
    S0_AWID     : out std_logic_vector(3 downto 0); 
    S0_AWADDR   : out std_logic_vector(REGISTER_SIZE-1 downto 0);
    S0_AWLEN    : out std_logic_vector(3 downto 0); 
    S0_AWSIZE   : out std_logic_vector(2 downto 0);
    S0_AWBURST  : out std_logic_vector(1 downto 0);
    S0_AWLOCK   : out std_logic_vector(1 downto 0);
    S0_AWVALID  : out std_logic;
    S0_AWREADY  : in  std_logic;

    S0_WID      : out std_logic_vector(3 downto 0);
    S0_WSTRB    : out std_logic_vector(REGISTER_SIZE/BYTE_SIZE -1 downto 0);
    S0_WLAST    : out std_logic;
    S0_WVALID   : out std_logic;
    S0_WDATA    : out std_logic_vector(REGISTER_SIZE-1 downto 0);
    S0_WREADY   : in  std_logic;

    S0_BID      : in  std_logic_vector(3 downto 0);
    S0_BRESP    : in  std_logic_vector(1 downto 0);
    S0_BVALID   : in  std_logic;
    S0_BREADY   : out std_logic;

    S0_ARID     : out std_logic_vector(3 downto 0);
    S0_ARADDR   : out std_logic_vector(REGISTER_SIZE-1 downto 0);
    S0_ARLEN    : out std_logic_vector(3 downto 0);
    S0_ARSIZE   : out std_logic_vector(2 downto 0);
    S0_ARLOCK   : out std_logic_vector(1 downto 0);
    S0_ARBURST  : out std_logic_vector(1 downto 0);
    S0_ARVALID  : out std_logic;
    S0_ARREADY  : in  std_logic;

    S0_RID      : in  std_logic_vector(3 downto 0);
    S0_RDATA    : in  std_logic_vector(REGISTER_SIZE-1 downto 0);
    S0_RRESP    : in  std_logic_vector(1 downto 0);
    S0_RLAST    : in  std_logic;
    S0_RVALID   : in  std_logic;
    S0_RREADY   : out std_logic;

    -- Slave 1 
    S1_AWID     : out std_logic_vector(3 downto 0); 
    S1_AWADDR   : out std_logic_vector(REGISTER_SIZE-1 downto 0);
    S1_AWLEN    : out std_logic_vector(3 downto 0); 
    S1_AWSIZE   : out std_logic_vector(2 downto 0);
    S1_AWBURST  : out std_logic_vector(1 downto 0);
    S1_AWLOCK   : out std_logic_vector(1 downto 0);
    S1_AWVALID  : out std_logic;
    S1_AWREADY  : in  std_logic;

    S1_WID      : out std_logic_vector(3 downto 0);
    S1_WSTRB    : out std_logic_vector(REGISTER_SIZE/BYTE_SIZE -1 downto 0);
    S1_WLAST    : out std_logic;
    S1_WVALID   : out std_logic;
    S1_WDATA    : out std_logic_vector(REGISTER_SIZE-1 downto 0);
    S1_WREADY   : in  std_logic;

    S1_BID      : in  std_logic_vector(3 downto 0);
    S1_BRESP    : in  std_logic_vector(1 downto 0);
    S1_BVALID   : in  std_logic;
    S1_BREADY   : out std_logic;

    S1_ARID     : out std_logic_vector(3 downto 0);
    S1_ARADDR   : out std_logic_vector(REGISTER_SIZE-1 downto 0);
    S1_ARLEN    : out std_logic_vector(3 downto 0);
    S1_ARSIZE   : out std_logic_vector(2 downto 0);
    S1_ARLOCK   : out std_logic_vector(1 downto 0);
    S1_ARBURST  : out std_logic_vector(1 downto 0);
    S1_ARVALID  : out std_logic;
    S1_ARREADY  : in  std_logic;

    S1_RID      : in  std_logic_vector(3 downto 0);
    S1_RDATA    : in  std_logic_vector(REGISTER_SIZE-1 downto 0);
    S1_RRESP    : in  std_logic_vector(1 downto 0);
    S1_RLAST    : in  std_logic;
    S1_RVALID   : in  std_logic;
    S1_RREADY   : out std_logic;

    -- Slave 2 
    S2_AWID     : out std_logic_vector(3 downto 0); 
    S2_AWADDR   : out std_logic_vector(REGISTER_SIZE-1 downto 0);
    S2_AWLEN    : out std_logic_vector(3 downto 0); 
    S2_AWSIZE   : out std_logic_vector(2 downto 0);
    S2_AWBURST  : out std_logic_vector(1 downto 0);
    S2_AWLOCK   : out std_logic_vector(1 downto 0);
    S2_AWVALID  : out std_logic;
    S2_AWREADY  : in  std_logic;

    S2_WID      : out std_logic_vector(3 downto 0);
    S2_WSTRB    : out std_logic_vector(3 downto 0);
    S2_WLAST    : out std_logic;
    S2_WVALID   : out std_logic;
    S2_WDATA    : out std_logic_vector(REGISTER_SIZE-1 downto 0);
    S2_WREADY   : in  std_logic;

    S2_BID      : in  std_logic_vector(3 downto 0);
    S2_BRESP    : in  std_logic_vector(1 downto 0);
    S2_BVALID   : in  std_logic;
    S2_BREADY   : out std_logic;

    S2_ARID     : out std_logic_vector(3 downto 0);
    S2_ARADDR   : out std_logic_vector(REGISTER_SIZE-1 downto 0);
    S2_ARLEN    : out std_logic_vector(3 downto 0);
    S2_ARSIZE   : out std_logic_vector(2 downto 0);
    S2_ARLOCK   : out std_logic_vector(1 downto 0);
    S2_ARBURST  : out std_logic_vector(1 downto 0);
    S2_ARVALID  : out std_logic;
    S2_ARREADY  : in  std_logic;

    S2_RID      : in  std_logic_vector(3 downto 0);
    S2_RDATA    : in  std_logic_vector(REGISTER_SIZE-1 downto 0);
    S2_RRESP    : in  std_logic_vector(1 downto 0);
    S2_RLAST    : in  std_logic;
    S2_RVALID   : in  std_logic;
    S2_RREADY   : out std_logic;

    -- Slave 3 
    S3_AWID     : out std_logic_vector(3 downto 0); 
    S3_AWADDR   : out std_logic_vector(REGISTER_SIZE-1 downto 0);
    S3_AWLEN    : out std_logic_vector(3 downto 0); 
    S3_AWSIZE   : out std_logic_vector(2 downto 0);
    S3_AWBURST  : out std_logic_vector(1 downto 0);
    S3_AWLOCK   : out std_logic_vector(1 downto 0);
    S3_AWVALID  : out std_logic;
    S3_AWREADY  : in  std_logic;

    S3_WID      : out std_logic_vector(3 downto 0);
    S3_WSTRB    : out std_logic_vector(3 downto 0);
    S3_WLAST    : out std_logic;
    S3_WVALID   : out std_logic;
    S3_WDATA    : out std_logic_vector(REGISTER_SIZE-1 downto 0);
    S3_WREADY   : in  std_logic;

    S3_BID      : in  std_logic_vector(3 downto 0);
    S3_BRESP    : in  std_logic_vector(1 downto 0);
    S3_BVALID   : in  std_logic;
    S3_BREADY   : out std_logic;

    S3_ARID     : out std_logic_vector(3 downto 0);
    S3_ARADDR   : out std_logic_vector(REGISTER_SIZE-1 downto 0);
    S3_ARLEN    : out std_logic_vector(3 downto 0);
    S3_ARSIZE   : out std_logic_vector(2 downto 0);
    S3_ARLOCK   : out std_logic_vector(1 downto 0);
    S3_ARBURST  : out std_logic_vector(1 downto 0);
    S3_ARVALID  : out std_logic;
    S3_ARREADY  : in  std_logic;

    S3_RID      : in  std_logic_vector(3 downto 0);
    S3_RDATA    : in  std_logic_vector(REGISTER_SIZE-1 downto 0);
    S3_RRESP    : in  std_logic_vector(1 downto 0);
    S3_RLAST    : in  std_logic;
    S3_RVALID   : in  std_logic;
    S3_RREADY   : out std_logic;

    -- Slave 4 
    S4_AWID     : out std_logic_vector(3 downto 0); 
    S4_AWADDR   : out std_logic_vector(REGISTER_SIZE-1 downto 0);
    S4_AWLEN    : out std_logic_vector(3 downto 0); 
    S4_AWSIZE   : out std_logic_vector(2 downto 0);
    S4_AWBURST  : out std_logic_vector(1 downto 0);
    S4_AWLOCK   : out std_logic_vector(1 downto 0);
    S4_AWVALID  : out std_logic;
    S4_AWREADY  : in  std_logic;

    S4_WID      : out std_logic_vector(3 downto 0);
    S4_WSTRB    : out std_logic_vector(3 downto 0);
    S4_WLAST    : out std_logic;
    S4_WVALID   : out std_logic;
    S4_WDATA    : out std_logic_vector(REGISTER_SIZE-1 downto 0);
    S4_WREADY   : in  std_logic;

    S4_BID      : in  std_logic_vector(3 downto 0);
    S4_BRESP    : in  std_logic_vector(1 downto 0);
    S4_BVALID   : in  std_logic;
    S4_BREADY   : out std_logic;

    S4_ARID     : out std_logic_vector(3 downto 0);
    S4_ARADDR   : out std_logic_vector(REGISTER_SIZE-1 downto 0);
    S4_ARLEN    : out std_logic_vector(3 downto 0);
    S4_ARSIZE   : out std_logic_vector(2 downto 0);
    S4_ARLOCK   : out std_logic_vector(1 downto 0);
    S4_ARBURST  : out std_logic_vector(1 downto 0);
    S4_ARVALID  : out std_logic;
    S4_ARREADY  : in  std_logic;

    S4_RID      : in  std_logic_vector(3 downto 0);
    S4_RDATA    : in  std_logic_vector(REGISTER_SIZE-1 downto 0);
    S4_RRESP    : in  std_logic_vector(1 downto 0);
    S4_RLAST    : in  std_logic;
    S4_RVALID   : in  std_logic;
    S4_RREADY   : out std_logic;
    
    -- Slave 5 
    FLASH_AWID     : out std_logic_vector(3 downto 0); 
    FLASH_AWADDR   : out std_logic_vector(REGISTER_SIZE-1 downto 0);
    FLASH_AWLEN    : out std_logic_vector(3 downto 0); 
    FLASH_AWSIZE   : out std_logic_vector(2 downto 0);
    FLASH_AWBURST  : out std_logic_vector(1 downto 0);
    FLASH_AWLOCK   : out std_logic_vector(1 downto 0);
    FLASH_AWVALID  : out std_logic;
    FLASH_AWREADY  : in  std_logic;

    FLASH_WID      : out std_logic_vector(3 downto 0);
    FLASH_WSTRB    : out std_logic_vector(3 downto 0);
    FLASH_WLAST    : out std_logic;
    FLASH_WVALID   : out std_logic;
    FLASH_WDATA    : out std_logic_vector(REGISTER_SIZE-1 downto 0);
    FLASH_WREADY   : in  std_logic;

    FLASH_BID      : in  std_logic_vector(3 downto 0);
    FLASH_BRESP    : in  std_logic_vector(1 downto 0);
    FLASH_BVALID   : in  std_logic;
    FLASH_BREADY   : out std_logic;

    FLASH_ARID     : out std_logic_vector(3 downto 0);
    FLASH_ARADDR   : out std_logic_vector(REGISTER_SIZE-1 downto 0);
    FLASH_ARLEN    : out std_logic_vector(3 downto 0);
    FLASH_ARSIZE   : out std_logic_vector(2 downto 0);
    FLASH_ARLOCK   : out std_logic_vector(1 downto 0);
    FLASH_ARBURST  : out std_logic_vector(1 downto 0);
    FLASH_ARVALID  : out std_logic;
    FLASH_ARREADY  : in  std_logic;

    FLASH_RID      : in  std_logic_vector(3 downto 0);
    FLASH_RDATA    : in  std_logic_vector(REGISTER_SIZE-1 downto 0);
    FLASH_RRESP    : in  std_logic_vector(1 downto 0);
    FLASH_RLAST    : in  std_logic;
    FLASH_RVALID   : in  std_logic;
    FLASH_RREADY   : out std_logic;
    
    -- Slave 6 
    S5_AWID     : out std_logic_vector(3 downto 0); 
    S5_AWADDR   : out std_logic_vector(REGISTER_SIZE-1 downto 0);
    S5_AWLEN    : out std_logic_vector(3 downto 0); 
    S5_AWSIZE   : out std_logic_vector(2 downto 0);
    S5_AWBURST  : out std_logic_vector(1 downto 0);
    S5_AWLOCK   : out std_logic_vector(1 downto 0);
    S5_AWVALID  : out std_logic;
    S5_AWREADY  : in  std_logic;

    S5_WID      : out std_logic_vector(3 downto 0);
    S5_WSTRB    : out std_logic_vector(3 downto 0);
    S5_WLAST    : out std_logic;
    S5_WVALID   : out std_logic;
    S5_WDATA    : out std_logic_vector(REGISTER_SIZE-1 downto 0);
    S5_WREADY   : in  std_logic;

    S5_BID      : in  std_logic_vector(3 downto 0);
    S5_BRESP    : in  std_logic_vector(1 downto 0);
    S5_BVALID   : in  std_logic;
    S5_BREADY   : out std_logic;

    S5_ARID     : out std_logic_vector(3 downto 0);
    S5_ARADDR   : out std_logic_vector(REGISTER_SIZE-1 downto 0);
    S5_ARLEN    : out std_logic_vector(3 downto 0);
    S5_ARSIZE   : out std_logic_vector(2 downto 0);
    S5_ARLOCK   : out std_logic_vector(1 downto 0);
    S5_ARBURST  : out std_logic_vector(1 downto 0);
    S5_ARVALID  : out std_logic;
    S5_ARREADY  : in  std_logic;

    S5_RID      : in  std_logic_vector(3 downto 0);
    S5_RDATA    : in  std_logic_vector(REGISTER_SIZE-1 downto 0);
    S5_RRESP    : in  std_logic_vector(1 downto 0);
    S5_RLAST    : in  std_logic;
    S5_RVALID   : in  std_logic;
    S5_RREADY   : out std_logic
  );
end entity axi_splitter;
  
architecture rtl of axi_splitter is
  signal slave_select_w : std_logic_vector(3 downto 0);
  signal slave_select_r : std_logic_vector(3 downto 0);
begin

  slave_select_w <= M_AWADDR(REGISTER_SIZE-1 downto REGISTER_SIZE-4);
  slave_select_r <= M_ARADDR(REGISTER_SIZE-1 downto REGISTER_SIZE-4);

  process(
    M_AWID,
    M_AWADDR,
    M_AWLEN,
    M_AWSIZE,
    M_AWBURST,
    M_AWLOCK,
    M_AWVALID,
    M_WID,
    M_WSTRB,
    M_WLAST,
    M_WVALID,
    M_WDATA,
    M_BREADY,
    
    S0_AWREADY,           
    S0_WREADY,           
    S0_BID,
    S0_BRESP,
    S0_BVALID,

    S1_AWREADY,
    S1_WREADY,
    S1_BID,
    S1_BRESP,
    S1_BVALID,

    S2_AWREADY,
    S2_WREADY,
    S2_BID,
    S2_BRESP,
    S2_BVALID,
    
    S3_AWREADY,
    S3_WREADY,
    S3_BID,
    S3_BRESP,
    S3_BVALID,

    S4_AWREADY,
    S4_WREADY,
    S4_BID,
    S4_BRESP,
    S4_BVALID,

    S5_AWREADY,
    S5_WREADY,
    S5_BID,
    S5_BRESP,
    S5_BVALID,

    FLASH_AWREADY,
    FLASH_WREADY,
    FLASH_BID,
    FLASH_BRESP,
    FLASH_BVALID,
    
    slave_select_w
  )
  begin
    -- Slave 0
    S0_AWID    <= (others => '0');
    S0_AWADDR  <= (others => '0');
    S0_AWLEN   <= (others => '0');
    S0_AWSIZE  <= (others => '0');
    S0_AWBURST <= (others => '0');
    S0_AWLOCK  <= (others => '0');
    S0_AWVALID <= '0';
                  
    S0_WID     <= (others => '0');
    S0_WSTRB   <= (others => '0');
    S0_WLAST   <= '0';
    S0_WVALID  <= '0';
    S0_WDATA   <= (others => '0');
                  
    S0_BREADY  <= '0';
                  
    -- Slave 1
    S1_AWID    <= (others => '0');
    S1_AWADDR  <= (others => '0');
    S1_AWLEN   <= (others => '0');
    S1_AWSIZE  <= (others => '0');
    S1_AWBURST <= (others => '0');
    S1_AWLOCK  <= (others => '0');
    S1_AWVALID <= '0';
                  
    S1_WID     <= (others => '0');
    S1_WSTRB   <= (others => '0');
    S1_WLAST   <= '0';
    S1_WVALID  <= '0';
    S1_WDATA   <= (others => '0');
                  
    S1_BREADY  <= '0';
                  
    -- Slave 2
    S2_AWID    <= (others => '0');
    S2_AWADDR  <= (others => '0');
    S2_AWLEN   <= (others => '0');
    S2_AWSIZE  <= (others => '0');
    S2_AWBURST <= (others => '0');
    S2_AWLOCK  <= (others => '0');
    S2_AWVALID <= '0';
                  
    S2_WID     <= (others => '0');
    S2_WSTRB   <= (others => '0');
    S2_WLAST   <= '0';
    S2_WVALID  <= '0';
    S2_WDATA   <= (others => '0');
                  
    S2_BREADY  <= '0';
                  
    -- Slave 3
    S3_AWID    <= (others => '0');
    S3_AWADDR  <= (others => '0');
    S3_AWLEN   <= (others => '0');
    S3_AWSIZE  <= (others => '0');
    S3_AWBURST <= (others => '0');
    S3_AWLOCK  <= (others => '0');
    S3_AWVALID <= '0';
                  
    S3_WID     <= (others => '0');
    S3_WSTRB   <= (others => '0');
    S3_WLAST   <= '0';
    S3_WVALID  <= '0';
    S3_WDATA   <= (others => '0');
                  
    S3_BREADY  <= '0';
                  
    -- Slave 4
    S4_AWID    <= (others => '0');
    S4_AWADDR  <= (others => '0');
    S4_AWLEN   <= (others => '0');
    S4_AWSIZE  <= (others => '0');
    S4_AWBURST <= (others => '0');
    S4_AWLOCK  <= (others => '0');
    S4_AWVALID <= '0';
                  
    S4_WID     <= (others => '0');
    S4_WSTRB   <= (others => '0');
    S4_WLAST   <= '0';
    S4_WVALID  <= '0';
    S4_WDATA   <= (others => '0');
                  
    S4_BREADY  <= '0';

    -- Flash Slave 5
    FLASH_AWID    <= (others => '0');
    FLASH_AWADDR  <= (others => '0');
    FLASH_AWLEN   <= (others => '0');
    FLASH_AWSIZE  <= (others => '0');
    FLASH_AWBURST <= (others => '0');
    FLASH_AWLOCK  <= (others => '0');
    FLASH_AWVALID <= '0';
                  
    FLASH_WID     <= (others => '0');
    FLASH_WSTRB   <= (others => '0');
    FLASH_WLAST   <= '0';
    FLASH_WVALID  <= '0';
    FLASH_WDATA   <= (others => '0');
                  
    FLASH_BREADY  <= '0';
    
    -- Slave 6
    S5_AWID    <= (others => '0');
    S5_AWADDR  <= (others => '0');
    S5_AWLEN   <= (others => '0');
    S5_AWSIZE  <= (others => '0');
    S5_AWBURST <= (others => '0');
    S5_AWLOCK  <= (others => '0');
    S5_AWVALID <= '0';
                 
    S5_WID     <= (others => '0');
    S5_WSTRB   <= (others => '0');
    S5_WLAST   <= '0';
    S5_WVALID  <= '0';
    S5_WDATA   <= (others => '0');
                 
    S5_BREADY  <= '0';

    case slave_select_w is
      when X"1" =>
        S0_AWID    <= M_AWID;
        S0_AWADDR  <= M_AWADDR;
        S0_AWLEN   <= M_AWLEN;
        S0_AWSIZE  <= M_AWSIZE;
        S0_AWBURST <= M_AWBURST;
        S0_AWLOCK  <= M_AWLOCK;
        S0_AWVALID <= M_AWVALID;
        M_AWREADY   <= S0_AWREADY;
                             
        S0_WID     <= M_WID;
        S0_WSTRB   <= M_WSTRB;
        S0_WLAST   <= M_WLAST;
        S0_WVALID  <= M_WVALID;
        S0_WDATA   <= M_WDATA;
        M_WREADY    <= S0_WREADY;
                             
        M_BID       <= S0_BID;
        M_BRESP     <= S0_BRESP;
        M_BVALID    <= S0_BVALID;
        S0_BREADY  <= M_BREADY;
       
      when X"2" =>
        S1_AWID    <= M_AWID;
        S1_AWADDR  <= M_AWADDR;
        S1_AWLEN   <= M_AWLEN;
        S1_AWSIZE  <= M_AWSIZE;
        S1_AWBURST <= M_AWBURST;
        S1_AWLOCK  <= M_AWLOCK;
        S1_AWVALID <= M_AWVALID;
        M_AWREADY   <= S1_AWREADY;
                             
        S1_WID     <= M_WID;
        S1_WSTRB   <= M_WSTRB;
        S1_WLAST   <= M_WLAST;
        S1_WVALID  <= M_WVALID;
        S1_WDATA   <= M_WDATA;
        M_WREADY    <= S1_WREADY;
                             
        M_BID       <= S1_BID;
        M_BRESP     <= S1_BRESP;
        M_BVALID    <= S1_BVALID;
        S1_BREADY  <= M_BREADY;
                             
      when X"3" =>       
        S2_AWID    <= M_AWID;
        S2_AWADDR  <= M_AWADDR;
        S2_AWLEN   <= M_AWLEN;
        S2_AWSIZE  <= M_AWSIZE;
        S2_AWBURST <= M_AWBURST;
        S2_AWLOCK  <= M_AWLOCK;
        S2_AWVALID <= M_AWVALID;
        M_AWREADY   <= S2_AWREADY;
                             
        S2_WID     <= M_WID;
        S2_WSTRB   <= M_WSTRB;
        S2_WLAST   <= M_WLAST;
        S2_WVALID  <= M_WVALID;
        S2_WDATA   <= M_WDATA;
        M_WREADY    <= S2_WREADY;
                             
        M_BID       <= S2_BID;
        M_BRESP     <= S2_BRESP;
        M_BVALID    <= S2_BVALID;
        S2_BREADY  <= M_BREADY;
        
      when X"4" =>
        S3_AWID    <= M_AWID;
        S3_AWADDR  <= M_AWADDR;
        S3_AWLEN   <= M_AWLEN;
        S3_AWSIZE  <= M_AWSIZE;
        S3_AWBURST <= M_AWBURST;
        S3_AWLOCK  <= M_AWLOCK;
        S3_AWVALID <= M_AWVALID;
        M_AWREADY   <= S3_AWREADY;
                             
        S3_WID     <= M_WID;
        S3_WSTRB   <= M_WSTRB;
        S3_WLAST   <= M_WLAST;
        S3_WVALID  <= M_WVALID;
        S3_WDATA   <= M_WDATA;
        M_WREADY    <= S3_WREADY;
                             
        M_BID       <= S3_BID;
        M_BRESP     <= S3_BRESP;
        M_BVALID    <= S3_BVALID;
        S3_BREADY  <= M_BREADY;
                             
      when X"5" =>       
        S4_AWID    <= M_AWID;
        S4_AWADDR  <= M_AWADDR;
        S4_AWLEN   <= M_AWLEN;
        S4_AWSIZE  <= M_AWSIZE;
        S4_AWBURST <= M_AWBURST;
        S4_AWLOCK  <= M_AWLOCK;
        S4_AWVALID <= M_AWVALID;
        M_AWREADY   <= S4_AWREADY;
                             
        S4_WID     <= M_WID;
        S4_WSTRB   <= M_WSTRB;
        S4_WLAST   <= M_WLAST;
        S4_WVALID  <= M_WVALID;
        S4_WDATA   <= M_WDATA;
        M_WREADY    <= S4_WREADY;
                             
        M_BID       <= S4_BID;
        M_BRESP     <= S4_BRESP;
        M_BVALID    <= S4_BVALID;
        S4_BREADY  <= M_BREADY;
        
      when X"0" =>       
        FLASH_AWID    <= M_AWID;
        FLASH_AWADDR  <= M_AWADDR;
        FLASH_AWLEN   <= M_AWLEN;
        FLASH_AWSIZE  <= M_AWSIZE;
        FLASH_AWBURST <= M_AWBURST;
        FLASH_AWLOCK  <= M_AWLOCK;
        FLASH_AWVALID <= M_AWVALID;
        M_AWREADY   <= FLASH_AWREADY;
                             
        FLASH_WID     <= M_WID;
        FLASH_WSTRB   <= M_WSTRB;
        FLASH_WLAST   <= M_WLAST;
        FLASH_WVALID  <= M_WVALID;
        FLASH_WDATA   <= M_WDATA;
        M_WREADY    <= FLASH_WREADY;
                             
        M_BID       <= FLASH_BID;
        M_BRESP     <= FLASH_BRESP;
        M_BVALID    <= FLASH_BVALID;
        FLASH_BREADY  <= M_BREADY;
                             
      when X"6" =>       
        S5_AWID    <= M_AWID;
        S5_AWADDR  <= M_AWADDR;
        S5_AWLEN   <= M_AWLEN;
        S5_AWSIZE  <= M_AWSIZE;
        S5_AWBURST <= M_AWBURST;
        S5_AWLOCK  <= M_AWLOCK;
        S5_AWVALID <= M_AWVALID;
        M_AWREADY   <= S5_AWREADY;
                             
        S5_WID     <= M_WID;
        S5_WSTRB   <= M_WSTRB;
        S5_WLAST   <= M_WLAST;
        S5_WVALID  <= M_WVALID;
        S5_WDATA   <= M_WDATA;
        M_WREADY    <= S5_WREADY;
                             
        M_BID       <= S5_BID;
        M_BRESP     <= S5_BRESP;
        M_BVALID    <= S5_BVALID;
        S5_BREADY  <= M_BREADY;

      when others => 
    end case;
  end process;

  process(
    M_ARID,
    M_ARADDR,
    M_ARLEN,
    M_ARSIZE,
    M_ARLOCK,
    M_ARBURST,
    M_ARVALID,
    M_RREADY,

    S0_ARREADY,       
    S0_RID,
    S0_RDATA,
    S0_RRESP,
    S0_RLAST,
    S0_RVALID,

    S1_ARREADY,       
    S1_RID,
    S1_RDATA,
    S1_RRESP,
    S1_RLAST,
    S1_RVALID,

    S2_ARREADY,       
    S2_RID,
    S2_RDATA,
    S2_RRESP,
    S2_RLAST,
    S2_RVALID,

    S3_ARREADY,       
    S3_RID,
    S3_RDATA,
    S3_RRESP,
    S3_RLAST,
    S3_RVALID,

    S4_ARREADY,       
    S4_RID,
    S4_RDATA,
    S4_RRESP,
    S4_RLAST,
    S4_RVALID,

    FLASH_ARREADY,       
    FLASH_RID,
    FLASH_RDATA,
    FLASH_RRESP,
    FLASH_RLAST,
    FLASH_RVALID,

    S4_ARREADY,       
    S4_RID,
    S4_RDATA,
    S4_RRESP,
    S4_RLAST,
    S4_RVALID,

    slave_select_r
  ) 
  begin
    -- Slave 0
    S0_ARID    <= (others => '0');
    S0_ARADDR  <= (others => '0');
    S0_ARLEN   <= (others => '0');
    S0_ARSIZE  <= (others => '0');
    S0_ARLOCK  <= (others => '0');
    S0_ARBURST <= (others => '0');
    S0_ARVALID <= '0';
                  
    S0_RREADY  <= '0';

    -- Slave 1
    S1_ARID    <= (others => '0');
    S1_ARADDR  <= (others => '0');
    S1_ARLEN   <= (others => '0');
    S1_ARSIZE  <= (others => '0');
    S1_ARLOCK  <= (others => '0');
    S1_ARBURST <= (others => '0');
    S1_ARVALID <= '0';
                  
    S1_RREADY  <= '0';

    -- Slave 2
    S2_ARID    <= (others => '0');
    S2_ARADDR  <= (others => '0');
    S2_ARLEN   <= (others => '0');
    S2_ARSIZE  <= (others => '0');
    S2_ARLOCK  <= (others => '0');
    S2_ARBURST <= (others => '0');
    S2_ARVALID <= '0';
                  
    S2_RREADY  <= '0';

    -- Slave 3
    S3_ARID    <= (others => '0');
    S3_ARADDR  <= (others => '0');
    S3_ARLEN   <= (others => '0');
    S3_ARSIZE  <= (others => '0');
    S3_ARLOCK  <= (others => '0');
    S3_ARBURST <= (others => '0');
    S3_ARVALID <= '0';
                  
    S3_RREADY  <= '0';

    -- Slave 4
    S4_ARID    <= (others => '0');
    S4_ARADDR  <= (others => '0');
    S4_ARLEN   <= (others => '0');
    S4_ARSIZE  <= (others => '0');
    S4_ARLOCK  <= (others => '0');
    S4_ARBURST <= (others => '0');
    S4_ARVALID <= '0';
                  
    S4_RREADY  <= '0';

    -- Flash Slave
    FLASH_ARID    <= (others => '0');
    FLASH_ARADDR  <= (others => '0');
    FLASH_ARLEN   <= (others => '0');
    FLASH_ARSIZE  <= (others => '0');
    FLASH_ARLOCK  <= (others => '0');
    FLASH_ARBURST <= (others => '0');
    FLASH_ARVALID <= '0';
                  
    FLASH_RREADY  <= '0';

    -- Slave 5
    S5_ARID    <= (others => '0');
    S5_ARADDR  <= (others => '0');
    S5_ARLEN   <= (others => '0');
    S5_ARSIZE  <= (others => '0');
    S5_ARLOCK  <= (others => '0');
    S5_ARBURST <= (others => '0');
    S5_ARVALID <= '0';
                 
    S5_RREADY  <= '0';

    case slave_select_r is
      when X"1" =>
        S0_ARID    <= M_ARID;
        S0_ARADDR  <= M_ARADDR;
        S0_ARLEN   <= M_ARLEN;
        S0_ARSIZE  <= M_ARSIZE;
        S0_ARLOCK  <= M_ARLOCK;
        S0_ARBURST <= M_ARBURST;
        S0_ARVALID <= M_ARVALID;
        M_ARREADY   <= S0_ARREADY;
                             
        M_RID       <= S0_RID;
        M_RDATA     <= S0_RDATA;
        M_RRESP     <= S0_RRESP;
        M_RLAST     <= S0_RLAST;
        M_RVALID    <= S0_RVALID;
        S0_RREADY  <= M_RREADY;

      when X"2" =>
        S1_ARID    <= M_ARID;
        S1_ARADDR  <= M_ARADDR;
        S1_ARLEN   <= M_ARLEN;
        S1_ARSIZE  <= M_ARSIZE;
        S1_ARLOCK  <= M_ARLOCK;
        S1_ARBURST <= M_ARBURST;
        S1_ARVALID <= M_ARVALID;
        M_ARREADY   <= S1_ARREADY;
                             
        M_RID         <= S1_RID;
        M_RDATA       <= S1_RDATA;
        M_RRESP       <= S1_RRESP;
        M_RLAST       <= S1_RLAST;
        M_RVALID      <= S1_RVALID;
        S1_RREADY    <= M_RREADY;

      when X"3" =>
        S2_ARID    <= M_ARID;
        S2_ARADDR  <= M_ARADDR;
        S2_ARLEN   <= M_ARLEN;
        S2_ARSIZE  <= M_ARSIZE;
        S2_ARLOCK  <= M_ARLOCK;
        S2_ARBURST <= M_ARBURST;
        S2_ARVALID <= M_ARVALID;
        M_ARREADY   <= S2_ARREADY;
                             
        M_RID      <= S2_RID;
        M_RDATA    <= S2_RDATA;
        M_RRESP    <= S2_RRESP;
        M_RLAST    <= S2_RLAST;
        M_RVALID   <= S2_RVALID;
        S2_RREADY  <= M_RREADY;
        
      when X"4" =>
        S3_ARID    <= M_ARID;
        S3_ARADDR  <= M_ARADDR;
        S3_ARLEN   <= M_ARLEN;
        S3_ARSIZE  <= M_ARSIZE;
        S3_ARLOCK  <= M_ARLOCK;
        S3_ARBURST <= M_ARBURST;
        S3_ARVALID <= M_ARVALID;
        M_ARREADY   <= S3_ARREADY;
                             
        M_RID      <= S3_RID;
        M_RDATA    <= S3_RDATA;
        M_RRESP    <= S3_RRESP;
        M_RLAST    <= S3_RLAST;
        M_RVALID   <= S3_RVALID;
        S3_RREADY  <= M_RREADY;

      when X"5" =>
        S4_ARID    <= M_ARID;
        S4_ARADDR  <= M_ARADDR;
        S4_ARLEN   <= M_ARLEN;
        S4_ARSIZE  <= M_ARSIZE;
        S4_ARLOCK  <= M_ARLOCK;
        S4_ARBURST <= M_ARBURST;
        S4_ARVALID <= M_ARVALID;
        M_ARREADY  <= S4_ARREADY;
                             
        M_RID      <= S4_RID;
        M_RDATA    <= S4_RDATA;
        M_RRESP    <= S4_RRESP;
        M_RLAST    <= S4_RLAST;
        M_RVALID   <= S4_RVALID;
        S4_RREADY  <= M_RREADY;

      when X"0" =>
        FLASH_ARID    <= M_ARID;
        FLASH_ARADDR  <= M_ARADDR;
        FLASH_ARLEN   <= M_ARLEN;
        FLASH_ARSIZE  <= M_ARSIZE;
        FLASH_ARLOCK  <= M_ARLOCK;
        FLASH_ARBURST <= M_ARBURST;
        FLASH_ARVALID <= M_ARVALID;
        M_ARREADY  <= FLASH_ARREADY;
                             
        M_RID      <= FLASH_RID;
        M_RDATA    <= FLASH_RDATA;
        M_RRESP    <= FLASH_RRESP;
        M_RLAST    <= FLASH_RLAST;
        M_RVALID   <= FLASH_RVALID;
        FLASH_RREADY  <= M_RREADY;
        
      when X"6" =>
        S5_ARID    <= M_ARID;
        S5_ARADDR  <= M_ARADDR;
        S5_ARLEN   <= M_ARLEN;
        S5_ARSIZE  <= M_ARSIZE;
        S5_ARLOCK  <= M_ARLOCK;
        S5_ARBURST <= M_ARBURST;
        S5_ARVALID <= M_ARVALID;
        M_ARREADY  <= S5_ARREADY;
                             
        M_RID      <= S5_RID;
        M_RDATA    <= S5_RDATA;
        M_RRESP    <= S5_RRESP;
        M_RLAST    <= S5_RLAST;
        M_RVALID   <= S5_RVALID;
        S5_RREADY  <= M_RREADY;

      when others =>
    end case;
  end process;
end architecture rtl; 
