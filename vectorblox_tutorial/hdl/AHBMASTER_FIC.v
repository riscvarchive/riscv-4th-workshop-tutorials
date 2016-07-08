// AHBMASTER_FIC.v
`timescale 1 ns / 100 ps

module AHBMASTER_FIC (
// Generic Signals
input      wire         HCLK,
input      wire         HRESETn,

// AHB Side Interfacing with FIC 
output     reg   [31:0] HADDR,
output     reg   [1:0]  HTRANS,
output     reg          HWRITE,
output     reg   [2:0]  HSIZE,
output     wire  [2:0]  HBURST,
output     wire  [3:0]  HPROT,
output     reg   [31:0] HWDATA,

input      wire  [31:0] HRDATA,
input      wire         HREADY,
input      wire  [1:0]  HRESP,


input      wire         START, // will be connected to system power up, now it used insert wait state so that BAM can write to eNVM

output           [1:0]  RESP_err,
output     reg          ahb_busy,
output     reg          ram_init_done
);


// AHB FSM States
reg [4:0] ahb_fsm_current_state;
parameter [4:0] Idle 			= 5'b00000;
parameter [4:0] NVM_fab_ac_0 	= 5'b00001; //write to eNVM CTRL reg to get access from fabric
parameter [4:0] NVM_fab_ac_1 	= 5'b00010;
parameter [4:0] NVM_fab_ac_2 	= 5'b00011;

parameter [4:0] NVM_ac_read_0 	= 5'b00100; //check to eNVM staus for ready bit
parameter [4:0] NVM_ac_read_1 	= 5'b00101;
parameter [4:0] NVM_ac_read_2 	= 5'b00110;
parameter [4:0] NVM_ac_check 	= 5'b00111;

parameter [4:0] NVM_ready_0 	= 5'b01000; //check to eNVM staus for ready bit
parameter [4:0] NVM_ready_1 	= 5'b01001;
parameter [4:0] NVM_ready_2 	= 5'b01010;
parameter [4:0] NVM_ready_check = 5'b01011;

parameter [4:0] Read_NVM_0	 	= 5'b01100; //read eNVM data
parameter [4:0] Read_NVM_1 		= 5'b01101;
parameter [4:0] Read_NVM_2 		= 5'b01110;
parameter [4:0] Write_RAM_0 	= 5'b01111; //write to SRAM 1st byte
parameter [4:0] Write_RAM_1 	= 5'b10000;
parameter [4:0] Write_RAM_2 	= 5'b10001;
parameter [4:0] Write_RAM_3 	= 5'b10010; //write to SRAM 2nd byte
parameter [4:0] Write_RAM_4 	= 5'b10011; 
parameter [4:0] Write_RAM_5 	= 5'b10100;
parameter [4:0] Write_RAM_6 	= 5'b10101; //write to SRAM 3rd byte
parameter [4:0] Write_RAM_7 	= 5'b10110;
parameter [4:0] Write_RAM_8 	= 5'b10111;
parameter [4:0] Write_RAM_9 	= 5'b11000; //write to SRAM 4th byte
parameter [4:0] Write_RAM_10 	= 5'b11001; 
parameter [4:0] Write_RAM_11 	= 5'b11010;
// new states
parameter [4:0] Done_0          = 5'b11011;
parameter [4:0] Done_1          = 5'b11100;

wire   [1:0] HSIZE_int;
reg   init_done; // used to check when initlization is done, can be used for interrupt
reg   [31:0] NVM_ADDR;  //hold eNVM address
reg   [31:0] RAM_ADDR;  //hold RAM address
reg   [31:0] NVM_STATUS;  //hold eNVm status address
reg   [31:0] NVM_CTRL;  //hold eNVm ctrl address
reg   [31:0] DATAOUT;  // hold nvm read data

assign RESP_err = HRESP;
assign HBURST = 3'b000;
assign HPROT  = 4'b0011;

// since the current coreahblite is 32 bit, we are using Hsize=10 (32-bit), but can be changed
parameter Data_size	= 8;

generate
    if (Data_size == 32)  
        assign HSIZE_int  = 2'b10;  
    else if (Data_size == 16) 
        assign HSIZE_int  = 2'b01;
    else if (Data_size == 8) 
        assign HSIZE_int  = 2'b00;
endgenerate

// FSM That Acts as Master on AHB Bus
// Assuming only Non-Sequential & Idle
always@(posedge HCLK, negedge HRESETn)
begin

	if(HRESETn  == 1'b0)
	    begin
	     HADDR               <=  32'h00000000;
	     HTRANS              <=  2'b00;  //Idle
	     HWRITE              <=  1'b0;
	     HSIZE               <=  3'b010; // 32 Bit Mode
	     HWDATA              <=  32'h00000000;
	     DATAOUT             <=  32'h00000000;
	     ahb_fsm_current_state   <=  Idle;
         ahb_busy                <=  1'b0;
 		 NVM_ADDR            <=  32'h60000800;
 		 NVM_CTRL            <=  32'h600801FC;
 		 NVM_STATUS          <=  32'h60080120;	
		 RAM_ADDR            <=  32'h10000000;
		 init_done           <=  1'b0;
         ram_init_done		 <=  1'b0;
	    end

	else
    	begin
	        case (ahb_fsm_current_state)
	      
	        Idle: //0x00
	            begin
					if (( init_done  == 1'b0) && ( START  == 1'b1))
	                  begin
	                    ahb_fsm_current_state       <=  NVM_fab_ac_0;
                        HADDR                       <=  NVM_CTRL;
                        ahb_busy                    <=  1'b1;
	                  end
	                else
	                  begin
	                    ahb_fsm_current_state       <=  Idle;
						ahb_busy                    <=  1'b0;
	                  end
	            end

			NVM_fab_ac_0: //0x01 store the address+control signals and apply to coreahblite
	              begin
	                    HTRANS                  <=  2'b10;
	                    HSIZE                   <=  2'b10;
	                    HWRITE                  <=  1'b1;
	     				HWDATA              	<=  32'h00000001;
	                    ahb_fsm_current_state   <=  NVM_fab_ac_1;
	              end
	         
			NVM_fab_ac_1: //0x02
	              begin                   
	               HTRANS                   <=  2'b00;
					if ( HREADY  == 1'b1) // go to next state
                     begin
	                    ahb_fsm_current_state    <=  NVM_fab_ac_2;
                     end 
                   else   //keep the address+control signals when slave is not ready yet
                     begin   
	                    ahb_fsm_current_state    <=  NVM_fab_ac_1;
                     end
                  end
             
			NVM_fab_ac_2: //0x03                         
	              begin
                   if ( HREADY  == 1'b1)         //read the data and start ram write state
	                 begin                 
	                    ahb_fsm_current_state    <=  NVM_ac_read_0;
                        HADDR                    <=  NVM_CTRL;
	                 end
	               else  //waiting slave to be ready
	                 begin
	                    ahb_fsm_current_state    <=  NVM_fab_ac_2;
	                  end                      
	              end

			NVM_ac_read_0: //0x04 store the address+control signals and apply to coreahblite
	              begin
	                    HTRANS                  <=  2'b10;
	                    HSIZE                   <=  2'b10;
	                    HWRITE                  <=  1'b0;
	                    ahb_fsm_current_state   <=  NVM_ac_read_1;
	              end

	         NVM_ac_read_1: //0x05
	              begin                   
	               HTRANS                   <=  2'b00;
					if ( HREADY  == 1'b1) // go to next state
                     begin
	                    ahb_fsm_current_state    <=  NVM_ac_read_2;
                     end 
                   else   //keep the address+control signals when slave is not ready yet
                     begin   
	                    ahb_fsm_current_state    <=  NVM_ac_read_1;
                     end
                  end

             NVM_ac_read_2: //0x06                         
	              begin
                   if ( HREADY  == 1'b1)         //read the data and start ram write state
	                 begin
	                    DATAOUT                  <=  HRDATA;                     
	                    ahb_fsm_current_state    <=  NVM_ac_check;
	                 end
	               else  //waiting slave to be ready
	                 begin
	                    ahb_fsm_current_state    <=  NVM_ac_read_2;
	                  end                      
	              end

             NVM_ac_check : //0x07                         
	              begin
                   if ( DATAOUT[2:0]  == 3'b110)         //read the data and start ram write state
	                 begin                   
	                    ahb_fsm_current_state    <=  NVM_ready_0;
                        HADDR                    <=  NVM_STATUS;
	                 end
	               else  //waiting slave to be ready
	                 begin
	                    ahb_fsm_current_state    <=  NVM_fab_ac_0;
                        HADDR                    <=  NVM_CTRL;
	                  end                      
	              end

			NVM_ready_0: //0x08 store the address+control signals and apply to coreahblite
	              begin
	                    HTRANS                  <=  2'b10;
	                    HSIZE                   <=  2'b10;
	                    HWRITE                  <=  1'b0;
	                    ahb_fsm_current_state   <=  NVM_ready_1;
	              end
	         NVM_ready_1: //0x09
	              begin                   
	               HTRANS                   <=  2'b00;
					if ( HREADY  == 1'b1) // go to next state
                     begin
	                    ahb_fsm_current_state    <=  NVM_ready_2;
                     end 
                   else   //keep the address+control signals when slave is not ready yet
                     begin   
	                    ahb_fsm_current_state    <=  NVM_ready_1;
                     end
                  end
             NVM_ready_2: //0x0a                         
	              begin
                   if ( HREADY  == 1'b1)         //read the data and start ram write state
	                 begin
	                    DATAOUT                  <=  HRDATA;                     
	                    ahb_fsm_current_state    <=  NVM_ready_check;
	                 end
	               else  //waiting slave to be ready
	                 begin
	                    ahb_fsm_current_state    <=  NVM_ready_2;
	                  end                      
	              end

             NVM_ready_check: //0x0b                         
	              begin
                   if ( DATAOUT[0]  == 1'b1)         //read the data and start ram write state
	                 begin                   
	                    ahb_fsm_current_state    <=  Read_NVM_0;
                        HADDR                    <=  NVM_ADDR;
	                 end
	               else  //waiting slave to be ready
	                 begin
	                    ahb_fsm_current_state    <=  NVM_ready_0;
                        HADDR                    <=  NVM_STATUS;
	                  end                      
	              end
        
			Read_NVM_0: //0x0c store the address+control signals and apply to coreahblite
	              begin
	                    HTRANS                  <=  2'b10;
	                    HSIZE                   <=  2'b10;
	                    HWRITE                  <=  1'b0;
	                    ahb_fsm_current_state   <=  Read_NVM_1;
	              end
	         Read_NVM_1: //0x0d
	              begin                   
	               HTRANS                   <=  2'b00;
					if ( HREADY  == 1'b1) // go to next state
                     begin
	                    ahb_fsm_current_state    <=  Read_NVM_2;
                     end 
                   else   //keep the address+control signals when slave is not ready yet
                     begin   
	                    ahb_fsm_current_state    <=  Read_NVM_1;
                     end
                  end
             Read_NVM_2: //0x0e                         
	              begin
                   if ( HREADY  == 1'b1)         //read the data and start ram write state
	                 begin
	                    DATAOUT                  <=  HRDATA;	                         
	                    ahb_fsm_current_state    <=  Write_RAM_0;
	                 end
	               else  //waiting slave to be ready
	                 begin
	                    ahb_fsm_current_state    <=  Read_NVM_2;
	                  end                      
	              end			

			Write_RAM_0: //0x0f  store the address+control signals and apply to coreahblite
	            begin
    	            HWDATA[7:0]                 <=  DATAOUT[7:0] ;
    	            HSIZE                      	<=  HSIZE_int;
					HADDR                  	   	<=  RAM_ADDR;
    	            HWRITE                     	<=  1'b1;
    	            ahb_fsm_current_state      	<=  Write_RAM_1;
	             end
	        
            Write_RAM_1: //0x10 
                 begin
                  HTRANS                   <=  2'b10;
				  if ( HREADY  == 1'b0) //keep the address+control signals when slave is not ready yet
                    begin
                        ahb_fsm_current_state  <=  Write_RAM_1;
    	            end
                  else  //send the data+go to next state, doesn't need to keep the controls active
                    begin
                        ahb_fsm_current_state  <=  Write_RAM_2;
                    end
                 end
             
			Write_RAM_2: //0x11
    	         begin                
				   HTRANS                 <=  2'b00;
				   if ( HREADY  == 1'b0) //keep the address+control signals when slave is not ready yet
                    begin
                        ahb_fsm_current_state  <=  Write_RAM_2;
    	            end
                  else  //send the data+go to next state, doesn't need to keep the controls active
                    begin
                        ahb_fsm_current_state  <=  Write_RAM_3;
		 				RAM_ADDR               <=  RAM_ADDR + 32'h00000004;
					end					
	              end

			Write_RAM_3: //0x12  store the address+control signals and apply to coreahblite
	            begin
    	            HWDATA[7:0]                 <=  DATAOUT[15:8] ;
    	            HSIZE                      	<=  HSIZE_int;
					HADDR                  	   	<=  RAM_ADDR;
    	            HWRITE                     	<=  1'b1;
    	            ahb_fsm_current_state      	<=  Write_RAM_4;
	             end
	        
            Write_RAM_4: //0x13 
                 begin
                  HTRANS                   <=  2'b10;
				  if ( HREADY  == 1'b0) //keep the address+control signals when slave is not ready yet
                    begin
                        ahb_fsm_current_state  <=  Write_RAM_4;
    	            end
                  else  //send the data+go to next state, doesn't need to keep the controls active
                    begin
                        ahb_fsm_current_state  <=  Write_RAM_5;
                    end
                 end
             
			Write_RAM_5: //0x14
    	         begin                
				   HTRANS                 <=  2'b00;
				   if ( HREADY  == 1'b0) //keep the address+control signals when slave is not ready yet
                    begin
                        ahb_fsm_current_state  <=  Write_RAM_5;
    	            end
                  else  //send the data+go to next state, doesn't need to keep the controls active
                    begin
                        ahb_fsm_current_state  <=  Write_RAM_6;
		 				RAM_ADDR               <=  RAM_ADDR + 32'h00000004;
					end					
	              end

			Write_RAM_6: //0x15  store the address+control signals and apply to coreahblite
	            begin
    	            HWDATA[7:0]                 <=  DATAOUT[23:16] ;
    	            HSIZE                      	<=  HSIZE_int;
					HADDR                  	   	<=  RAM_ADDR;
    	            HWRITE                     	<=  1'b1;
    	            ahb_fsm_current_state      	<=  Write_RAM_7;
	             end
	        
            Write_RAM_7: //0x16 
                 begin
                  HTRANS                   <=  2'b10;
				  if ( HREADY  == 1'b0) //keep the address+control signals when slave is not ready yet
                    begin
                        ahb_fsm_current_state  <=  Write_RAM_7;
    	            end
                  else  //send the data+go to next state, doesn't need to keep the controls active
                    begin
                        ahb_fsm_current_state  <=  Write_RAM_8;
                    end
                 end
             
			Write_RAM_8: //0x17
    	         begin                
				   HTRANS                 <=  2'b00;
				   if ( HREADY  == 1'b0) //keep the address+control signals when slave is not ready yet
                    begin
                        ahb_fsm_current_state  <=  Write_RAM_8;
    	            end
                  else  //send the data+go to next state, doesn't need to keep the controls active
                    begin
                        ahb_fsm_current_state  <=  Write_RAM_9;
		 				RAM_ADDR               <=  RAM_ADDR + 32'h00000004;
					end					
	              end

			Write_RAM_9: //0x18  store the address+control signals and apply to coreahblite
	            begin
    	            HWDATA[7:0]                 <=  DATAOUT[31:24] ;
    	            HSIZE                      	<=  HSIZE_int;
					HADDR                  	   	<=  RAM_ADDR;
    	            HWRITE                     	<=  1'b1;
    	            ahb_fsm_current_state      	<=  Write_RAM_10;
	             end
	        
            Write_RAM_10: //0x19 
                 begin
                  HTRANS                   <=  2'b10;
				  if ( HREADY  == 1'b0) //keep the address+control signals when slave is not ready yet
                    begin
                        ahb_fsm_current_state  <=  Write_RAM_10;
    	            end
                  else  //send the data+go to next state, doesn't need to keep the controls active
                    begin
                        ahb_fsm_current_state  <=  Write_RAM_11;
                    end
                 end
             
		

			Write_RAM_11: //0x1a
    	         begin                
				   HTRANS                 <=  2'b00;
				   if ( HREADY  == 1'b0) //keep the address+control signals when slave is not ready yet
                    begin
                        ahb_fsm_current_state  <=  Write_RAM_11;
    	            end
                  else  //send the data+go to next state, doesn't need to keep the controls active
                    begin
                        //ahb_fsm_current_state  <=  Idle;
						//if (RAM_ADDR[7:0] == 8'b11111100) 
                    	if (RAM_ADDR[15:0] == 16'h07FC)
                            begin
                        		//ahb_busy               <=  1'b0;
								//init_done              <=  1'b1;
								//ram_init_done          <=  1'b1;
                                //ahb_fsm_current_state  <=  Idle;
                                init_done                <=  1'b0;
                                ram_init_done            <=  1'b1;
                                ahb_busy                 <=  1'b1;
                                HADDR                    <=  NVM_CTRL;
                                ahb_fsm_current_state    <=  Done_0;
    	            		end
                 	 	else   //finish the write transfer  
							begin	
                        		ahb_busy               <=  1'b1;
                        		init_done              <=  1'b0;
								NVM_ADDR               <=  NVM_ADDR + 32'h00000004;
		 						RAM_ADDR               <=  RAM_ADDR + 32'h00000004;
                                ahb_fsm_current_state  <=  NVM_ready_0;
                                HADDR                  <=  NVM_STATUS;
    	            		end
                    end					
	              end
            
            Done_0:
                 begin
                        HTRANS                  <=  2'b10;
	                    HSIZE                   <=  2'b10;
	                    HWRITE                  <=  1'b1;
	     				HWDATA              	<=  32'h00000000;
                        ahb_fsm_current_state   <= Done_1;
                 end
            Done_1:
                 begin
                 	HTRANS                   <=  2'b00;
					if ( HREADY  == 1'b1) // go to next state
                     begin
                        ahb_busy                 <=  1'b0;
                        init_done                <=  1'b1;
                        ram_init_done            <=  1'b1;
	                    ahb_fsm_current_state    <=  Idle;
                     end 
                   else   //keep the address+control signals when slave is not ready yet
                     begin   
	                    ahb_fsm_current_state    <=  Done_1;
                     end       
                 end

     endcase
	end     
end

endmodule