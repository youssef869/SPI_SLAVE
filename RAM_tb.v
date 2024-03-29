module RAM_tb();

parameter MEM_DEPTH = 256;
parameter ADDR_SIZE = 8;

reg [(ADDR_SIZE+2)-1 :0] din; 
reg rx_valid;
reg clk;
reg rst_n;

wire [ADDR_SIZE-1:0] dout;
wire tx_valid;

RAM #(.MEM_DEPTH(MEM_DEPTH) ,.ADDR_SIZE(ADDR_SIZE))
     dut(.din(din),.rx_valid(rx_valid),.clk(clk),.rst_n(rst_n),.dout(dout),.tx_valid(tx_valid));

initial begin
	clk = 0;
	forever 
		#10 clk = ~clk;
end

initial begin

/////////// reset ///////////
	rst_n = 0;
	rx_valid = 0;
	din =0;
	@(negedge clk);

/////////// write ///////////
	rst_n = 1;
	rx_valid = 1;
	repeat(100) begin
	// write address
		din[9:8] = 2'b00;
		din[7:0] = $random;
		@(negedge clk);

	//write data
		din[9:8] = 2'b01;
		din[7:0] = $random;
		@(negedge clk);		
	end 

/////////// read ///////////
	repeat(100) begin
	// read address
		din[9:8] = 2'b10;
		din[7:0] = $random;
		@(negedge clk);

	//read data
		din[9:8] = 2'b11;
		din[7:0] = $random;
		@(negedge clk);		
	end 
$stop;
end 
endmodule