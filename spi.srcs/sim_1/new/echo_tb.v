`timescale 1ns / 1ps
module spi_tb;

reg clk;
reg rst;
reg start;
reg [7:0] tx_data;
wire miso;
wire mosi;
wire sclk;
wire cs_n;
wire [7:0] rx_data;
wire busy;
wire done;

assign miso = mosi;

spi dut(
    .clk(clk),
    .rst(rst),
    .start(start),
    .tx_data(tx_data),
    .miso(miso),
    .mosi(mosi),
    .sclk(sclk),
    .cs_n(cs_n),
    .rx_data(rx_data),
    .busy(busy),
    .done(done)
);

initial clk = 0;
always #5 clk = ~clk;

initial begin
    rst = 1;
    start = 0;
    tx_data = 8'hA5;
    #20;
    rst = 0;
    #10;
    start = 1;
    #10;
    start = 0;
    wait(done);
    #300;
    $finish;
end

endmodule