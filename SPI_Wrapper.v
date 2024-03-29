/*
 * Date        :                       4/3/2024
 *********************************************************************************************************************************************
 * Author      :                       Youssef Khaled
 *********************************************************************************************************************************************
 * File Name   :                       SPI_Wrapper.v
 *********************************************************************************************************************************************
 * Module Name :                       SPI_Wrapper
 *********************************************************************************************************************************************
 * Describtion :                       Top module in which we instantiate both slave and RAM and connecting them properly
 *********************************************************************************************************************************************
*/

module SPI_Wrapper(MOSI,MISO,SS_n,clk,rst_n);

input MOSI;  
input SS_n;  
input clk;   
input rst_n; 

output MISO; 

wire [9:0] rx_data;
wire rx_valid;
wire tx_valid;
wire [7:0] tx_data;


SPI_Slave slave(.MOSI(MOSI), .MISO(MISO), .SS_n(SS_n), .clk(clk), .rst_n(rst_n),.rx_data(rx_data),
                .rx_valid(rx_valid), .tx_valid(tx_valid), .tx_data(tx_data));

RAM #(.ADDR_SIZE(8), .MEM_DEPTH(256)) ram(.din(rx_data), .rx_valid(rx_valid), .clk(clk),
                                          .rst_n(rst_n), .dout(tx_data),.tx_valid(tx_valid));

endmodule 