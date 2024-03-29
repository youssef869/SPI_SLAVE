/*
 * Date        :                       1/3/2024
 *********************************************************************************************************************************************
 * Author      :                       Youssef Khaled
 *********************************************************************************************************************************************
 * File Name   :                       RAM.v
 *********************************************************************************************************************************************
 * Module Name :                       RAM
 *********************************************************************************************************************************************
 * Describtion :                       Single port synchronous RAM 
 *********************************************************************************************************************************************
*/

module RAM(din,rx_valid,clk,rst_n,dout,tx_valid);

parameter MEM_DEPTH = 256;
parameter ADDR_SIZE = 8;

input [ADDR_SIZE+1 :0] din; //additional 2 bits are required to select operation
input rx_valid; // if high then din[7:0] is ready to be processed (for write data/address and read address operations)
input clk; // clock signal
input rst_n; //active low synchronous reset

output reg [ADDR_SIZE-1:0] dout; // RAM output 
output reg tx_valid;// whenever read operation is done tx_valid will be high

reg [ADDR_SIZE-1 :0] wr_addr , rd_addr;

reg [ADDR_SIZE-1 :0] mem[MEM_DEPTH-1 :0];

always @(posedge clk) begin
	if(~rst_n) begin
		dout     <= 0;
		tx_valid <= 0; //optional
	end 
	else begin
		case(din[ADDR_SIZE+1:ADDR_SIZE])
			2'b00  : begin 
				tx_valid <= 0; 
				if(rx_valid)
					wr_addr <= din[ADDR_SIZE-1:0];
			end 
			2'b01  : begin
				tx_valid <= 0;
				if(rx_valid) 
					mem[wr_addr] <= din[ADDR_SIZE-1:0];
			end 
			2'b10  : begin
				tx_valid <= 0;
				if(rx_valid)
					rd_addr <= din[ADDR_SIZE-1:0];
			end 
			2'b11: begin
					dout <= mem[rd_addr];
					tx_valid <= 1;
			end 
		endcase 
	end  
end
endmodule 