module SPI_tb();
reg MOSI; 
reg SS_n; 
reg clk;  
reg rst_n;

wire MISO;

SPI_Wrapper DUT(.MOSI(MOSI),.MISO(MISO),.SS_n(SS_n),.clk(clk),.rst_n(rst_n));

initial begin
	clk = 0;
	forever 
		#50 clk = ~clk;
end

initial begin
	rst_n = 0;
	SS_n  = 1;
	MOSI  = 1;
	@(negedge clk);
	rst_n = 1;

////////////////// write address //////////////////

	SS_n = 0;
	@(negedge clk);

	MOSI = 0;
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

	repeat(9) @(negedge clk);

	SS_n = 1;

	$stop;
end 
endmodule 