module SPI_Slave_tb();

reg MOSI;
reg SS_n;
reg clk;
reg rst_n;
reg tx_valid;      // input from RAM side. if it's 1 tx_data will be converted serially to be at MISO port.
reg [7:0] tx_data; // data to be converted from parallel to serial at MISO port.

wire MISO; 
wire rx_valid;        // output from slave to RAM such that RAM detect that rx_data[7:0] is ready to be processed.
wire [9 :0] rx_data;  // data to be processed by RAM.

SPI_Slave dut(MOSI,MISO,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);


initial begin
	clk = 0;
	forever 
		#10 clk = ~clk;
end

initial begin
	//reset
	rst_n = 0;
	SS_n  = 1;
	MOSI  = 1;
	@(negedge clk);
	rst_n = 1;

	////////////////// write address //////////////////
	SS_n = 0;
	@(negedge clk);
	MOSI = 0;
	tx_valid = 0;
	tx_data  = 0;
	@(negedge clk);
	
	MOSI = 0;
	@(negedge clk);
	MOSI = 0;
	@(negedge clk);

	MOSI = 0;
	@(negedge clk);
	MOSI = 1;
	@(negedge clk);
	MOSI = 1;
	@(negedge clk);
	MOSI = 0;
	@(negedge clk);
	MOSI = 0;
	@(negedge clk);
	MOSI = 1;
	@(negedge clk);
	MOSI = 0;
	@(negedge clk);
	MOSI = 1;
	@(negedge clk);

	SS_n = 1;
	@(negedge clk);

//////////////////write data//////////////////
	SS_n = 0;
	@(negedge clk);
	MOSI = 0;
	@(negedge clk);

	MOSI = 0;
	@(negedge clk);
	MOSI = 1;
	@(negedge clk);

	MOSI = 0;
	@(negedge clk);
	MOSI = 1;
	@(negedge clk);
	MOSI = 0;
	@(negedge clk);
	MOSI = 0;
	@(negedge clk);
	MOSI = 1;
	@(negedge clk);
	MOSI = 1;
	@(negedge clk);
	MOSI = 0;
	@(negedge clk);
	MOSI = 0;
	@(negedge clk);	


	SS_n = 1;
	@(negedge clk);

//////////////////read address//////////////////
	SS_n = 0;
	@(negedge clk);

	MOSI = 1;
	@(negedge clk);

	MOSI = 1;
	@(negedge clk);
	MOSI = 0;
	@(negedge clk);

	MOSI = 1;
	@(negedge clk);
	MOSI = 1;
	@(negedge clk);
	MOSI = 0;
	@(negedge clk);
	MOSI = 1;
	@(negedge clk);
	MOSI = 1;
	@(negedge clk);
	MOSI = 0;
	@(negedge clk);
	MOSI = 0;
	@(negedge clk);
	MOSI = 1;
	@(negedge clk);	


	 SS_n = 1;
	@(negedge clk);

//////////////////read data//////////////////
	SS_n = 0;
	@(negedge clk);

	MOSI = 1;
	@(negedge clk);

	MOSI = 1;
	@(negedge clk);
	MOSI = 1;
	@(negedge clk);

	MOSI = 0;
	@(negedge clk);
	MOSI = 1;
	@(negedge clk);
	MOSI = 1;
	@(negedge clk);
	MOSI = 0;
	@(negedge clk);
	MOSI = 1;
	@(negedge clk);
	MOSI = 1;
	@(negedge clk);
	MOSI = 0;
	@(negedge clk);
	MOSI = 0;
	@(negedge clk);	


	tx_valid = 1;
	tx_data  = 8'b0111_0100;
	repeat(8) @(negedge clk);

	SS_n = 1;

	$stop;
end 
endmodule 