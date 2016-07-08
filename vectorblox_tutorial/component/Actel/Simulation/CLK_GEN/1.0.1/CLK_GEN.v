`timescale 1ps/1fs
module CLK_GEN(CLK); 

   parameter CLK_PERIOD  = 10000;  // 10 ns 
   parameter DUTY_CYCLE  = 50; //50% duty cycle
   parameter TCLK_HIGH = (CLK_PERIOD*DUTY_CYCLE/100.0); 
   parameter TCLK_LOW = (CLK_PERIOD-TCLK_HIGH); 	
  
   output CLK;

   reg CLK; 

   initial 
      CLK = 1'b0; 

   always 
   begin 
      #TCLK_LOW; 

      CLK = 1'b1; 

      #TCLK_HIGH; 

      CLK = 1'b0; 
   end  

endmodule