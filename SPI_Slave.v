/*
 * Date        :                       2/3/2024
 *********************************************************************************************************************************************
 * Author      :                       Youssef Khaled
 *********************************************************************************************************************************************
 * File Name   :                       SPI_Slave.v
 *********************************************************************************************************************************************
 * Module Name :                       SPI_Slave
 *********************************************************************************************************************************************
 * Describtion :                       SPI (serial perhirpal interface) is one of the most famous interfaces which provides
 *                                     high data rates , here we implement a SPI slave that master will communicate with then
 *                                     it will communicate with RAM , supported operations are write addres/data and read
 *                                     address/data.  
 *********************************************************************************************************************************************
*/


module SPI_Slave(MOSI,MISO,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);

//FSM encoding 
parameter IDLE      = 3'b000;
parameter CHK_CMD   = 3'b001;
parameter WRITE     = 3'b010;
parameter READ_ADD  = 3'b011;
parameter READ_DATA = 3'b100;

input MOSI;          // Master out slave in.
input SS_n;          // Slave select. if it's 0 slave will communicate , if it's 1 commuincation ends.
input clk;           // Clock signal.
input rst_n;         // synchronous active low reset.
input tx_valid;      // input from RAM side. if it's 1 tx_data will be converted serially to be at MISO port.
input [7:0] tx_data; // data to be converted from parallel to serial at MISO port.

output reg MISO; 			// Master in slave out.
output reg rx_valid;        // output from slave to RAM such that RAM detect that rx_data[7:0] is ready to be processed.
output reg [9 :0] rx_data;  // data to be processed by RAM.

(*fsm_encoding = "one_hot"*) //attribute to test different encoding (sequential, gray ,one hot).
reg [2:0] cs,ns; // current and next state, Both are 3 bits as we have 5 states.

reg read_address_n; // if zero read address , if one read data.

reg [3:0] counter;     // 4 bit counter for serial to parallel conversion .
reg [3:0] rd_counter; //  4 bit counter for read data operaation (parallel to serial conversion).

//next state logic
always @(*) begin
	case(cs)
		IDLE: begin
			if(SS_n) begin
				ns = IDLE;
			end 
			else begin				
				ns = CHK_CMD; 
			end 
		end 

		CHK_CMD: begin
		// SS_n = 1
			if(SS_n) begin
				ns = IDLE;
			end 

		// SS_n = 0 , MOSI = 0
			else if(~MOSI) begin
				ns = WRITE;
			end

		// SS_n = 0 , MOSI = 1 , read_address_n = 0
			else if(~read_address_n) begin
				ns = READ_ADD;
			end

		// SS_n = 0 , MOSI = 1 , read_address_n = 1
			else begin
				ns = READ_DATA;
			end 
		end 

		WRITE: begin
			if(SS_n) begin
				ns = IDLE;
			end 
			else begin
				ns = WRITE;
			end 
		end 

		READ_ADD: begin
			if(SS_n) begin
				ns = IDLE;
			end 
			else begin
				ns = READ_ADD;
			end 
		end 

		READ_DATA: begin
			if(SS_n) begin
				ns = IDLE;
			end 
			else begin
				ns = READ_DATA;
			end 
		end 
		default: ns = IDLE;
	endcase
end 

//state memory
always @(posedge clk) begin
	if (~rst_n) begin
		cs <= IDLE;
		read_address_n <= 0;
	end 
	else begin
		cs <= ns;
		if(cs == READ_ADD)
			read_address_n <= 1;
		else if(cs == READ_DATA)
			read_address_n <= 0;
	end 
end


//output logic
always @(posedge clk) begin	
	if(rst_n) begin
		case(cs)
			WRITE, READ_ADD: begin
			 	if(counter == 10) begin
			 		rx_valid <= 1; // Conversion ends
			 	end 
			 	else begin
			 		rx_data[9 - counter] <= MOSI;
			 		rx_valid <= 0;
			 		counter <= counter + 1;	
			 	end 
			end 
			READ_DATA: begin
			 	if(counter < 10) begin
				    rx_data[9 - counter] <= MOSI; // Serial to parallel converion.
			 		counter <= counter + 1;	
			 	end 

			 	else if(tx_valid && rd_counter < 8) begin
			 			MISO <= tx_data[7 - rd_counter]; // Parallel to serial conversion.	 				
			 			rd_counter <= rd_counter + 1;
			 	end 
			end 
			// Outputs for rest of cases will be invalid.
			//counters must be initialized to be zero until state becomes WRITE or READ_ADD or READ_DATA 
			default: begin
				counter    <= 0;
				rd_counter <= 0;			
			end 
		endcase
	end
end 
endmodule 
