-- vectorblox_mxp.vhd
-- Copyright (C) 2015 VectorBlox Computing, Inc.
--
-- MXP with FSL or AXI4-Streaming or memory-mapped AXI4 instruction port,
-- AXI3/4 DMA interface, AXI4Lite Scratchpad interface.

-- synthesis library vbx_lib
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.util_pkg.all;
use work.isa_pkg.all;
use work.architecture_pkg.all;
use work.component_pkg.all;


entity vectorblox_mxp is
  generic (
    VECTOR_LANES      : integer                    := 1;
    SCRATCHPAD_KB     : integer                    := 8;
    BURSTLENGTH_BYTES : integer range 4 to 4096    := 32;
    MAX_MASKED_WAVES  : positive range 128 to 8192 := 128;
    MASK_PARTITIONS   : natural                    := 1;

    MIN_MULTIPLIER_HW : integer range 0 to 2 := 0;

    MULFXP_WORD_FRACTION_BITS : integer range 1 to 31 := 25;
    MULFXP_HALF_FRACTION_BITS : integer range 1 to 15 := 15;
    MULFXP_BYTE_FRACTION_BITS : integer range 1 to 7  := 4;


    C_S_AXI_ADDR_WIDTH : integer := 32;
    C_S_AXI_DATA_WIDTH : integer := 32;

    C_S_AXI_INSTR_ADDR_WIDTH : integer := 32;
    C_S_AXI_INSTR_DATA_WIDTH : integer := 32;
    C_S_AXI_INSTR_ID_WIDTH   : integer := 4;

    C_M_AXI_ADDR_WIDTH : integer := 32;
    C_M_AXI_DATA_WIDTH : integer := 32;

    -- 8 for AXI4, 4 for AXI3. Determines size of arlen/awlen ports on AXI master.
    C_M_AXI_LEN_WIDTH : integer              := 8;
    -- 0 = Direct FSL instruction port; 1 = AXI4-Streaming instruction port;
    -- 2 = AXI4 instruction port.
    C_INSTR_PORT_TYPE : integer range 0 to 2 := 1
    );
  port(

    core_clk    : in std_logic;
    core_clk_2x : in std_logic;

    aresetn : in std_logic;

    -- AXI4 Slave Instruction Port
    s_axi_instr_awaddr  : in  std_logic_vector(C_S_AXI_INSTR_ADDR_WIDTH-1 downto 0) := (others => '0');
    s_axi_instr_awvalid : in  std_logic                                             := '0';
    s_axi_instr_awready : out std_logic;
    s_axi_instr_awid    : in  std_logic_vector(C_S_AXI_INSTR_ID_WIDTH-1 downto 0)   := (others => '0');
    s_axi_instr_awlen   : in  std_logic_vector(7 downto 0)                          := (others => '0');
    s_axi_instr_awsize  : in  std_logic_vector(2 downto 0)                          := (others => '0');
    s_axi_instr_awburst : in  std_logic_vector(1 downto 0)                          := (others => '0');

    s_axi_instr_wdata  : in  std_logic_vector(C_S_AXI_INSTR_DATA_WIDTH-1 downto 0)     := (others => '0');
    s_axi_instr_wstrb  : in  std_logic_vector((C_S_AXI_INSTR_DATA_WIDTH/8)-1 downto 0) := (others => '0');
    s_axi_instr_wvalid : in  std_logic                                                 := '0';
    s_axi_instr_wlast  : in  std_logic                                                 := '0';
    s_axi_instr_wready : out std_logic;

    s_axi_instr_bready : in  std_logic := '0';
    s_axi_instr_bresp  : out std_logic_vector(1 downto 0);
    s_axi_instr_bvalid : out std_logic;
    s_axi_instr_bid    : out std_logic_vector(C_S_AXI_INSTR_ID_WIDTH-1 downto 0);

    s_axi_instr_araddr  : in  std_logic_vector(C_S_AXI_INSTR_ADDR_WIDTH-1 downto 0) := (others => '0');
    s_axi_instr_arvalid : in  std_logic                                             := '0';
    s_axi_instr_arready : out std_logic;
    s_axi_instr_arid    : in  std_logic_vector(C_S_AXI_INSTR_ID_WIDTH-1 downto 0)   := (others => '0');
    s_axi_instr_arlen   : in  std_logic_vector(7 downto 0)                          := (others => '0');
    s_axi_instr_arsize  : in  std_logic_vector(2 downto 0)                          := (others => '0');
    s_axi_instr_arburst : in  std_logic_vector(1 downto 0)                          := (others => '0');

    s_axi_instr_rready : in  std_logic := '0';
    s_axi_instr_rdata  : out std_logic_vector(C_S_AXI_INSTR_DATA_WIDTH-1 downto 0);
    s_axi_instr_rresp  : out std_logic_vector(1 downto 0);
    s_axi_instr_rvalid : out std_logic;
    s_axi_instr_rlast  : out std_logic;
    s_axi_instr_rid    : out std_logic_vector(C_S_AXI_INSTR_ID_WIDTH-1 downto 0);

    -- AXI3/4 Master
    m_axi_arready : in  std_logic;
    m_axi_arvalid : out std_logic;
    m_axi_araddr  : out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
    m_axi_arlen   : out std_logic_vector(C_M_AXI_LEN_WIDTH-1 downto 0);
    m_axi_arsize  : out std_logic_vector(2 downto 0);
    m_axi_arburst : out std_logic_vector(1 downto 0);
    m_axi_arprot  : out std_logic_vector(2 downto 0);
    m_axi_arcache : out std_logic_vector(3 downto 0);

    m_axi_rready : out std_logic;
    m_axi_rvalid : in  std_logic;
    m_axi_rdata  : in  std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
    m_axi_rresp  : in  std_logic_vector(1 downto 0);
    m_axi_rlast  : in  std_logic;

    m_axi_awready : in  std_logic;
    m_axi_awvalid : out std_logic;
    m_axi_awaddr  : out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
    m_axi_awlen   : out std_logic_vector(C_M_AXI_LEN_WIDTH-1 downto 0);
    m_axi_awsize  : out std_logic_vector(2 downto 0);
    m_axi_awburst : out std_logic_vector(1 downto 0);
    m_axi_awprot  : out std_logic_vector(2 downto 0);
    m_axi_awcache : out std_logic_vector(3 downto 0);

    m_axi_wready : in  std_logic;
    m_axi_wvalid : out std_logic;
    m_axi_wdata  : out std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
    m_axi_wstrb  : out std_logic_vector((C_M_AXI_DATA_WIDTH)/8 - 1 downto 0);
    m_axi_wlast  : out std_logic;

    m_axi_bready : out std_logic;
    m_axi_bvalid : in  std_logic;
    m_axi_bresp  : in  std_logic_vector(1 downto 0);

    -- AXI4-Lite Slave
    s_axi_awaddr  : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    s_axi_awvalid : in  std_logic;
    s_axi_awready : out std_logic;

    s_axi_wdata  : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    s_axi_wstrb  : in  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
    s_axi_wvalid : in  std_logic;
    s_axi_wready : out std_logic;

    s_axi_bready : in  std_logic;
    s_axi_bresp  : out std_logic_vector(1 downto 0);
    s_axi_bvalid : out std_logic;

    s_axi_araddr  : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    s_axi_arvalid : in  std_logic;
    s_axi_arready : out std_logic;

    s_axi_rready : in  std_logic;
    s_axi_rdata  : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    s_axi_rresp  : out std_logic_vector(1 downto 0);
    s_axi_rvalid : out std_logic
    );


end entity vectorblox_mxp;

architecture rtl of vectorblox_mxp is
  -- Derived constants
  constant ADDR_WIDTH             : integer       := log2(SCRATCHPAD_KB*1024);
  constant MEMORY_WIDTH_LANES     : integer       := C_M_AXI_DATA_WIDTH/32;
  constant MIN_MULTIPLIER_HW_ENUM : min_size_type := int_to_min_size_type(MIN_MULTIPLIER_HW);

  constant CFG_FAM : config_family_type := CFG_FAM_XILINX;

  signal scratch_port_a : std_logic_vector(scratchpad_control_in_length(VECTOR_LANES, ADDR_WIDTH)-1 downto 0);
  signal scratch_port_b : std_logic_vector(scratchpad_control_in_length(VECTOR_LANES, ADDR_WIDTH)-1 downto 0);
  signal scratch_port_c : std_logic_vector(scratchpad_control_in_length(VECTOR_LANES, ADDR_WIDTH)-1 downto 0);
  signal scratch_port_d : std_logic_vector(scratchpad_control_in_length(VECTOR_LANES, ADDR_WIDTH)-1 downto 0);

  signal readdata_a : scratchpad_data((VECTOR_LANES*4)-1 downto 0);
  signal readdata_b : scratchpad_data((VECTOR_LANES*4)-1 downto 0);
  signal readdata_c : scratchpad_data((VECTOR_LANES*4)-1 downto 0);
  signal readdata_d : scratchpad_data((VECTOR_LANES*4)-1 downto 0);

  signal request_in  : std_logic_vector(scratchpad_requests_in_length(VECTOR_LANES, ADDR_WIDTH)-1 downto 0);
  signal request_out : std_logic_vector(scratchpad_requests_out_length(VECTOR_LANES, ADDR_WIDTH)-1 downto 0);

  signal core_pipeline_empty : std_logic;
  signal dma_pipeline_empty  : std_logic;
  signal dma_instr_valid     : std_logic;
  signal dma_instruction     : instruction_type;
  signal dma_instr_read      : std_logic;
  signal dma_status          : std_logic_vector(dma_info_vector_length(ADDR_WIDTH)-1 downto 0);
  signal instr_fifo_read     : std_logic;
  signal instr_fifo_readdata : instruction_type;
  signal instr_fifo_empty    : std_logic;

  signal core_reset : std_logic;

  signal fsl_s_read_i   : std_logic;
  signal fsl_s_data_i   : std_logic_vector(0 to 31);
  signal fsl_s_exists_i : std_logic;

  signal fsl_m_write_i : std_logic;
  signal fsl_m_data_i  : std_logic_vector(0 to 31);
  signal fsl_m_full_i  : std_logic;

  signal dma_awlen : std_logic_vector(7 downto 0);
  signal dma_arlen : std_logic_vector(7 downto 0);

  signal mask_status_update  : std_logic;
  signal mask_length_nonzero : std_logic;

  signal vci_valid  : std_logic_vector(MAX_CUSTOM_INSTRUCTIONS-1 downto 0);
  signal vci_signed : std_logic;
  signal vci_opsize : std_logic_vector(1 downto 0);

  signal vci_vector_start : std_logic;
  signal vci_vector_end   : std_logic;
  signal vci_byte_valid   : std_logic_vector(VECTOR_LANES*4-1 downto 0);
  signal vci_dest_addr_in : std_logic_vector(31 downto 0);

  signal vci_data_a : std_logic_vector(VECTOR_LANES*32-1 downto 0);
  signal vci_flag_a : std_logic_vector(VECTOR_LANES*4-1 downto 0);
  signal vci_data_b : std_logic_vector(VECTOR_LANES*32-1 downto 0);
  signal vci_flag_b : std_logic_vector(VECTOR_LANES*4-1 downto 0);

  signal vci_port          : unsigned(log2(MAX_CUSTOM_INSTRUCTIONS)-1 downto 0);
  signal vci_data_out      : std_logic_vector(VECTOR_LANES*32-1 downto 0);
  signal vci_flag_out      : std_logic_vector(VECTOR_LANES*4-1 downto 0);
  signal vci_byteenable    : std_logic_vector(VECTOR_LANES*4-1 downto 0);
  signal vci_dest_addr_out : std_logic_vector(31 downto 0);

begin
  
  core_reset <= not aresetn;

  ---------------------------------------------------------------------------
  -- Memory-Mapped AXI4 Slave Instruction Port

  --m_axis_instr_tdata  <= (others => '0');
  --m_axis_instr_tlast  <= '0';
  --m_axis_instr_tvalid <= '0';
  --s_axis_instr_tready <= '0';

  --FSL_S_Data   <= (others => '0');
  --FSL_S_Exists <= '0';
  --FSL_M_Full   <= '0';
  axi_instr_slave_inst : axi_instr_slave
    generic map (
      C_S_AXI_DATA_WIDTH => C_S_AXI_INSTR_DATA_WIDTH,
      C_S_AXI_ADDR_WIDTH => C_S_AXI_INSTR_ADDR_WIDTH,
      C_S_AXI_ID_WIDTH   => C_S_AXI_INSTR_ID_WIDTH
      )
    port map (
      clk   => core_clk,
      reset => core_reset,

      s_axi_awaddr  => s_axi_instr_awaddr,
      s_axi_awvalid => s_axi_instr_awvalid,
      s_axi_awready => s_axi_instr_awready,
      s_axi_awid    => s_axi_instr_awid,
      s_axi_awlen   => s_axi_instr_awlen,
      s_axi_awsize  => s_axi_instr_awsize,
      s_axi_awburst => s_axi_instr_awburst,

      s_axi_wdata  => s_axi_instr_wdata,
      s_axi_wstrb  => s_axi_instr_wstrb,
      s_axi_wvalid => s_axi_instr_wvalid,
      s_axi_wlast  => s_axi_instr_wlast,
      s_axi_wready => s_axi_instr_wready,

      s_axi_bready => s_axi_instr_bready,
      s_axi_bresp  => s_axi_instr_bresp,
      s_axi_bvalid => s_axi_instr_bvalid,
      s_axi_bid    => s_axi_instr_bid,

      s_axi_araddr  => s_axi_instr_araddr,
      s_axi_arvalid => s_axi_instr_arvalid,
      s_axi_arready => s_axi_instr_arready,
      s_axi_arid    => s_axi_instr_arid,
      s_axi_arlen   => s_axi_instr_arlen,
      s_axi_arsize  => s_axi_instr_arsize,
      s_axi_arburst => s_axi_instr_arburst,

      s_axi_rready => s_axi_instr_rready,
      s_axi_rdata  => s_axi_instr_rdata,
      s_axi_rresp  => s_axi_instr_rresp,
      s_axi_rvalid => s_axi_instr_rvalid,
      s_axi_rlast  => s_axi_instr_rlast,
      s_axi_rid    => s_axi_instr_rid,

      fsl_s_read   => fsl_s_read_i,
      fsl_s_data   => fsl_s_data_i,
      fsl_s_exists => fsl_s_exists_i,

      fsl_m_write => fsl_m_write_i,
      fsl_m_data  => fsl_m_data_i,
      fsl_m_full  => fsl_m_full_i
      );

  fsl_handler_inst : fsl_handler
    generic map (
      CFG_FAM           => CFG_FAM,
      MIN_MULTIPLIER_HW => MIN_MULTIPLIER_HW_ENUM,
      ADDR_WIDTH        => ADDR_WIDTH
      )
    port map (
      FSL_Clk => core_clk,

      FSL_S_Read   => fsl_s_read_i,
      FSL_S_Data   => fsl_s_data_i,
      FSL_S_Exists => fsl_s_exists_i,

      FSL_M_Write => fsl_m_write_i,
      FSL_M_Data  => fsl_m_data_i,
      FSL_M_Full  => fsl_m_full_i,

      core_pipeline_empty => core_pipeline_empty,
      dma_pipeline_empty  => dma_pipeline_empty,

      instr_fifo_read     => instr_fifo_read,
      instr_fifo_readdata => instr_fifo_readdata,
      instr_fifo_empty    => instr_fifo_empty,

      mask_status_update  => mask_status_update,
      mask_length_nonzero => mask_length_nonzero,

      clk   => core_clk,
      reset => core_reset
      );



  -- Vector scratchpad
  scratchpad_memory : scratchpad
    generic map (
      VECTOR_LANES  => VECTOR_LANES,
      SCRATCHPAD_KB => SCRATCHPAD_KB,

      CFG_FAM => CFG_FAM,

      ADDR_WIDTH => ADDR_WIDTH
      )
    port map (
      clk    => core_clk,
      reset  => core_reset,
      clk_2x => core_clk_2x,

      scratch_port_a => scratch_port_a,
      scratch_port_b => scratch_port_b,
      scratch_port_c => scratch_port_c,
      scratch_port_d => scratch_port_d,

      readdata_a => readdata_a,
      readdata_b => readdata_b,
      readdata_c => readdata_c,
      readdata_d => readdata_d
      );

  arbiter : scratchpad_arbiter
    generic map (
      VECTOR_LANES => VECTOR_LANES,

      CFG_FAM => CFG_FAM,

      ADDR_WIDTH => ADDR_WIDTH
      )
    port map (
      clk   => core_clk,
      reset => core_reset,

      request_in  => request_in,
      request_out => request_out,

      scratch_port_d => scratch_port_d,
      readdata_d     => readdata_d
      );

  dma_master : dma_controller_axi
    generic map (
      VECTOR_LANES       => VECTOR_LANES,
      MEMORY_WIDTH_LANES => MEMORY_WIDTH_LANES,
      BURSTLENGTH_BYTES  => BURSTLENGTH_BYTES,

      ADDR_WIDTH => ADDR_WIDTH,

      C_M_AXI_ADDR_WIDTH => C_M_AXI_ADDR_WIDTH
      )
    port map (
      clk   => core_clk,
      reset => core_reset,

      dma_instr_valid    => dma_instr_valid,
      dma_instruction    => dma_instruction,
      dma_instr_read     => dma_instr_read,
      dma_status         => dma_status,
      dma_pipeline_empty => dma_pipeline_empty,

      dma_request_out => request_out(((DMA_REQUESTOR+1)*scratchpad_request_out_length(VECTOR_LANES, ADDR_WIDTH))-1 downto
                                     (DMA_REQUESTOR*scratchpad_request_out_length(VECTOR_LANES, ADDR_WIDTH))),
      dma_request_in  => request_in(((DMA_REQUESTOR+1)*scratchpad_request_in_length(VECTOR_LANES, ADDR_WIDTH))-1 downto
                                    (DMA_REQUESTOR*scratchpad_request_in_length(VECTOR_LANES, ADDR_WIDTH))),

      m_axi_arready => m_axi_arready,
      m_axi_arvalid => m_axi_arvalid,
      m_axi_araddr  => m_axi_araddr,
      m_axi_arlen   => dma_arlen,
      m_axi_arsize  => m_axi_arsize,
      m_axi_arburst => m_axi_arburst,
      m_axi_arprot  => m_axi_arprot,
      m_axi_arcache => m_axi_arcache,

      m_axi_rready => m_axi_rready,
      m_axi_rvalid => m_axi_rvalid,
      m_axi_rdata  => m_axi_rdata,
      m_axi_rresp  => m_axi_rresp,
      m_axi_rlast  => m_axi_rlast,

      m_axi_awready => m_axi_awready,
      m_axi_awvalid => m_axi_awvalid,
      m_axi_awaddr  => m_axi_awaddr,
      m_axi_awlen   => dma_awlen,
      m_axi_awsize  => m_axi_awsize,
      m_axi_awburst => m_axi_awburst,
      m_axi_awprot  => m_axi_awprot,
      m_axi_awcache => m_axi_awcache,

      m_axi_wready => m_axi_wready,
      m_axi_wvalid => m_axi_wvalid,
      m_axi_wdata  => m_axi_wdata,
      m_axi_wstrb  => m_axi_wstrb,
      m_axi_wlast  => m_axi_wlast,

      m_axi_bready => m_axi_bready,
      m_axi_bvalid => m_axi_bvalid,
      m_axi_bresp  => m_axi_bresp

      );

  m_axi_arlen <= dma_arlen(m_axi_arlen'range);
  m_axi_awlen <= dma_awlen(m_axi_awlen'range);

  slave_controller : axi4lite_sp_slave
    generic map (
      VECTOR_LANES => VECTOR_LANES,

      ADDR_WIDTH => ADDR_WIDTH,

      EXT_ALIGN => true,                -- alignment done in scratchpad_arbiter

      C_S_AXI_DATA_WIDTH => C_S_AXI_DATA_WIDTH,
      C_S_AXI_ADDR_WIDTH => C_S_AXI_ADDR_WIDTH
      )
    port map (
      clk   => core_clk,
      reset => core_reset,

      S_AXI_AWADDR  => s_axi_awaddr,
      S_AXI_AWVALID => s_axi_awvalid,
      S_AXI_AWREADY => s_axi_awready,

      S_AXI_WDATA  => s_axi_wdata,
      S_AXI_WSTRB  => s_axi_wstrb,
      S_AXI_WVALID => s_axi_wvalid,
      S_AXI_WREADY => s_axi_wready,

      S_AXI_BREADY => s_axi_bready,
      s_AXI_BRESP  => s_axi_bresp,
      S_AXI_BVALID => s_axi_bvalid,

      S_AXI_ARADDR  => s_axi_araddr,
      S_AXI_ARVALID => s_axi_arvalid,
      S_AXI_ARREADY => s_axi_arready,

      S_AXI_RREADY => s_axi_rready,
      S_AXI_RDATA  => s_axi_rdata,
      S_AXI_RRESP  => s_axi_rresp,
      S_AXI_RVALID => s_axi_rvalid,

      slave_request_out => request_out(((SLAVE_REQUESTOR+1)*scratchpad_request_out_length(VECTOR_LANES, ADDR_WIDTH))-1 downto
                                       (SLAVE_REQUESTOR*scratchpad_request_out_length(VECTOR_LANES, ADDR_WIDTH))),
      slave_request_in  => request_in(((SLAVE_REQUESTOR+1)*scratchpad_request_in_length(VECTOR_LANES, ADDR_WIDTH))-1 downto
                                      (SLAVE_REQUESTOR*scratchpad_request_in_length(VECTOR_LANES, ADDR_WIDTH)))

      );

  core : vblox1_core
    generic map (
      VECTOR_LANES => VECTOR_LANES,

      --VECTOR_CUSTOM_INSTRUCTIONS => VECTOR_CUSTOM_INSTRUCTIONS,
      --VCI_CONFIGS                => VCI_CONFIGS,
      --VCI_DEPTHS                 => VCI_DEPTHS,

      MAX_MASKED_WAVES => MAX_MASKED_WAVES,
      MASK_PARTITIONS  => MASK_PARTITIONS,

      MIN_MULTIPLIER_HW => MIN_MULTIPLIER_HW_ENUM,

      MULFXP_WORD_FRACTION_BITS => MULFXP_WORD_FRACTION_BITS,
      MULFXP_HALF_FRACTION_BITS => MULFXP_HALF_FRACTION_BITS,
      MULFXP_BYTE_FRACTION_BITS => MULFXP_BYTE_FRACTION_BITS,

      CFG_FAM => CFG_FAM,

      ADDR_WIDTH => ADDR_WIDTH
      )
    port map (
      clk    => core_clk,
      reset  => core_reset,
      clk_2x => core_clk_2x,

      core_pipeline_empty => core_pipeline_empty,

      dma_instr_valid => dma_instr_valid,
      dma_instruction => dma_instruction,
      dma_instr_read  => dma_instr_read,
      dma_status      => dma_status,

      scratch_port_a => scratch_port_a,
      scratch_port_b => scratch_port_b,
      scratch_port_c => scratch_port_c,

      readdata_a => readdata_a,
      readdata_b => readdata_b,

      instr_fifo_empty    => instr_fifo_empty,
      instr_fifo_readdata => instr_fifo_readdata,
      instr_fifo_read     => instr_fifo_read,

      mask_status_update  => mask_status_update,
      mask_length_nonzero => mask_length_nonzero,

      vci_valid  => vci_valid,
      vci_signed => vci_signed,
      vci_opsize => vci_opsize,

      vci_vector_start => vci_vector_start,
      vci_vector_end   => vci_vector_end,
      vci_byte_valid   => vci_byte_valid,
      vci_dest_addr_in => vci_dest_addr_in,

      vci_data_a => vci_data_a,
      vci_flag_a => vci_flag_a,
      vci_data_b => vci_data_b,
      vci_flag_b => vci_flag_b,

      vci_port          => vci_port,
      vci_data_out      => vci_data_out,
      vci_flag_out      => vci_flag_out,
      vci_byteenable    => vci_byteenable,
      vci_dest_addr_out => vci_dest_addr_out
      );



-- ASSERTIONS to make sure CONSTANTS are valid --
  assert log2(VECTOR_LANES) = log2_f(VECTOR_LANES)
    and VECTOR_LANES >= 1
    report "VECTOR_LANES ("
    & integer'image(VECTOR_LANES) &
    ") out of range.  Must be a positive power of 2"
    severity failure;

  assert VECTOR_LANES >= MEMORY_WIDTH_LANES
    and MEMORY_WIDTH_LANES >= 1
    and log2(MEMORY_WIDTH_LANES) = log2_f(MEMORY_WIDTH_LANES)
    report "MEMORY_WIDTH_LANES ("
    & integer'image(MEMORY_WIDTH_LANES) &
    ") out of range.  Valid range is 1 to VECTOR_LANES ("
    & integer'image(VECTOR_LANES) &
    ") in powers of 2."
    severity failure;

  assert BURSTLENGTH_BYTES >= 4*MEMORY_WIDTH_LANES
    report "BURSTLENGTH_BYTES ("
    & integer'image(BURSTLENGTH_BYTES) &
    ") is less than the memory width (4*MEMORY_WIDTH_LANES="
    & integer'image(4*MEMORY_WIDTH_LANES) &
    ").  Bursts will be set to single word."
    severity warning;

  assert log2(SCRATCHPAD_KB) = log2_f(SCRATCHPAD_KB)
    report "SCRATCHPAD_KB ("
    & integer'image(SCRATCHPAD_KB) &
    ") is not a power of 2.  Scratchpad memory may not map efficiently to FPGA BRAMs."
    severity warning;

  --vci_opcode_assert_outer_gen : for gvci_a in VECTOR_CUSTOM_INSTRUCTIONS-1 downto 0 generate
  --  assert VECTOR_LANES >= VCI_CONFIGS(gvci_a).LANES
  --    report "Invalid configuration for VCI " & natural'image(gvci_a) &
  --    ".  VCI_" & natural'image(gvci_a) &
  --    "_LANES (" & positive'image(VCI_CONFIGS(gvci_a).LANES) &
  --    ") is greater than VECTOR_LANES (" & positive'image(VECTOR_LANES) &
  --    ")."
  --    severity failure;

  --  assert VCI_CONFIGS(gvci_a).OPCODE_END >= VCI_CONFIGS(gvci_a).OPCODE_START
  --    report "Invalid configuration for VCI " & natural'image(gvci_a) &
  --    ".  Ending opcode (" & natural'image(VCI_CONFIGS(gvci_a).OPCODE_END) &
  --    ") is less than starting opcode (" & natural'image(VCI_CONFIGS(gvci_a).OPCODE_START) &
  --    ")."
  --    severity failure;

  --  vci_opcode_assert_inner_gen : for gvci_b in VECTOR_CUSTOM_INSTRUCTIONS-1 downto 0 generate
  --    assert (gvci_a = gvci_b or
  --            VCI_CONFIGS(gvci_a).OPCODE_START > VCI_CONFIGS(gvci_b).OPCODE_END or
  --            VCI_CONFIGS(gvci_b).OPCODE_START > VCI_CONFIGS(gvci_a).OPCODE_END)
  --      report "Opcodes for VCIs " & natural'image(gvci_a) &
  --      " (" & natural'image(VCI_CONFIGS(gvci_a).OPCODE_START) &
  --      " to " & natural'image(VCI_CONFIGS(gvci_a).OPCODE_END) &
  --      ") and " & natural'image(gvci_b) &
  --      " (" & natural'image(VCI_CONFIGS(gvci_b).OPCODE_START) &
  --      " to " & natural'image(VCI_CONFIGS(gvci_b).OPCODE_END) &
  --      ") overlap."
  --      severity failure;
  --  end generate vci_opcode_assert_inner_gen;
  --end generate vci_opcode_assert_outer_gen;

-- end ASSERTIONS --

end architecture rtl;
