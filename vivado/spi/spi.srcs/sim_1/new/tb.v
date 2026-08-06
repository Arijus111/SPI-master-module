`timescale 1ns / 1ps

module tb();
//inputai reg
reg clk;
reg rst;
reg start;
reg [7:0] tx_data;
reg miso;
//outputai wire
wire mosi;
wire sclk;
wire cs_n;
wire [7:0] rx_data;
wire busy;
wire done;
reg [7:0] slave_data;
reg [2:0] slave_bit_count;

spi dut (
.clk(clk),
.rst(rst),
.tx_data(tx_data),
.miso(miso),
.start(start),
.mosi(mosi),
.sclk(sclk),
.cs_n(cs_n),
.rx_data(rx_data),
.busy(busy),
.done(done)
);

initial begin
clk=0;
forever begin
#5;
clk=~clk;
end
end

initial begin
rst=1;
start=0;
tx_data=0;
miso=0;
#20;
rst=0;
#40;
start=1;
slave_data=8'b11000011;
slave_bit_count=3'd1;
tx_data=8'b10011101;
miso=slave_data[7];
#10;
start=0;
#200;
$stop;
end

always@(negedge sclk) begin
if (cs_n==0 && slave_bit_count<=7) begin
miso<=slave_data[7-slave_bit_count];
slave_bit_count<=slave_bit_count+1;
end
end
endmodule
