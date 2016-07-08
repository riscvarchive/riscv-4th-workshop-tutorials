`timescale 1 ns/100 ps
module mux_blk(
  rd_enable_user,wr_enable_user,
  wclk_user, rclk_user,
  raddr_user, waddr_user,
  wdata_user, rdata_user,
  
  rd_enable_init, wr_enable_init,
  wclk_init, rclk_init,
  raddr_init, waddr_init,
  mem_data_in_init, mem_data_out_init,
  
  rd_en, wr_en,
  wclk, rclk,
  raddr, waddr,
  wdata, rdata,
  
  sel);

parameter DATA_WIDTH = 8; // data width 
parameter ADDR_WIDTH = 8; // data width 


input rd_enable_user;
input wr_enable_user;
input wclk_user, rclk_user;
input [ADDR_WIDTH-3:0] raddr_user, waddr_user;
input [DATA_WIDTH-1:0] wdata_user;
output  [DATA_WIDTH-1:0] rdata_user;

input rd_enable_init;
input wr_enable_init;
input wclk_init, rclk_init;
input [ADDR_WIDTH-3:0] raddr_init, waddr_init;
input [DATA_WIDTH-1:0] mem_data_in_init;
output  [DATA_WIDTH-1:0] mem_data_out_init;

output rd_en;
output wr_en;
output wclk, rclk;
output [ADDR_WIDTH-3:0] raddr, waddr;
output [DATA_WIDTH-1:0] wdata;
input  [DATA_WIDTH-1:0] rdata;

input sel;


assign 	rd_en 	= (sel) ? rd_enable_user : rd_enable_init;
assign 	wr_en 	= (sel) ? wr_enable_user : wr_enable_init;
assign 	wclk 	= (sel) ? wclk_user : wclk_init;
assign 	rclk 	= (sel) ? rclk_user : rclk_init;
assign 	raddr 	= (sel) ? raddr_user : raddr_init;
assign 	waddr 	= (sel) ? waddr_user : waddr_init;
assign 	wdata 	= (sel) ? wdata_user : mem_data_in_init;
assign 	mem_data_out_init = rdata;
assign 	rdata_user = rdata;


    
endmodule