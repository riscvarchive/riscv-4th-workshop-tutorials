//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Mon May 30 11:34:42 2016
// Version: v11.7 11.7.0.119
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

// my_mss
module my_mss(
    // Inputs
    AMBA_MASTER_0_HADDR_M0,
    AMBA_MASTER_0_HBURST_M0,
    AMBA_MASTER_0_HMASTLOCK_M0,
    AMBA_MASTER_0_HPROT_M0,
    AMBA_MASTER_0_HSIZE_M0,
    AMBA_MASTER_0_HTRANS_M0,
    AMBA_MASTER_0_HWDATA_M0,
    AMBA_MASTER_0_HWRITE_M0,
    AMBA_SLAVE_0_PRDATAS0,
    AMBA_SLAVE_0_PREADYS0,
    AMBA_SLAVE_0_PSLVERRS0,
    DEVRST_N,
    FAB_RESET_N,
    M3_RESET_N,
    MMUART_0_RXD_F2M,
    // Outputs
    AMBA_MASTER_0_HRDATA_M0,
    AMBA_MASTER_0_HREADY_M0,
    AMBA_MASTER_0_HRESP_M0,
    AMBA_SLAVE_0_PADDRS,
    AMBA_SLAVE_0_PENABLES,
    AMBA_SLAVE_0_PSELS0,
    AMBA_SLAVE_0_PWDATAS,
    AMBA_SLAVE_0_PWRITES,
    FIC_0_CLK,
    FIC_0_LOCK,
    INIT_DONE,
    MMUART_0_TXD_M2F,
    MSS_READY,
    POWER_ON_RESET_N
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input  [31:0] AMBA_MASTER_0_HADDR_M0;
input  [2:0]  AMBA_MASTER_0_HBURST_M0;
input         AMBA_MASTER_0_HMASTLOCK_M0;
input  [3:0]  AMBA_MASTER_0_HPROT_M0;
input  [2:0]  AMBA_MASTER_0_HSIZE_M0;
input  [1:0]  AMBA_MASTER_0_HTRANS_M0;
input  [31:0] AMBA_MASTER_0_HWDATA_M0;
input         AMBA_MASTER_0_HWRITE_M0;
input  [31:0] AMBA_SLAVE_0_PRDATAS0;
input         AMBA_SLAVE_0_PREADYS0;
input         AMBA_SLAVE_0_PSLVERRS0;
input         DEVRST_N;
input         FAB_RESET_N;
input         M3_RESET_N;
input         MMUART_0_RXD_F2M;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output [31:0] AMBA_MASTER_0_HRDATA_M0;
output        AMBA_MASTER_0_HREADY_M0;
output [1:0]  AMBA_MASTER_0_HRESP_M0;
output [31:0] AMBA_SLAVE_0_PADDRS;
output        AMBA_SLAVE_0_PENABLES;
output        AMBA_SLAVE_0_PSELS0;
output [31:0] AMBA_SLAVE_0_PWDATAS;
output        AMBA_SLAVE_0_PWRITES;
output        FIC_0_CLK;
output        FIC_0_LOCK;
output        INIT_DONE;
output        MMUART_0_TXD_M2F;
output        MSS_READY;
output        POWER_ON_RESET_N;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire   [31:0] AMBA_MASTER_0_HADDR_M0;
wire   [2:0]  AMBA_MASTER_0_HBURST_M0;
wire          AMBA_MASTER_0_HMASTLOCK_M0;
wire   [3:0]  AMBA_MASTER_0_HPROT_M0;
wire   [31:0] AMBA_MASTER_0_HRDATA;
wire          AMBA_MASTER_0_HREADY;
wire   [1:0]  AMBA_MASTER_0_HRESP;
wire   [2:0]  AMBA_MASTER_0_HSIZE_M0;
wire   [1:0]  AMBA_MASTER_0_HTRANS_M0;
wire   [31:0] AMBA_MASTER_0_HWDATA_M0;
wire          AMBA_MASTER_0_HWRITE_M0;
wire   [31:0] APBmslave0_PADDR;
wire          APBmslave0_PENABLE;
wire   [31:0] AMBA_SLAVE_0_PRDATAS0;
wire          AMBA_SLAVE_0_PREADYS0;
wire          APBmslave0_PSELx;
wire          AMBA_SLAVE_0_PSLVERRS0;
wire   [31:0] APBmslave0_PWDATA;
wire          APBmslave0_PWRITE;
wire   [31:0] CoreAHBLite_0_AHBmslave1_HADDR;
wire   [2:0]  CoreAHBLite_0_AHBmslave1_HBURST;
wire          CoreAHBLite_0_AHBmslave1_HMASTLOCK;
wire   [3:0]  CoreAHBLite_0_AHBmslave1_HPROT;
wire   [31:0] CoreAHBLite_0_AHBmslave1_HRDATA;
wire          CoreAHBLite_0_AHBmslave1_HREADY;
wire          CoreAHBLite_0_AHBmslave1_HREADYOUT;
wire   [1:0]  CoreAHBLite_0_AHBmslave1_HRESP;
wire          CoreAHBLite_0_AHBmslave1_HSELx;
wire   [2:0]  CoreAHBLite_0_AHBmslave1_HSIZE;
wire   [1:0]  CoreAHBLite_0_AHBmslave1_HTRANS;
wire   [31:0] CoreAHBLite_0_AHBmslave1_HWDATA;
wire          CoreAHBLite_0_AHBmslave1_HWRITE;
wire   [31:0] CoreAHBLite_0_AHBmslave16_HADDR;
wire   [2:0]  CoreAHBLite_0_AHBmslave16_HBURST;
wire          CoreAHBLite_0_AHBmslave16_HMASTLOCK;
wire   [3:0]  CoreAHBLite_0_AHBmslave16_HPROT;
wire   [31:0] CoreAHBLite_0_AHBmslave16_HRDATA;
wire          CoreAHBLite_0_AHBmslave16_HREADY;
wire          CoreAHBLite_0_AHBmslave16_HREADYOUT;
wire          CoreAHBLite_0_AHBmslave16_HSELx;
wire   [1:0]  CoreAHBLite_0_AHBmslave16_HTRANS;
wire   [31:0] CoreAHBLite_0_AHBmslave16_HWDATA;
wire          CoreAHBLite_0_AHBmslave16_HWRITE;
wire   [31:0] COREAHBTOAPB3_0_APBmaster_PADDR;
wire          COREAHBTOAPB3_0_APBmaster_PENABLE;
wire   [31:0] COREAHBTOAPB3_0_APBmaster_PRDATA;
wire          COREAHBTOAPB3_0_APBmaster_PREADY;
wire          COREAHBTOAPB3_0_APBmaster_PSELx;
wire          COREAHBTOAPB3_0_APBmaster_PSLVERR;
wire   [31:0] COREAHBTOAPB3_0_APBmaster_PWDATA;
wire          COREAHBTOAPB3_0_APBmaster_PWRITE;
wire          CORERESETP_0_RESET_N_F2M;
wire          DEVRST_N;
wire          FAB_RESET_N;
wire          FABOSC_0_RCOSC_25_50MHZ_CCC_OUT_RCOSC_25_50MHZ_CCC;
wire          FABOSC_0_RCOSC_25_50MHZ_O2F;
wire          FIC_0_CLK_net_0;
wire          FIC_0_LOCK_net_0;
wire          INIT_DONE_net_0;
wire          M3_RESET_N;
wire          MMUART_0_RXD_F2M;
wire          MMUART_0_TXD_M2F_net_0;
wire          MSS_READY_net_0;
wire          my_mss_MSS_TMP_0_FIC_2_APB_M_PRESET_N;
wire          my_mss_MSS_TMP_0_MSS_RESET_N_M2F;
wire          POWER_ON_RESET_N_net_0;
wire          POWER_ON_RESET_N_net_1;
wire          INIT_DONE_net_1;
wire          APBmslave0_PSELx_net_0;
wire          APBmslave0_PENABLE_net_0;
wire          APBmslave0_PWRITE_net_0;
wire          FIC_0_CLK_net_1;
wire          FIC_0_LOCK_net_1;
wire          MSS_READY_net_1;
wire          AMBA_MASTER_0_HREADY_net_0;
wire          MMUART_0_TXD_M2F_net_1;
wire   [31:0] APBmslave0_PADDR_net_0;
wire   [31:0] APBmslave0_PWDATA_net_0;
wire   [31:0] AMBA_MASTER_0_HRDATA_net_0;
wire   [1:0]  AMBA_MASTER_0_HRESP_net_0;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire          GND_net;
wire          VCC_net;
wire   [7:2]  PADDR_const_net_0;
wire   [7:0]  PWDATA_const_net_0;
wire   [31:0] IADDR_const_net_0;
wire   [31:0] SDIF0_PRDATA_const_net_0;
wire   [31:0] SDIF1_PRDATA_const_net_0;
wire   [31:0] SDIF2_PRDATA_const_net_0;
wire   [31:0] SDIF3_PRDATA_const_net_0;
wire   [31:0] HADDR_M1_const_net_0;
wire   [1:0]  HTRANS_M1_const_net_0;
wire   [2:0]  HSIZE_M1_const_net_0;
wire   [2:0]  HBURST_M1_const_net_0;
wire   [3:0]  HPROT_M1_const_net_0;
wire   [31:0] HWDATA_M1_const_net_0;
wire   [31:0] HADDR_M2_const_net_0;
wire   [1:0]  HTRANS_M2_const_net_0;
wire   [2:0]  HSIZE_M2_const_net_0;
wire   [2:0]  HBURST_M2_const_net_0;
wire   [3:0]  HPROT_M2_const_net_0;
wire   [31:0] HWDATA_M2_const_net_0;
wire   [31:0] HADDR_M3_const_net_0;
wire   [1:0]  HTRANS_M3_const_net_0;
wire   [2:0]  HSIZE_M3_const_net_0;
wire   [2:0]  HBURST_M3_const_net_0;
wire   [3:0]  HPROT_M3_const_net_0;
wire   [31:0] HWDATA_M3_const_net_0;
wire   [31:0] HRDATA_S0_const_net_0;
wire   [1:0]  HRESP_S0_const_net_0;
wire   [31:0] HRDATA_S2_const_net_0;
wire   [1:0]  HRESP_S2_const_net_0;
wire   [31:0] HRDATA_S3_const_net_0;
wire   [1:0]  HRESP_S3_const_net_0;
wire   [31:0] HRDATA_S4_const_net_0;
wire   [1:0]  HRESP_S4_const_net_0;
wire   [31:0] HRDATA_S5_const_net_0;
wire   [1:0]  HRESP_S5_const_net_0;
wire   [31:0] HRDATA_S6_const_net_0;
wire   [1:0]  HRESP_S6_const_net_0;
wire   [31:0] HRDATA_S7_const_net_0;
wire   [1:0]  HRESP_S7_const_net_0;
wire   [31:0] HRDATA_S8_const_net_0;
wire   [1:0]  HRESP_S8_const_net_0;
wire   [31:0] HRDATA_S9_const_net_0;
wire   [1:0]  HRESP_S9_const_net_0;
wire   [31:0] HRDATA_S10_const_net_0;
wire   [1:0]  HRESP_S10_const_net_0;
wire   [31:0] HRDATA_S11_const_net_0;
wire   [1:0]  HRESP_S11_const_net_0;
wire   [31:0] HRDATA_S12_const_net_0;
wire   [1:0]  HRESP_S12_const_net_0;
wire   [31:0] HRDATA_S13_const_net_0;
wire   [1:0]  HRESP_S13_const_net_0;
wire   [31:0] HRDATA_S14_const_net_0;
wire   [1:0]  HRESP_S14_const_net_0;
wire   [31:0] HRDATA_S15_const_net_0;
wire   [1:0]  HRESP_S15_const_net_0;
wire   [31:0] PRDATAS1_const_net_0;
wire   [31:0] PRDATAS2_const_net_0;
wire   [31:0] PRDATAS3_const_net_0;
wire   [31:0] PRDATAS4_const_net_0;
wire   [31:0] PRDATAS5_const_net_0;
wire   [31:0] PRDATAS6_const_net_0;
wire   [31:0] PRDATAS7_const_net_0;
wire   [31:0] PRDATAS8_const_net_0;
wire   [31:0] PRDATAS9_const_net_0;
wire   [31:0] PRDATAS10_const_net_0;
wire   [31:0] PRDATAS11_const_net_0;
wire   [31:0] PRDATAS12_const_net_0;
wire   [31:0] PRDATAS13_const_net_0;
wire   [31:0] PRDATAS14_const_net_0;
wire   [31:0] PRDATAS15_const_net_0;
wire   [31:0] PRDATAS16_const_net_0;
wire   [31:0] FIC_2_APB_M_PRDATA_const_net_0;
//--------------------------------------------------------------------
// Bus Interface Nets Declarations - Unequal Pin Widths
//--------------------------------------------------------------------
wire          CoreAHBLite_0_AHBmslave16_HRESP;
wire   [1:1]  CoreAHBLite_0_AHBmslave16_HRESP_0_1to1;
wire   [0:0]  CoreAHBLite_0_AHBmslave16_HRESP_0_0to0;
wire   [1:0]  CoreAHBLite_0_AHBmslave16_HRESP_0;
wire   [1:0]  CoreAHBLite_0_AHBmslave16_HSIZE_0_1to0;
wire   [1:0]  CoreAHBLite_0_AHBmslave16_HSIZE_0;
wire   [2:0]  CoreAHBLite_0_AHBmslave16_HSIZE;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign GND_net                        = 1'b0;
assign VCC_net                        = 1'b1;
assign PADDR_const_net_0              = 6'h00;
assign PWDATA_const_net_0             = 8'h00;
assign IADDR_const_net_0              = 32'h00000000;
assign SDIF0_PRDATA_const_net_0       = 32'h00000000;
assign SDIF1_PRDATA_const_net_0       = 32'h00000000;
assign SDIF2_PRDATA_const_net_0       = 32'h00000000;
assign SDIF3_PRDATA_const_net_0       = 32'h00000000;
assign HADDR_M1_const_net_0           = 32'h00000000;
assign HTRANS_M1_const_net_0          = 2'h0;
assign HSIZE_M1_const_net_0           = 3'h0;
assign HBURST_M1_const_net_0          = 3'h0;
assign HPROT_M1_const_net_0           = 4'h0;
assign HWDATA_M1_const_net_0          = 32'h00000000;
assign HADDR_M2_const_net_0           = 32'h00000000;
assign HTRANS_M2_const_net_0          = 2'h0;
assign HSIZE_M2_const_net_0           = 3'h0;
assign HBURST_M2_const_net_0          = 3'h0;
assign HPROT_M2_const_net_0           = 4'h0;
assign HWDATA_M2_const_net_0          = 32'h00000000;
assign HADDR_M3_const_net_0           = 32'h00000000;
assign HTRANS_M3_const_net_0          = 2'h0;
assign HSIZE_M3_const_net_0           = 3'h0;
assign HBURST_M3_const_net_0          = 3'h0;
assign HPROT_M3_const_net_0           = 4'h0;
assign HWDATA_M3_const_net_0          = 32'h00000000;
assign HRDATA_S0_const_net_0          = 32'h00000000;
assign HRESP_S0_const_net_0           = 2'h0;
assign HRDATA_S2_const_net_0          = 32'h00000000;
assign HRESP_S2_const_net_0           = 2'h0;
assign HRDATA_S3_const_net_0          = 32'h00000000;
assign HRESP_S3_const_net_0           = 2'h0;
assign HRDATA_S4_const_net_0          = 32'h00000000;
assign HRESP_S4_const_net_0           = 2'h0;
assign HRDATA_S5_const_net_0          = 32'h00000000;
assign HRESP_S5_const_net_0           = 2'h0;
assign HRDATA_S6_const_net_0          = 32'h00000000;
assign HRESP_S6_const_net_0           = 2'h0;
assign HRDATA_S7_const_net_0          = 32'h00000000;
assign HRESP_S7_const_net_0           = 2'h0;
assign HRDATA_S8_const_net_0          = 32'h00000000;
assign HRESP_S8_const_net_0           = 2'h0;
assign HRDATA_S9_const_net_0          = 32'h00000000;
assign HRESP_S9_const_net_0           = 2'h0;
assign HRDATA_S10_const_net_0         = 32'h00000000;
assign HRESP_S10_const_net_0          = 2'h0;
assign HRDATA_S11_const_net_0         = 32'h00000000;
assign HRESP_S11_const_net_0          = 2'h0;
assign HRDATA_S12_const_net_0         = 32'h00000000;
assign HRESP_S12_const_net_0          = 2'h0;
assign HRDATA_S13_const_net_0         = 32'h00000000;
assign HRESP_S13_const_net_0          = 2'h0;
assign HRDATA_S14_const_net_0         = 32'h00000000;
assign HRESP_S14_const_net_0          = 2'h0;
assign HRDATA_S15_const_net_0         = 32'h00000000;
assign HRESP_S15_const_net_0          = 2'h0;
assign PRDATAS1_const_net_0           = 32'h00000000;
assign PRDATAS2_const_net_0           = 32'h00000000;
assign PRDATAS3_const_net_0           = 32'h00000000;
assign PRDATAS4_const_net_0           = 32'h00000000;
assign PRDATAS5_const_net_0           = 32'h00000000;
assign PRDATAS6_const_net_0           = 32'h00000000;
assign PRDATAS7_const_net_0           = 32'h00000000;
assign PRDATAS8_const_net_0           = 32'h00000000;
assign PRDATAS9_const_net_0           = 32'h00000000;
assign PRDATAS10_const_net_0          = 32'h00000000;
assign PRDATAS11_const_net_0          = 32'h00000000;
assign PRDATAS12_const_net_0          = 32'h00000000;
assign PRDATAS13_const_net_0          = 32'h00000000;
assign PRDATAS14_const_net_0          = 32'h00000000;
assign PRDATAS15_const_net_0          = 32'h00000000;
assign PRDATAS16_const_net_0          = 32'h00000000;
assign FIC_2_APB_M_PRDATA_const_net_0 = 32'h00000000;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign POWER_ON_RESET_N_net_1        = POWER_ON_RESET_N_net_0;
assign POWER_ON_RESET_N              = POWER_ON_RESET_N_net_1;
assign INIT_DONE_net_1               = INIT_DONE_net_0;
assign INIT_DONE                     = INIT_DONE_net_1;
assign APBmslave0_PSELx_net_0        = APBmslave0_PSELx;
assign AMBA_SLAVE_0_PSELS0           = APBmslave0_PSELx_net_0;
assign APBmslave0_PENABLE_net_0      = APBmslave0_PENABLE;
assign AMBA_SLAVE_0_PENABLES         = APBmslave0_PENABLE_net_0;
assign APBmslave0_PWRITE_net_0       = APBmslave0_PWRITE;
assign AMBA_SLAVE_0_PWRITES          = APBmslave0_PWRITE_net_0;
assign FIC_0_CLK_net_1               = FIC_0_CLK_net_0;
assign FIC_0_CLK                     = FIC_0_CLK_net_1;
assign FIC_0_LOCK_net_1              = FIC_0_LOCK_net_0;
assign FIC_0_LOCK                    = FIC_0_LOCK_net_1;
assign MSS_READY_net_1               = MSS_READY_net_0;
assign MSS_READY                     = MSS_READY_net_1;
assign AMBA_MASTER_0_HREADY_net_0    = AMBA_MASTER_0_HREADY;
assign AMBA_MASTER_0_HREADY_M0       = AMBA_MASTER_0_HREADY_net_0;
assign MMUART_0_TXD_M2F_net_1        = MMUART_0_TXD_M2F_net_0;
assign MMUART_0_TXD_M2F              = MMUART_0_TXD_M2F_net_1;
assign APBmslave0_PADDR_net_0        = APBmslave0_PADDR;
assign AMBA_SLAVE_0_PADDRS[31:0]     = APBmslave0_PADDR_net_0;
assign APBmslave0_PWDATA_net_0       = APBmslave0_PWDATA;
assign AMBA_SLAVE_0_PWDATAS[31:0]    = APBmslave0_PWDATA_net_0;
assign AMBA_MASTER_0_HRDATA_net_0    = AMBA_MASTER_0_HRDATA;
assign AMBA_MASTER_0_HRDATA_M0[31:0] = AMBA_MASTER_0_HRDATA_net_0;
assign AMBA_MASTER_0_HRESP_net_0     = AMBA_MASTER_0_HRESP;
assign AMBA_MASTER_0_HRESP_M0[1:0]   = AMBA_MASTER_0_HRESP_net_0;
//--------------------------------------------------------------------
// Bus Interface Nets Assignments - Unequal Pin Widths
//--------------------------------------------------------------------
assign CoreAHBLite_0_AHBmslave16_HRESP_0_1to1 = 1'b0;
assign CoreAHBLite_0_AHBmslave16_HRESP_0_0to0 = CoreAHBLite_0_AHBmslave16_HRESP;
assign CoreAHBLite_0_AHBmslave16_HRESP_0 = { CoreAHBLite_0_AHBmslave16_HRESP_0_1to1, CoreAHBLite_0_AHBmslave16_HRESP_0_0to0 };

assign CoreAHBLite_0_AHBmslave16_HSIZE_0_1to0 = CoreAHBLite_0_AHBmslave16_HSIZE[1:0];
assign CoreAHBLite_0_AHBmslave16_HSIZE_0 = { CoreAHBLite_0_AHBmslave16_HSIZE_0_1to0 };

//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------my_mss_CCC_0_FCCC   -   Actel:SgCore:FCCC:2.0.200
my_mss_CCC_0_FCCC CCC_0(
        // Inputs
        .RCOSC_25_50MHZ ( FABOSC_0_RCOSC_25_50MHZ_CCC_OUT_RCOSC_25_50MHZ_CCC ),
        // Outputs
        .GL0            ( FIC_0_CLK_net_0 ),
        .LOCK           ( FIC_0_LOCK_net_0 ) 
        );

//--------CoreAHBLite   -   Actel:DirectCore:CoreAHBLite:5.2.100
CoreAHBLite #( 
        .FAMILY             ( 19 ),
        .HADDR_SHG_CFG      ( 1 ),
        .M0_AHBSLOT0ENABLE  ( 0 ),
        .M0_AHBSLOT1ENABLE  ( 1 ),
        .M0_AHBSLOT2ENABLE  ( 0 ),
        .M0_AHBSLOT3ENABLE  ( 0 ),
        .M0_AHBSLOT4ENABLE  ( 0 ),
        .M0_AHBSLOT5ENABLE  ( 0 ),
        .M0_AHBSLOT6ENABLE  ( 0 ),
        .M0_AHBSLOT7ENABLE  ( 0 ),
        .M0_AHBSLOT8ENABLE  ( 0 ),
        .M0_AHBSLOT9ENABLE  ( 0 ),
        .M0_AHBSLOT10ENABLE ( 0 ),
        .M0_AHBSLOT11ENABLE ( 0 ),
        .M0_AHBSLOT12ENABLE ( 0 ),
        .M0_AHBSLOT13ENABLE ( 0 ),
        .M0_AHBSLOT14ENABLE ( 0 ),
        .M0_AHBSLOT15ENABLE ( 0 ),
        .M0_AHBSLOT16ENABLE ( 1 ),
        .M1_AHBSLOT0ENABLE  ( 0 ),
        .M1_AHBSLOT1ENABLE  ( 0 ),
        .M1_AHBSLOT2ENABLE  ( 0 ),
        .M1_AHBSLOT3ENABLE  ( 0 ),
        .M1_AHBSLOT4ENABLE  ( 0 ),
        .M1_AHBSLOT5ENABLE  ( 0 ),
        .M1_AHBSLOT6ENABLE  ( 0 ),
        .M1_AHBSLOT7ENABLE  ( 0 ),
        .M1_AHBSLOT8ENABLE  ( 0 ),
        .M1_AHBSLOT9ENABLE  ( 0 ),
        .M1_AHBSLOT10ENABLE ( 0 ),
        .M1_AHBSLOT11ENABLE ( 0 ),
        .M1_AHBSLOT12ENABLE ( 0 ),
        .M1_AHBSLOT13ENABLE ( 0 ),
        .M1_AHBSLOT14ENABLE ( 0 ),
        .M1_AHBSLOT15ENABLE ( 0 ),
        .M1_AHBSLOT16ENABLE ( 0 ),
        .M2_AHBSLOT0ENABLE  ( 0 ),
        .M2_AHBSLOT1ENABLE  ( 0 ),
        .M2_AHBSLOT2ENABLE  ( 0 ),
        .M2_AHBSLOT3ENABLE  ( 0 ),
        .M2_AHBSLOT4ENABLE  ( 0 ),
        .M2_AHBSLOT5ENABLE  ( 0 ),
        .M2_AHBSLOT6ENABLE  ( 0 ),
        .M2_AHBSLOT7ENABLE  ( 0 ),
        .M2_AHBSLOT8ENABLE  ( 0 ),
        .M2_AHBSLOT9ENABLE  ( 0 ),
        .M2_AHBSLOT10ENABLE ( 0 ),
        .M2_AHBSLOT11ENABLE ( 0 ),
        .M2_AHBSLOT12ENABLE ( 0 ),
        .M2_AHBSLOT13ENABLE ( 0 ),
        .M2_AHBSLOT14ENABLE ( 0 ),
        .M2_AHBSLOT15ENABLE ( 0 ),
        .M2_AHBSLOT16ENABLE ( 0 ),
        .M3_AHBSLOT0ENABLE  ( 0 ),
        .M3_AHBSLOT1ENABLE  ( 0 ),
        .M3_AHBSLOT2ENABLE  ( 0 ),
        .M3_AHBSLOT3ENABLE  ( 0 ),
        .M3_AHBSLOT4ENABLE  ( 0 ),
        .M3_AHBSLOT5ENABLE  ( 0 ),
        .M3_AHBSLOT6ENABLE  ( 0 ),
        .M3_AHBSLOT7ENABLE  ( 0 ),
        .M3_AHBSLOT8ENABLE  ( 0 ),
        .M3_AHBSLOT9ENABLE  ( 0 ),
        .M3_AHBSLOT10ENABLE ( 0 ),
        .M3_AHBSLOT11ENABLE ( 0 ),
        .M3_AHBSLOT12ENABLE ( 0 ),
        .M3_AHBSLOT13ENABLE ( 0 ),
        .M3_AHBSLOT14ENABLE ( 0 ),
        .M3_AHBSLOT15ENABLE ( 0 ),
        .M3_AHBSLOT16ENABLE ( 0 ),
        .MEMSPACE           ( 1 ),
        .SC_0               ( 1 ),
        .SC_1               ( 0 ),
        .SC_2               ( 1 ),
        .SC_3               ( 0 ),
        .SC_4               ( 1 ),
        .SC_5               ( 0 ),
        .SC_6               ( 1 ),
        .SC_7               ( 0 ),
        .SC_8               ( 0 ),
        .SC_9               ( 0 ),
        .SC_10              ( 0 ),
        .SC_11              ( 0 ),
        .SC_12              ( 0 ),
        .SC_13              ( 0 ),
        .SC_14              ( 0 ),
        .SC_15              ( 0 ) )
CoreAHBLite_0(
        // Inputs
        .HCLK          ( FIC_0_CLK_net_0 ),
        .HRESETN       ( MSS_READY_net_0 ),
        .REMAP_M0      ( GND_net ),
        .HMASTLOCK_M0  ( AMBA_MASTER_0_HMASTLOCK_M0 ),
        .HWRITE_M0     ( AMBA_MASTER_0_HWRITE_M0 ),
        .HMASTLOCK_M1  ( GND_net ), // tied to 1'b0 from definition
        .HWRITE_M1     ( GND_net ), // tied to 1'b0 from definition
        .HMASTLOCK_M2  ( GND_net ), // tied to 1'b0 from definition
        .HWRITE_M2     ( GND_net ), // tied to 1'b0 from definition
        .HMASTLOCK_M3  ( GND_net ), // tied to 1'b0 from definition
        .HWRITE_M3     ( GND_net ), // tied to 1'b0 from definition
        .HREADYOUT_S0  ( VCC_net ), // tied to 1'b1 from definition
        .HREADYOUT_S1  ( CoreAHBLite_0_AHBmslave1_HREADYOUT ),
        .HREADYOUT_S2  ( VCC_net ), // tied to 1'b1 from definition
        .HREADYOUT_S3  ( VCC_net ), // tied to 1'b1 from definition
        .HREADYOUT_S4  ( VCC_net ), // tied to 1'b1 from definition
        .HREADYOUT_S5  ( VCC_net ), // tied to 1'b1 from definition
        .HREADYOUT_S6  ( VCC_net ), // tied to 1'b1 from definition
        .HREADYOUT_S7  ( VCC_net ), // tied to 1'b1 from definition
        .HREADYOUT_S8  ( VCC_net ), // tied to 1'b1 from definition
        .HREADYOUT_S9  ( VCC_net ), // tied to 1'b1 from definition
        .HREADYOUT_S10 ( VCC_net ), // tied to 1'b1 from definition
        .HREADYOUT_S11 ( VCC_net ), // tied to 1'b1 from definition
        .HREADYOUT_S12 ( VCC_net ), // tied to 1'b1 from definition
        .HREADYOUT_S13 ( VCC_net ), // tied to 1'b1 from definition
        .HREADYOUT_S14 ( VCC_net ), // tied to 1'b1 from definition
        .HREADYOUT_S15 ( VCC_net ), // tied to 1'b1 from definition
        .HREADYOUT_S16 ( CoreAHBLite_0_AHBmslave16_HREADYOUT ),
        .HADDR_M0      ( AMBA_MASTER_0_HADDR_M0 ),
        .HSIZE_M0      ( AMBA_MASTER_0_HSIZE_M0 ),
        .HTRANS_M0     ( AMBA_MASTER_0_HTRANS_M0 ),
        .HWDATA_M0     ( AMBA_MASTER_0_HWDATA_M0 ),
        .HBURST_M0     ( AMBA_MASTER_0_HBURST_M0 ),
        .HPROT_M0      ( AMBA_MASTER_0_HPROT_M0 ),
        .HADDR_M1      ( HADDR_M1_const_net_0 ), // tied to 32'h00000000 from definition
        .HSIZE_M1      ( HSIZE_M1_const_net_0 ), // tied to 3'h0 from definition
        .HTRANS_M1     ( HTRANS_M1_const_net_0 ), // tied to 2'h0 from definition
        .HWDATA_M1     ( HWDATA_M1_const_net_0 ), // tied to 32'h00000000 from definition
        .HBURST_M1     ( HBURST_M1_const_net_0 ), // tied to 3'h0 from definition
        .HPROT_M1      ( HPROT_M1_const_net_0 ), // tied to 4'h0 from definition
        .HADDR_M2      ( HADDR_M2_const_net_0 ), // tied to 32'h00000000 from definition
        .HSIZE_M2      ( HSIZE_M2_const_net_0 ), // tied to 3'h0 from definition
        .HTRANS_M2     ( HTRANS_M2_const_net_0 ), // tied to 2'h0 from definition
        .HWDATA_M2     ( HWDATA_M2_const_net_0 ), // tied to 32'h00000000 from definition
        .HBURST_M2     ( HBURST_M2_const_net_0 ), // tied to 3'h0 from definition
        .HPROT_M2      ( HPROT_M2_const_net_0 ), // tied to 4'h0 from definition
        .HADDR_M3      ( HADDR_M3_const_net_0 ), // tied to 32'h00000000 from definition
        .HSIZE_M3      ( HSIZE_M3_const_net_0 ), // tied to 3'h0 from definition
        .HTRANS_M3     ( HTRANS_M3_const_net_0 ), // tied to 2'h0 from definition
        .HWDATA_M3     ( HWDATA_M3_const_net_0 ), // tied to 32'h00000000 from definition
        .HBURST_M3     ( HBURST_M3_const_net_0 ), // tied to 3'h0 from definition
        .HPROT_M3      ( HPROT_M3_const_net_0 ), // tied to 4'h0 from definition
        .HRDATA_S0     ( HRDATA_S0_const_net_0 ), // tied to 32'h00000000 from definition
        .HRESP_S0      ( HRESP_S0_const_net_0 ), // tied to 2'h0 from definition
        .HRDATA_S1     ( CoreAHBLite_0_AHBmslave1_HRDATA ),
        .HRESP_S1      ( CoreAHBLite_0_AHBmslave1_HRESP ),
        .HRDATA_S2     ( HRDATA_S2_const_net_0 ), // tied to 32'h00000000 from definition
        .HRESP_S2      ( HRESP_S2_const_net_0 ), // tied to 2'h0 from definition
        .HRDATA_S3     ( HRDATA_S3_const_net_0 ), // tied to 32'h00000000 from definition
        .HRESP_S3      ( HRESP_S3_const_net_0 ), // tied to 2'h0 from definition
        .HRDATA_S4     ( HRDATA_S4_const_net_0 ), // tied to 32'h00000000 from definition
        .HRESP_S4      ( HRESP_S4_const_net_0 ), // tied to 2'h0 from definition
        .HRDATA_S5     ( HRDATA_S5_const_net_0 ), // tied to 32'h00000000 from definition
        .HRESP_S5      ( HRESP_S5_const_net_0 ), // tied to 2'h0 from definition
        .HRDATA_S6     ( HRDATA_S6_const_net_0 ), // tied to 32'h00000000 from definition
        .HRESP_S6      ( HRESP_S6_const_net_0 ), // tied to 2'h0 from definition
        .HRDATA_S7     ( HRDATA_S7_const_net_0 ), // tied to 32'h00000000 from definition
        .HRESP_S7      ( HRESP_S7_const_net_0 ), // tied to 2'h0 from definition
        .HRDATA_S8     ( HRDATA_S8_const_net_0 ), // tied to 32'h00000000 from definition
        .HRESP_S8      ( HRESP_S8_const_net_0 ), // tied to 2'h0 from definition
        .HRDATA_S9     ( HRDATA_S9_const_net_0 ), // tied to 32'h00000000 from definition
        .HRESP_S9      ( HRESP_S9_const_net_0 ), // tied to 2'h0 from definition
        .HRDATA_S10    ( HRDATA_S10_const_net_0 ), // tied to 32'h00000000 from definition
        .HRESP_S10     ( HRESP_S10_const_net_0 ), // tied to 2'h0 from definition
        .HRDATA_S11    ( HRDATA_S11_const_net_0 ), // tied to 32'h00000000 from definition
        .HRESP_S11     ( HRESP_S11_const_net_0 ), // tied to 2'h0 from definition
        .HRDATA_S12    ( HRDATA_S12_const_net_0 ), // tied to 32'h00000000 from definition
        .HRESP_S12     ( HRESP_S12_const_net_0 ), // tied to 2'h0 from definition
        .HRDATA_S13    ( HRDATA_S13_const_net_0 ), // tied to 32'h00000000 from definition
        .HRESP_S13     ( HRESP_S13_const_net_0 ), // tied to 2'h0 from definition
        .HRDATA_S14    ( HRDATA_S14_const_net_0 ), // tied to 32'h00000000 from definition
        .HRESP_S14     ( HRESP_S14_const_net_0 ), // tied to 2'h0 from definition
        .HRDATA_S15    ( HRDATA_S15_const_net_0 ), // tied to 32'h00000000 from definition
        .HRESP_S15     ( HRESP_S15_const_net_0 ), // tied to 2'h0 from definition
        .HRDATA_S16    ( CoreAHBLite_0_AHBmslave16_HRDATA ),
        .HRESP_S16     ( CoreAHBLite_0_AHBmslave16_HRESP_0 ),
        // Outputs
        .HREADY_M0     ( AMBA_MASTER_0_HREADY ),
        .HREADY_M1     (  ),
        .HREADY_M2     (  ),
        .HREADY_M3     (  ),
        .HSEL_S0       (  ),
        .HWRITE_S0     (  ),
        .HREADY_S0     (  ),
        .HMASTLOCK_S0  (  ),
        .HSEL_S1       ( CoreAHBLite_0_AHBmslave1_HSELx ),
        .HWRITE_S1     ( CoreAHBLite_0_AHBmslave1_HWRITE ),
        .HREADY_S1     ( CoreAHBLite_0_AHBmslave1_HREADY ),
        .HMASTLOCK_S1  ( CoreAHBLite_0_AHBmslave1_HMASTLOCK ),
        .HSEL_S2       (  ),
        .HWRITE_S2     (  ),
        .HREADY_S2     (  ),
        .HMASTLOCK_S2  (  ),
        .HSEL_S3       (  ),
        .HWRITE_S3     (  ),
        .HREADY_S3     (  ),
        .HMASTLOCK_S3  (  ),
        .HSEL_S4       (  ),
        .HWRITE_S4     (  ),
        .HREADY_S4     (  ),
        .HMASTLOCK_S4  (  ),
        .HSEL_S5       (  ),
        .HWRITE_S5     (  ),
        .HREADY_S5     (  ),
        .HMASTLOCK_S5  (  ),
        .HSEL_S6       (  ),
        .HWRITE_S6     (  ),
        .HREADY_S6     (  ),
        .HMASTLOCK_S6  (  ),
        .HSEL_S7       (  ),
        .HWRITE_S7     (  ),
        .HREADY_S7     (  ),
        .HMASTLOCK_S7  (  ),
        .HSEL_S8       (  ),
        .HWRITE_S8     (  ),
        .HREADY_S8     (  ),
        .HMASTLOCK_S8  (  ),
        .HSEL_S9       (  ),
        .HWRITE_S9     (  ),
        .HREADY_S9     (  ),
        .HMASTLOCK_S9  (  ),
        .HSEL_S10      (  ),
        .HWRITE_S10    (  ),
        .HREADY_S10    (  ),
        .HMASTLOCK_S10 (  ),
        .HSEL_S11      (  ),
        .HWRITE_S11    (  ),
        .HREADY_S11    (  ),
        .HMASTLOCK_S11 (  ),
        .HSEL_S12      (  ),
        .HWRITE_S12    (  ),
        .HREADY_S12    (  ),
        .HMASTLOCK_S12 (  ),
        .HSEL_S13      (  ),
        .HWRITE_S13    (  ),
        .HREADY_S13    (  ),
        .HMASTLOCK_S13 (  ),
        .HSEL_S14      (  ),
        .HWRITE_S14    (  ),
        .HREADY_S14    (  ),
        .HMASTLOCK_S14 (  ),
        .HSEL_S15      (  ),
        .HWRITE_S15    (  ),
        .HREADY_S15    (  ),
        .HMASTLOCK_S15 (  ),
        .HSEL_S16      ( CoreAHBLite_0_AHBmslave16_HSELx ),
        .HWRITE_S16    ( CoreAHBLite_0_AHBmslave16_HWRITE ),
        .HREADY_S16    ( CoreAHBLite_0_AHBmslave16_HREADY ),
        .HMASTLOCK_S16 ( CoreAHBLite_0_AHBmslave16_HMASTLOCK ),
        .HRESP_M0      ( AMBA_MASTER_0_HRESP ),
        .HRDATA_M0     ( AMBA_MASTER_0_HRDATA ),
        .HRESP_M1      (  ),
        .HRDATA_M1     (  ),
        .HRESP_M2      (  ),
        .HRDATA_M2     (  ),
        .HRESP_M3      (  ),
        .HRDATA_M3     (  ),
        .HADDR_S0      (  ),
        .HSIZE_S0      (  ),
        .HTRANS_S0     (  ),
        .HWDATA_S0     (  ),
        .HBURST_S0     (  ),
        .HPROT_S0      (  ),
        .HADDR_S1      ( CoreAHBLite_0_AHBmslave1_HADDR ),
        .HSIZE_S1      ( CoreAHBLite_0_AHBmslave1_HSIZE ),
        .HTRANS_S1     ( CoreAHBLite_0_AHBmslave1_HTRANS ),
        .HWDATA_S1     ( CoreAHBLite_0_AHBmslave1_HWDATA ),
        .HBURST_S1     ( CoreAHBLite_0_AHBmslave1_HBURST ),
        .HPROT_S1      ( CoreAHBLite_0_AHBmslave1_HPROT ),
        .HADDR_S2      (  ),
        .HSIZE_S2      (  ),
        .HTRANS_S2     (  ),
        .HWDATA_S2     (  ),
        .HBURST_S2     (  ),
        .HPROT_S2      (  ),
        .HADDR_S3      (  ),
        .HSIZE_S3      (  ),
        .HTRANS_S3     (  ),
        .HWDATA_S3     (  ),
        .HBURST_S3     (  ),
        .HPROT_S3      (  ),
        .HADDR_S4      (  ),
        .HSIZE_S4      (  ),
        .HTRANS_S4     (  ),
        .HWDATA_S4     (  ),
        .HBURST_S4     (  ),
        .HPROT_S4      (  ),
        .HADDR_S5      (  ),
        .HSIZE_S5      (  ),
        .HTRANS_S5     (  ),
        .HWDATA_S5     (  ),
        .HBURST_S5     (  ),
        .HPROT_S5      (  ),
        .HADDR_S6      (  ),
        .HSIZE_S6      (  ),
        .HTRANS_S6     (  ),
        .HWDATA_S6     (  ),
        .HBURST_S6     (  ),
        .HPROT_S6      (  ),
        .HADDR_S7      (  ),
        .HSIZE_S7      (  ),
        .HTRANS_S7     (  ),
        .HWDATA_S7     (  ),
        .HBURST_S7     (  ),
        .HPROT_S7      (  ),
        .HADDR_S8      (  ),
        .HSIZE_S8      (  ),
        .HTRANS_S8     (  ),
        .HWDATA_S8     (  ),
        .HBURST_S8     (  ),
        .HPROT_S8      (  ),
        .HADDR_S9      (  ),
        .HSIZE_S9      (  ),
        .HTRANS_S9     (  ),
        .HWDATA_S9     (  ),
        .HBURST_S9     (  ),
        .HPROT_S9      (  ),
        .HADDR_S10     (  ),
        .HSIZE_S10     (  ),
        .HTRANS_S10    (  ),
        .HWDATA_S10    (  ),
        .HBURST_S10    (  ),
        .HPROT_S10     (  ),
        .HADDR_S11     (  ),
        .HSIZE_S11     (  ),
        .HTRANS_S11    (  ),
        .HWDATA_S11    (  ),
        .HBURST_S11    (  ),
        .HPROT_S11     (  ),
        .HADDR_S12     (  ),
        .HSIZE_S12     (  ),
        .HTRANS_S12    (  ),
        .HWDATA_S12    (  ),
        .HBURST_S12    (  ),
        .HPROT_S12     (  ),
        .HADDR_S13     (  ),
        .HSIZE_S13     (  ),
        .HTRANS_S13    (  ),
        .HWDATA_S13    (  ),
        .HBURST_S13    (  ),
        .HPROT_S13     (  ),
        .HADDR_S14     (  ),
        .HSIZE_S14     (  ),
        .HTRANS_S14    (  ),
        .HWDATA_S14    (  ),
        .HBURST_S14    (  ),
        .HPROT_S14     (  ),
        .HADDR_S15     (  ),
        .HSIZE_S15     (  ),
        .HTRANS_S15    (  ),
        .HWDATA_S15    (  ),
        .HBURST_S15    (  ),
        .HPROT_S15     (  ),
        .HADDR_S16     ( CoreAHBLite_0_AHBmslave16_HADDR ),
        .HSIZE_S16     ( CoreAHBLite_0_AHBmslave16_HSIZE ),
        .HTRANS_S16    ( CoreAHBLite_0_AHBmslave16_HTRANS ),
        .HWDATA_S16    ( CoreAHBLite_0_AHBmslave16_HWDATA ),
        .HBURST_S16    ( CoreAHBLite_0_AHBmslave16_HBURST ),
        .HPROT_S16     ( CoreAHBLite_0_AHBmslave16_HPROT ) 
        );

//--------COREAHBTOAPB3   -   Actel:DirectCore:COREAHBTOAPB3:3.1.100
COREAHBTOAPB3 #( 
        .FAMILY ( 19 ) )
COREAHBTOAPB3_0(
        // Inputs
        .HCLK      ( FIC_0_CLK_net_0 ),
        .HRESETN   ( MSS_READY_net_0 ),
        .HWRITE    ( CoreAHBLite_0_AHBmslave1_HWRITE ),
        .HSEL      ( CoreAHBLite_0_AHBmslave1_HSELx ),
        .HREADY    ( CoreAHBLite_0_AHBmslave1_HREADY ),
        .PREADY    ( COREAHBTOAPB3_0_APBmaster_PREADY ),
        .PSLVERR   ( COREAHBTOAPB3_0_APBmaster_PSLVERR ),
        .HADDR     ( CoreAHBLite_0_AHBmslave1_HADDR ),
        .HTRANS    ( CoreAHBLite_0_AHBmslave1_HTRANS ),
        .HWDATA    ( CoreAHBLite_0_AHBmslave1_HWDATA ),
        .PRDATA    ( COREAHBTOAPB3_0_APBmaster_PRDATA ),
        // Outputs
        .HREADYOUT ( CoreAHBLite_0_AHBmslave1_HREADYOUT ),
        .PENABLE   ( COREAHBTOAPB3_0_APBmaster_PENABLE ),
        .PWRITE    ( COREAHBTOAPB3_0_APBmaster_PWRITE ),
        .PSEL      ( COREAHBTOAPB3_0_APBmaster_PSELx ),
        .HRDATA    ( CoreAHBLite_0_AHBmslave1_HRDATA ),
        .HRESP     ( CoreAHBLite_0_AHBmslave1_HRESP ),
        .PWDATA    ( COREAHBTOAPB3_0_APBmaster_PWDATA ),
        .PADDR     ( COREAHBTOAPB3_0_APBmaster_PADDR ) 
        );

//--------CoreAPB3   -   Actel:DirectCore:CoreAPB3:4.1.100
CoreAPB3 #( 
        .APB_DWIDTH      ( 32 ),
        .APBSLOT0ENABLE  ( 1 ),
        .APBSLOT1ENABLE  ( 0 ),
        .APBSLOT2ENABLE  ( 0 ),
        .APBSLOT3ENABLE  ( 0 ),
        .APBSLOT4ENABLE  ( 0 ),
        .APBSLOT5ENABLE  ( 0 ),
        .APBSLOT6ENABLE  ( 0 ),
        .APBSLOT7ENABLE  ( 0 ),
        .APBSLOT8ENABLE  ( 0 ),
        .APBSLOT9ENABLE  ( 0 ),
        .APBSLOT10ENABLE ( 0 ),
        .APBSLOT11ENABLE ( 0 ),
        .APBSLOT12ENABLE ( 0 ),
        .APBSLOT13ENABLE ( 0 ),
        .APBSLOT14ENABLE ( 0 ),
        .APBSLOT15ENABLE ( 0 ),
        .FAMILY          ( 19 ),
        .IADDR_OPTION    ( 0 ),
        .MADDR_BITS      ( 16 ),
        .SC_0            ( 0 ),
        .SC_1            ( 0 ),
        .SC_2            ( 0 ),
        .SC_3            ( 0 ),
        .SC_4            ( 0 ),
        .SC_5            ( 0 ),
        .SC_6            ( 0 ),
        .SC_7            ( 0 ),
        .SC_8            ( 0 ),
        .SC_9            ( 0 ),
        .SC_10           ( 0 ),
        .SC_11           ( 0 ),
        .SC_12           ( 0 ),
        .SC_13           ( 0 ),
        .SC_14           ( 0 ),
        .SC_15           ( 0 ),
        .UPR_NIBBLE_POSN ( 3 ) )
CoreAPB3_0(
        // Inputs
        .PRESETN    ( GND_net ), // tied to 1'b0 from definition
        .PCLK       ( GND_net ), // tied to 1'b0 from definition
        .PWRITE     ( COREAHBTOAPB3_0_APBmaster_PWRITE ),
        .PENABLE    ( COREAHBTOAPB3_0_APBmaster_PENABLE ),
        .PSEL       ( COREAHBTOAPB3_0_APBmaster_PSELx ),
        .PREADYS0   ( AMBA_SLAVE_0_PREADYS0 ),
        .PSLVERRS0  ( AMBA_SLAVE_0_PSLVERRS0 ),
        .PREADYS1   ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS1  ( GND_net ), // tied to 1'b0 from definition
        .PREADYS2   ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS2  ( GND_net ), // tied to 1'b0 from definition
        .PREADYS3   ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS3  ( GND_net ), // tied to 1'b0 from definition
        .PREADYS4   ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS4  ( GND_net ), // tied to 1'b0 from definition
        .PREADYS5   ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS5  ( GND_net ), // tied to 1'b0 from definition
        .PREADYS6   ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS6  ( GND_net ), // tied to 1'b0 from definition
        .PREADYS7   ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS7  ( GND_net ), // tied to 1'b0 from definition
        .PREADYS8   ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS8  ( GND_net ), // tied to 1'b0 from definition
        .PREADYS9   ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS9  ( GND_net ), // tied to 1'b0 from definition
        .PREADYS10  ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS10 ( GND_net ), // tied to 1'b0 from definition
        .PREADYS11  ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS11 ( GND_net ), // tied to 1'b0 from definition
        .PREADYS12  ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS12 ( GND_net ), // tied to 1'b0 from definition
        .PREADYS13  ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS13 ( GND_net ), // tied to 1'b0 from definition
        .PREADYS14  ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS14 ( GND_net ), // tied to 1'b0 from definition
        .PREADYS15  ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS15 ( GND_net ), // tied to 1'b0 from definition
        .PREADYS16  ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS16 ( GND_net ), // tied to 1'b0 from definition
        .PADDR      ( COREAHBTOAPB3_0_APBmaster_PADDR ),
        .PWDATA     ( COREAHBTOAPB3_0_APBmaster_PWDATA ),
        .PRDATAS0   ( AMBA_SLAVE_0_PRDATAS0 ),
        .PRDATAS1   ( PRDATAS1_const_net_0 ), // tied to 32'h00000000 from definition
        .PRDATAS2   ( PRDATAS2_const_net_0 ), // tied to 32'h00000000 from definition
        .PRDATAS3   ( PRDATAS3_const_net_0 ), // tied to 32'h00000000 from definition
        .PRDATAS4   ( PRDATAS4_const_net_0 ), // tied to 32'h00000000 from definition
        .PRDATAS5   ( PRDATAS5_const_net_0 ), // tied to 32'h00000000 from definition
        .PRDATAS6   ( PRDATAS6_const_net_0 ), // tied to 32'h00000000 from definition
        .PRDATAS7   ( PRDATAS7_const_net_0 ), // tied to 32'h00000000 from definition
        .PRDATAS8   ( PRDATAS8_const_net_0 ), // tied to 32'h00000000 from definition
        .PRDATAS9   ( PRDATAS9_const_net_0 ), // tied to 32'h00000000 from definition
        .PRDATAS10  ( PRDATAS10_const_net_0 ), // tied to 32'h00000000 from definition
        .PRDATAS11  ( PRDATAS11_const_net_0 ), // tied to 32'h00000000 from definition
        .PRDATAS12  ( PRDATAS12_const_net_0 ), // tied to 32'h00000000 from definition
        .PRDATAS13  ( PRDATAS13_const_net_0 ), // tied to 32'h00000000 from definition
        .PRDATAS14  ( PRDATAS14_const_net_0 ), // tied to 32'h00000000 from definition
        .PRDATAS15  ( PRDATAS15_const_net_0 ), // tied to 32'h00000000 from definition
        .PRDATAS16  ( PRDATAS16_const_net_0 ), // tied to 32'h00000000 from definition
        .IADDR      ( IADDR_const_net_0 ), // tied to 32'h00000000 from definition
        // Outputs
        .PREADY     ( COREAHBTOAPB3_0_APBmaster_PREADY ),
        .PSLVERR    ( COREAHBTOAPB3_0_APBmaster_PSLVERR ),
        .PWRITES    ( APBmslave0_PWRITE ),
        .PENABLES   ( APBmslave0_PENABLE ),
        .PSELS0     ( APBmslave0_PSELx ),
        .PSELS1     (  ),
        .PSELS2     (  ),
        .PSELS3     (  ),
        .PSELS4     (  ),
        .PSELS5     (  ),
        .PSELS6     (  ),
        .PSELS7     (  ),
        .PSELS8     (  ),
        .PSELS9     (  ),
        .PSELS10    (  ),
        .PSELS11    (  ),
        .PSELS12    (  ),
        .PSELS13    (  ),
        .PSELS14    (  ),
        .PSELS15    (  ),
        .PSELS16    (  ),
        .PRDATA     ( COREAHBTOAPB3_0_APBmaster_PRDATA ),
        .PADDRS     ( APBmslave0_PADDR ),
        .PWDATAS    ( APBmslave0_PWDATA ) 
        );

//--------CoreResetP   -   Actel:DirectCore:CoreResetP:7.0.104
CoreResetP #( 
        .DDR_WAIT            ( 200 ),
        .DEVICE_090          ( 0 ),
        .DEVICE_VOLTAGE      ( 2 ),
        .ENABLE_SOFT_RESETS  ( 0 ),
        .EXT_RESET_CFG       ( 0 ),
        .FDDR_IN_USE         ( 0 ),
        .MDDR_IN_USE         ( 0 ),
        .SDIF0_IN_USE        ( 0 ),
        .SDIF0_PCIE          ( 0 ),
        .SDIF0_PCIE_HOTRESET ( 1 ),
        .SDIF0_PCIE_L2P2     ( 1 ),
        .SDIF1_IN_USE        ( 0 ),
        .SDIF1_PCIE          ( 0 ),
        .SDIF1_PCIE_HOTRESET ( 1 ),
        .SDIF1_PCIE_L2P2     ( 1 ),
        .SDIF2_IN_USE        ( 0 ),
        .SDIF2_PCIE          ( 0 ),
        .SDIF2_PCIE_HOTRESET ( 1 ),
        .SDIF2_PCIE_L2P2     ( 1 ),
        .SDIF3_IN_USE        ( 0 ),
        .SDIF3_PCIE          ( 0 ),
        .SDIF3_PCIE_HOTRESET ( 1 ),
        .SDIF3_PCIE_L2P2     ( 1 ) )
CORERESETP_0(
        // Inputs
        .RESET_N_M2F                    ( my_mss_MSS_TMP_0_MSS_RESET_N_M2F ),
        .FIC_2_APB_M_PRESET_N           ( my_mss_MSS_TMP_0_FIC_2_APB_M_PRESET_N ),
        .POWER_ON_RESET_N               ( POWER_ON_RESET_N_net_0 ),
        .FAB_RESET_N                    ( FAB_RESET_N ),
        .RCOSC_25_50MHZ                 ( FABOSC_0_RCOSC_25_50MHZ_O2F ),
        .CLK_BASE                       ( FIC_0_CLK_net_0 ),
        .CLK_LTSSM                      ( GND_net ), // tied to 1'b0 from definition
        .FPLL_LOCK                      ( VCC_net ), // tied to 1'b1 from definition
        .SDIF0_SPLL_LOCK                ( VCC_net ), // tied to 1'b1 from definition
        .SDIF1_SPLL_LOCK                ( VCC_net ), // tied to 1'b1 from definition
        .SDIF2_SPLL_LOCK                ( VCC_net ), // tied to 1'b1 from definition
        .SDIF3_SPLL_LOCK                ( VCC_net ), // tied to 1'b1 from definition
        .CONFIG1_DONE                   ( VCC_net ),
        .CONFIG2_DONE                   ( VCC_net ),
        .SDIF0_PERST_N                  ( VCC_net ), // tied to 1'b1 from definition
        .SDIF1_PERST_N                  ( VCC_net ), // tied to 1'b1 from definition
        .SDIF2_PERST_N                  ( VCC_net ), // tied to 1'b1 from definition
        .SDIF3_PERST_N                  ( VCC_net ), // tied to 1'b1 from definition
        .SDIF0_PSEL                     ( GND_net ), // tied to 1'b0 from definition
        .SDIF0_PWRITE                   ( VCC_net ), // tied to 1'b1 from definition
        .SDIF1_PSEL                     ( GND_net ), // tied to 1'b0 from definition
        .SDIF1_PWRITE                   ( VCC_net ), // tied to 1'b1 from definition
        .SDIF2_PSEL                     ( GND_net ), // tied to 1'b0 from definition
        .SDIF2_PWRITE                   ( VCC_net ), // tied to 1'b1 from definition
        .SDIF3_PSEL                     ( GND_net ), // tied to 1'b0 from definition
        .SDIF3_PWRITE                   ( VCC_net ), // tied to 1'b1 from definition
        .SOFT_EXT_RESET_OUT             ( GND_net ), // tied to 1'b0 from definition
        .SOFT_RESET_F2M                 ( GND_net ), // tied to 1'b0 from definition
        .SOFT_M3_RESET                  ( GND_net ), // tied to 1'b0 from definition
        .SOFT_MDDR_DDR_AXI_S_CORE_RESET ( GND_net ), // tied to 1'b0 from definition
        .SOFT_FDDR_CORE_RESET           ( GND_net ), // tied to 1'b0 from definition
        .SOFT_SDIF0_PHY_RESET           ( GND_net ), // tied to 1'b0 from definition
        .SOFT_SDIF0_CORE_RESET          ( GND_net ), // tied to 1'b0 from definition
        .SOFT_SDIF0_0_CORE_RESET        ( GND_net ), // tied to 1'b0 from definition
        .SOFT_SDIF0_1_CORE_RESET        ( GND_net ), // tied to 1'b0 from definition
        .SOFT_SDIF1_PHY_RESET           ( GND_net ), // tied to 1'b0 from definition
        .SOFT_SDIF1_CORE_RESET          ( GND_net ), // tied to 1'b0 from definition
        .SOFT_SDIF2_PHY_RESET           ( GND_net ), // tied to 1'b0 from definition
        .SOFT_SDIF2_CORE_RESET          ( GND_net ), // tied to 1'b0 from definition
        .SOFT_SDIF3_PHY_RESET           ( GND_net ), // tied to 1'b0 from definition
        .SOFT_SDIF3_CORE_RESET          ( GND_net ), // tied to 1'b0 from definition
        .SDIF0_PRDATA                   ( SDIF0_PRDATA_const_net_0 ), // tied to 32'h00000000 from definition
        .SDIF1_PRDATA                   ( SDIF1_PRDATA_const_net_0 ), // tied to 32'h00000000 from definition
        .SDIF2_PRDATA                   ( SDIF2_PRDATA_const_net_0 ), // tied to 32'h00000000 from definition
        .SDIF3_PRDATA                   ( SDIF3_PRDATA_const_net_0 ), // tied to 32'h00000000 from definition
        // Outputs
        .MSS_HPMS_READY                 ( MSS_READY_net_0 ),
        .DDR_READY                      (  ),
        .SDIF_READY                     (  ),
        .RESET_N_F2M                    ( CORERESETP_0_RESET_N_F2M ),
        .M3_RESET_N                     (  ),
        .EXT_RESET_OUT                  (  ),
        .MDDR_DDR_AXI_S_CORE_RESET_N    (  ),
        .FDDR_CORE_RESET_N              (  ),
        .SDIF0_CORE_RESET_N             (  ),
        .SDIF0_0_CORE_RESET_N           (  ),
        .SDIF0_1_CORE_RESET_N           (  ),
        .SDIF0_PHY_RESET_N              (  ),
        .SDIF1_CORE_RESET_N             (  ),
        .SDIF1_PHY_RESET_N              (  ),
        .SDIF2_CORE_RESET_N             (  ),
        .SDIF2_PHY_RESET_N              (  ),
        .SDIF3_CORE_RESET_N             (  ),
        .SDIF3_PHY_RESET_N              (  ),
        .SDIF_RELEASED                  (  ),
        .INIT_DONE                      ( INIT_DONE_net_0 ) 
        );

//--------my_mss_FABOSC_0_OSC   -   Actel:SgCore:OSC:2.0.101
my_mss_FABOSC_0_OSC FABOSC_0(
        // Inputs
        .XTL                ( GND_net ), // tied to 1'b0 from definition
        // Outputs
        .RCOSC_25_50MHZ_CCC ( FABOSC_0_RCOSC_25_50MHZ_CCC_OUT_RCOSC_25_50MHZ_CCC ),
        .RCOSC_25_50MHZ_O2F ( FABOSC_0_RCOSC_25_50MHZ_O2F ),
        .RCOSC_1MHZ_CCC     (  ),
        .RCOSC_1MHZ_O2F     (  ),
        .XTLOSC_CCC         (  ),
        .XTLOSC_O2F         (  ) 
        );

//--------my_mss_MSS
my_mss_MSS my_mss_MSS_0(
        // Inputs
        .MCCC_CLK_BASE          ( FIC_0_CLK_net_0 ),
        .MCCC_CLK_BASE_PLL_LOCK ( FIC_0_LOCK_net_0 ),
        .MSS_RESET_N_F2M        ( CORERESETP_0_RESET_N_F2M ),
        .MMUART_0_RXD_F2M       ( MMUART_0_RXD_F2M ),
        .FIC_0_AHB_S_HREADY     ( CoreAHBLite_0_AHBmslave16_HREADY ),
        .FIC_0_AHB_S_HWRITE     ( CoreAHBLite_0_AHBmslave16_HWRITE ),
        .FIC_0_AHB_S_HMASTLOCK  ( CoreAHBLite_0_AHBmslave16_HMASTLOCK ),
        .FIC_0_AHB_S_HSEL       ( CoreAHBLite_0_AHBmslave16_HSELx ),
        .FIC_2_APB_M_PREADY     ( VCC_net ), // tied to 1'b1 from definition
        .FIC_2_APB_M_PSLVERR    ( GND_net ), // tied to 1'b0 from definition
        .M3_RESET_N             ( M3_RESET_N ),
        .FIC_0_AHB_S_HADDR      ( CoreAHBLite_0_AHBmslave16_HADDR ),
        .FIC_0_AHB_S_HWDATA     ( CoreAHBLite_0_AHBmslave16_HWDATA ),
        .FIC_0_AHB_S_HSIZE      ( CoreAHBLite_0_AHBmslave16_HSIZE_0 ),
        .FIC_0_AHB_S_HTRANS     ( CoreAHBLite_0_AHBmslave16_HTRANS ),
        .FIC_2_APB_M_PRDATA     ( FIC_2_APB_M_PRDATA_const_net_0 ), // tied to 32'h00000000 from definition
        // Outputs
        .MSS_RESET_N_M2F        ( my_mss_MSS_TMP_0_MSS_RESET_N_M2F ),
        .MMUART_0_TXD_M2F       ( MMUART_0_TXD_M2F_net_0 ),
        .FIC_0_AHB_S_HRESP      ( CoreAHBLite_0_AHBmslave16_HRESP ),
        .FIC_0_AHB_S_HREADYOUT  ( CoreAHBLite_0_AHBmslave16_HREADYOUT ),
        .FIC_2_APB_M_PRESET_N   ( my_mss_MSS_TMP_0_FIC_2_APB_M_PRESET_N ),
        .FIC_2_APB_M_PCLK       (  ),
        .FIC_2_APB_M_PWRITE     (  ),
        .FIC_2_APB_M_PENABLE    (  ),
        .FIC_2_APB_M_PSEL       (  ),
        .FIC_0_AHB_S_HRDATA     ( CoreAHBLite_0_AHBmslave16_HRDATA ),
        .FIC_2_APB_M_PADDR      (  ),
        .FIC_2_APB_M_PWDATA     (  ) 
        );

//--------SYSRESET
SYSRESET SYSRESET_POR(
        // Inputs
        .DEVRST_N         ( DEVRST_N ),
        // Outputs
        .POWER_ON_RESET_N ( POWER_ON_RESET_N_net_0 ) 
        );


endmodule
