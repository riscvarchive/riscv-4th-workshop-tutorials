//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Mon May 30 10:51:38 2016
// Version: v11.7 11.7.0.119
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

// my_mss_top
module my_mss_top(
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
wire   [31:0] AMBA_SLAVE_0_4_PADDR;
wire          AMBA_SLAVE_0_4_PENABLE;
wire   [31:0] AMBA_SLAVE_0_PRDATAS0;
wire          AMBA_SLAVE_0_PREADYS0;
wire          AMBA_SLAVE_0_4_PSELx;
wire          AMBA_SLAVE_0_PSLVERRS0;
wire   [31:0] AMBA_SLAVE_0_4_PWDATA;
wire          AMBA_SLAVE_0_4_PWRITE;
wire          DEVRST_N;
wire          FAB_RESET_N;
wire          FIC_0_CLK_0;
wire          FIC_0_LOCK_0;
wire          INIT_DONE_net_0;
wire          M3_RESET_N;
wire          MMUART_0_RXD_F2M;
wire          MMUART_0_TXD_M2F_net_0;
wire          MSS_READY_net_0;
wire          POWER_ON_RESET_N_net_0;
wire          MMUART_0_TXD_M2F_net_1;
wire          INIT_DONE_net_1;
wire          MSS_READY_net_1;
wire          FIC_0_CLK_0_net_0;
wire          FIC_0_LOCK_0_net_0;
wire          POWER_ON_RESET_N_net_1;
wire   [31:0] AMBA_SLAVE_0_4_PADDR_net_0;
wire          AMBA_SLAVE_0_4_PSELx_net_0;
wire          AMBA_SLAVE_0_4_PENABLE_net_0;
wire          AMBA_SLAVE_0_4_PWRITE_net_0;
wire   [31:0] AMBA_SLAVE_0_4_PWDATA_net_0;
wire   [31:0] AMBA_MASTER_0_HRDATA_net_0;
wire          AMBA_MASTER_0_HREADY_net_0;
wire   [1:0]  AMBA_MASTER_0_HRESP_net_0;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign MMUART_0_TXD_M2F_net_1        = MMUART_0_TXD_M2F_net_0;
assign MMUART_0_TXD_M2F              = MMUART_0_TXD_M2F_net_1;
assign INIT_DONE_net_1               = INIT_DONE_net_0;
assign INIT_DONE                     = INIT_DONE_net_1;
assign MSS_READY_net_1               = MSS_READY_net_0;
assign MSS_READY                     = MSS_READY_net_1;
assign FIC_0_CLK_0_net_0             = FIC_0_CLK_0;
assign FIC_0_CLK                     = FIC_0_CLK_0_net_0;
assign FIC_0_LOCK_0_net_0            = FIC_0_LOCK_0;
assign FIC_0_LOCK                    = FIC_0_LOCK_0_net_0;
assign POWER_ON_RESET_N_net_1        = POWER_ON_RESET_N_net_0;
assign POWER_ON_RESET_N              = POWER_ON_RESET_N_net_1;
assign AMBA_SLAVE_0_4_PADDR_net_0    = AMBA_SLAVE_0_4_PADDR;
assign AMBA_SLAVE_0_PADDRS[31:0]     = AMBA_SLAVE_0_4_PADDR_net_0;
assign AMBA_SLAVE_0_4_PSELx_net_0    = AMBA_SLAVE_0_4_PSELx;
assign AMBA_SLAVE_0_PSELS0           = AMBA_SLAVE_0_4_PSELx_net_0;
assign AMBA_SLAVE_0_4_PENABLE_net_0  = AMBA_SLAVE_0_4_PENABLE;
assign AMBA_SLAVE_0_PENABLES         = AMBA_SLAVE_0_4_PENABLE_net_0;
assign AMBA_SLAVE_0_4_PWRITE_net_0   = AMBA_SLAVE_0_4_PWRITE;
assign AMBA_SLAVE_0_PWRITES          = AMBA_SLAVE_0_4_PWRITE_net_0;
assign AMBA_SLAVE_0_4_PWDATA_net_0   = AMBA_SLAVE_0_4_PWDATA;
assign AMBA_SLAVE_0_PWDATAS[31:0]    = AMBA_SLAVE_0_4_PWDATA_net_0;
assign AMBA_MASTER_0_HRDATA_net_0    = AMBA_MASTER_0_HRDATA;
assign AMBA_MASTER_0_HRDATA_M0[31:0] = AMBA_MASTER_0_HRDATA_net_0;
assign AMBA_MASTER_0_HREADY_net_0    = AMBA_MASTER_0_HREADY;
assign AMBA_MASTER_0_HREADY_M0       = AMBA_MASTER_0_HREADY_net_0;
assign AMBA_MASTER_0_HRESP_net_0     = AMBA_MASTER_0_HRESP;
assign AMBA_MASTER_0_HRESP_M0[1:0]   = AMBA_MASTER_0_HRESP_net_0;
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------my_mss
my_mss my_mss_0(
        // Inputs
        .FAB_RESET_N                ( FAB_RESET_N ),
        .AMBA_SLAVE_0_PREADYS0      ( AMBA_SLAVE_0_PREADYS0 ),
        .AMBA_SLAVE_0_PSLVERRS0     ( AMBA_SLAVE_0_PSLVERRS0 ),
        .AMBA_MASTER_0_HWRITE_M0    ( AMBA_MASTER_0_HWRITE_M0 ),
        .AMBA_MASTER_0_HMASTLOCK_M0 ( AMBA_MASTER_0_HMASTLOCK_M0 ),
        .DEVRST_N                   ( DEVRST_N ),
        .MMUART_0_RXD_F2M           ( MMUART_0_RXD_F2M ),
        .AMBA_SLAVE_0_PRDATAS0      ( AMBA_SLAVE_0_PRDATAS0 ),
        .AMBA_MASTER_0_HADDR_M0     ( AMBA_MASTER_0_HADDR_M0 ),
        .AMBA_MASTER_0_HTRANS_M0    ( AMBA_MASTER_0_HTRANS_M0 ),
        .AMBA_MASTER_0_HSIZE_M0     ( AMBA_MASTER_0_HSIZE_M0 ),
        .AMBA_MASTER_0_HBURST_M0    ( AMBA_MASTER_0_HBURST_M0 ),
        .AMBA_MASTER_0_HPROT_M0     ( AMBA_MASTER_0_HPROT_M0 ),
        .AMBA_MASTER_0_HWDATA_M0    ( AMBA_MASTER_0_HWDATA_M0 ),
        .M3_RESET_N                 ( M3_RESET_N ),
        // Outputs
        .POWER_ON_RESET_N           ( POWER_ON_RESET_N_net_0 ),
        .INIT_DONE                  ( INIT_DONE_net_0 ),
        .AMBA_SLAVE_0_PSELS0        ( AMBA_SLAVE_0_4_PSELx ),
        .AMBA_SLAVE_0_PENABLES      ( AMBA_SLAVE_0_4_PENABLE ),
        .AMBA_SLAVE_0_PWRITES       ( AMBA_SLAVE_0_4_PWRITE ),
        .FIC_0_CLK                  ( FIC_0_CLK_0 ),
        .FIC_0_LOCK                 ( FIC_0_LOCK_0 ),
        .MSS_READY                  ( MSS_READY_net_0 ),
        .AMBA_MASTER_0_HREADY_M0    ( AMBA_MASTER_0_HREADY ),
        .MMUART_0_TXD_M2F           ( MMUART_0_TXD_M2F_net_0 ),
        .AMBA_SLAVE_0_PADDRS        ( AMBA_SLAVE_0_4_PADDR ),
        .AMBA_SLAVE_0_PWDATAS       ( AMBA_SLAVE_0_4_PWDATA ),
        .AMBA_MASTER_0_HRDATA_M0    ( AMBA_MASTER_0_HRDATA ),
        .AMBA_MASTER_0_HRESP_M0     ( AMBA_MASTER_0_HRESP ) 
        );


endmodule
