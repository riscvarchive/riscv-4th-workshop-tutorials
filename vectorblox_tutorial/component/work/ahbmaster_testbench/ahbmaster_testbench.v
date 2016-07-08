//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Mon Mar 03 15:04:09 2014
// Version: v11.3 11.3.0.111
//////////////////////////////////////////////////////////////////////

`timescale 1 ns/100 ps

// ahbmaster_testbench
module ahbmaster_testbench(
    // Outputs
    HADDR,
    HBURST,
    HPROT,
    HSIZE,
    HTRANS,
    HWDATA,
    HWRITE,
    RESP_err,
    ahb_busy,
    ram_init_done
);

//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output [31:0] HADDR;
output [2:0]  HBURST;
output [3:0]  HPROT;
output [2:0]  HSIZE;
output [1:0]  HTRANS;
output [31:0] HWDATA;
output        HWRITE;
output [1:0]  RESP_err;
output        ahb_busy;
output        ram_init_done;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire          ahb_busy_net_0;
wire          CLK_GEN_0_CLK;
wire   [31:0] HADDR_net_0;
wire   [2:0]  HBURST_net_0;
wire   [3:0]  HPROT_net_0;
wire   [2:0]  HSIZE_net_0;
wire   [1:0]  HTRANS_net_0;
wire   [31:0] HWDATA_net_0;
wire          HWRITE_net_0;
wire          ram_init_done_net_0;
wire          RESET_GEN_0_RESET;
wire   [1:0]  RESP_err_net_0;
wire          ahb_busy_net_1;
wire          HWRITE_net_1;
wire          ram_init_done_net_1;
wire   [2:0]  HSIZE_net_1;
wire   [2:0]  HBURST_net_1;
wire   [31:0] HWDATA_net_1;
wire   [1:0]  HTRANS_net_1;
wire   [31:0] HADDR_net_1;
wire   [3:0]  HPROT_net_1;
wire   [1:0]  RESP_err_net_1;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire   [31:0] HRDATA_const_net_0;
wire          VCC_net;
wire   [1:0]  HRESP_const_net_0;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign HRDATA_const_net_0 = 32'hF000F000;
assign VCC_net            = 1'b1;
assign HRESP_const_net_0  = 2'h0;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign ahb_busy_net_1      = ahb_busy_net_0;
assign ahb_busy            = ahb_busy_net_1;
assign HWRITE_net_1        = HWRITE_net_0;
assign HWRITE              = HWRITE_net_1;
assign ram_init_done_net_1 = ram_init_done_net_0;
assign ram_init_done       = ram_init_done_net_1;
assign HSIZE_net_1         = HSIZE_net_0;
assign HSIZE[2:0]          = HSIZE_net_1;
assign HBURST_net_1        = HBURST_net_0;
assign HBURST[2:0]         = HBURST_net_1;
assign HWDATA_net_1        = HWDATA_net_0;
assign HWDATA[31:0]        = HWDATA_net_1;
assign HTRANS_net_1        = HTRANS_net_0;
assign HTRANS[1:0]         = HTRANS_net_1;
assign HADDR_net_1         = HADDR_net_0;
assign HADDR[31:0]         = HADDR_net_1;
assign HPROT_net_1         = HPROT_net_0;
assign HPROT[3:0]          = HPROT_net_1;
assign RESP_err_net_1      = RESP_err_net_0;
assign RESP_err[1:0]       = RESP_err_net_1;
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------AHBMASTER_FIC
AHBMASTER_FIC #( 
        .Data_size       ( 8 ),
        .Idle            ( 0 ),
        .NVM_fab_ac_0    ( 1 ),
        .NVM_fab_ac_1    ( 2 ),
        .NVM_fab_ac_2    ( 3 ),
        .NVM_ready_0     ( 4 ),
        .NVM_ready_1     ( 5 ),
        .NVM_ready_2     ( 6 ),
        .NVM_ready_check ( 7 ),
        .Read_NVM_0      ( 8 ),
        .Read_NVM_1      ( 9 ),
        .Read_NVM_2      ( 10 ),
        .Write_RAM_0     ( 11 ),
        .Write_RAM_1     ( 12 ),
        .Write_RAM_2     ( 13 ),
        .Write_RAM_3     ( 14 ),
        .Write_RAM_4     ( 15 ),
        .Write_RAM_5     ( 16 ),
        .Write_RAM_6     ( 17 ),
        .Write_RAM_7     ( 18 ),
        .Write_RAM_8     ( 19 ),
        .Write_RAM_9     ( 20 ),
        .Write_RAM_10    ( 21 ),
        .Write_RAM_11    ( 22 ) )
AHBMASTER_FIC_0(
        // Inputs
        .HCLK          ( CLK_GEN_0_CLK ),
        .HRESETn       ( RESET_GEN_0_RESET ),
        .HRDATA        ( HRDATA_const_net_0 ),
        .HREADY        ( VCC_net ),
        .HRESP         ( HRESP_const_net_0 ),
        .START         ( VCC_net ),
        // Outputs
        .HADDR         ( HADDR_net_0 ),
        .HTRANS        ( HTRANS_net_0 ),
        .HWRITE        ( HWRITE_net_0 ),
        .HSIZE         ( HSIZE_net_0 ),
        .HBURST        ( HBURST_net_0 ),
        .HPROT         ( HPROT_net_0 ),
        .HWDATA        ( HWDATA_net_0 ),
        .RESP_err      ( RESP_err_net_0 ),
        .ahb_busy      ( ahb_busy_net_0 ),
        .ram_init_done ( ram_init_done_net_0 ) 
        );

//--------CLK_GEN   -   Actel:Simulation:CLK_GEN:1.0.1
CLK_GEN #( 
        .CLK_PERIOD ( 10000 ),
        .DUTY_CYCLE ( 50 ) )
CLK_GEN_0(
        // Outputs
        .CLK ( CLK_GEN_0_CLK ) 
        );

//--------RESET_GEN   -   Actel:Simulation:RESET_GEN:1.0.1
RESET_GEN #( 
        .DELAY       ( 1000 ),
        .LOGIC_LEVEL ( 0 ) )
RESET_GEN_0(
        // Outputs
        .RESET ( RESET_GEN_0_RESET ) 
        );


endmodule
