//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Fri Mar 07 11:21:06 2014
// Version: v11.3 11.3.0.112
//////////////////////////////////////////////////////////////////////

`timescale 1 ns/100 ps

// my_testbench
module my_testbench(
    // Inputs
    MMUART_0_RXD_F2M,
    // Outputs
    Clock_CCC,
    INT_DONE,
    MMUART_0_TXD_M2F,
    RESP_err,
    ahb_busy,
    ram_init_done,
    rdata_user
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input        MMUART_0_RXD_F2M;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output       Clock_CCC;
output       INT_DONE;
output       MMUART_0_TXD_M2F;
output [1:0] RESP_err;
output       ahb_busy;
output       ram_init_done;
output [7:0] rdata_user;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire         ahb_busy_net_0;
wire         CLK_GEN_0_CLK;
wire         Clock_CCC_net_0;
wire         INT_DONE_net_0;
wire         MMUART_0_RXD_F2M;
wire         MMUART_0_TXD_M2F_0;
wire   [5:0] my_cnt6_0_Q;
wire   [7:0] my_cnt8_0_Q;
wire         ram_init_done_net_0;
wire   [7:0] rdata_user_net_0;
wire         RESET_GEN_0_RESET;
wire   [1:0] RESP_err_net_0;
wire         Top_Fabric_Master_0_SEL;
wire         user_rd_wr_0_rd_enable_user;
wire         user_rd_wr_0_wr_enable_user;
wire         ram_init_done_net_1;
wire         ahb_busy_net_1;
wire         INT_DONE_net_1;
wire         Clock_CCC_net_1;
wire   [7:0] rdata_user_net_1;
wire   [1:0] RESP_err_net_1;
wire         MMUART_0_TXD_M2F_0_net_0;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign ram_init_done_net_1      = ram_init_done_net_0;
assign ram_init_done            = ram_init_done_net_1;
assign ahb_busy_net_1           = ahb_busy_net_0;
assign ahb_busy                 = ahb_busy_net_1;
assign INT_DONE_net_1           = INT_DONE_net_0;
assign INT_DONE                 = INT_DONE_net_1;
assign Clock_CCC_net_1          = Clock_CCC_net_0;
assign Clock_CCC                = Clock_CCC_net_1;
assign rdata_user_net_1         = rdata_user_net_0;
assign rdata_user[7:0]          = rdata_user_net_1;
assign RESP_err_net_1           = RESP_err_net_0;
assign RESP_err[1:0]            = RESP_err_net_1;
assign MMUART_0_TXD_M2F_0_net_0 = MMUART_0_TXD_M2F_0;
assign MMUART_0_TXD_M2F         = MMUART_0_TXD_M2F_0_net_0;
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------CLK_GEN   -   Actel:Simulation:CLK_GEN:1.0.1
CLK_GEN #( 
        .CLK_PERIOD ( 10000 ),
        .DUTY_CYCLE ( 50 ) )
CLK_GEN_0(
        // Outputs
        .CLK ( CLK_GEN_0_CLK ) 
        );

//--------my_cnt6
my_cnt6 my_cnt6_0(
        // Inputs
        .Clock  ( CLK_GEN_0_CLK ),
        .Aclr   ( RESET_GEN_0_RESET ),
        .Enable ( Top_Fabric_Master_0_SEL ),
        // Outputs
        .Q      ( my_cnt6_0_Q ) 
        );

//--------my_cnt8
my_cnt8 my_cnt8_0(
        // Inputs
        .Clock  ( CLK_GEN_0_CLK ),
        .Aclr   ( RESET_GEN_0_RESET ),
        .Enable ( Top_Fabric_Master_0_SEL ),
        // Outputs
        .Q      ( my_cnt8_0_Q ) 
        );

//--------RESET_GEN   -   Actel:Simulation:RESET_GEN:1.0.1
RESET_GEN #( 
        .DELAY       ( 1000 ),
        .LOGIC_LEVEL ( 0 ) )
RESET_GEN_0(
        // Outputs
        .RESET ( RESET_GEN_0_RESET ) 
        );

//--------Top_Fabric_Master
Top_Fabric_Master Top_Fabric_Master_0(
        // Inputs
        .rclk_user        ( CLK_GEN_0_CLK ),
        .wclk_user        ( CLK_GEN_0_CLK ),
        .wr_enable_user   ( user_rd_wr_0_wr_enable_user ),
        .rd_enable_user   ( user_rd_wr_0_rd_enable_user ),
        .MMUART_0_RXD_F2M ( MMUART_0_RXD_F2M ),
        .DEVRST_N_0       ( RESET_GEN_0_RESET ),
        .wdata_user       ( my_cnt8_0_Q ),
        .waddr_user       ( my_cnt6_0_Q ),
        .raddr_user       ( my_cnt6_0_Q ),
        // Outputs
        .SEL              ( Top_Fabric_Master_0_SEL ),
        .INT_DONE         ( INT_DONE_net_0 ),
        .Clock_CCC        ( Clock_CCC_net_0 ),
        .MMUART_0_TXD_M2F ( MMUART_0_TXD_M2F_0 ),
        .ahb_busy         ( ahb_busy_net_0 ),
        .ram_init_done    ( ram_init_done_net_0 ),
        .rdata_user       ( rdata_user_net_0 ),
        .RESP_err         ( RESP_err_net_0 ) 
        );

//--------user_rd_wr
user_rd_wr user_rd_wr_0(
        // Outputs
        .rd_enable_user ( user_rd_wr_0_rd_enable_user ),
        .wr_enable_user ( user_rd_wr_0_wr_enable_user ) 
        );


endmodule
