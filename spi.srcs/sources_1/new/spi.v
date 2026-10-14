`timescale 1ns / 1ps

module spi(
    input clk,
    input rst,
    input start,
    input [7:0] tx_data,
    input miso,
    output reg mosi,
    output reg sclk,
    output reg cs_n,
    output reg [7:0] rx_data,
    output reg busy,
    output reg done
    );

reg [7:0] tx_shift_reg;
reg [7:0] rx_shift_reg;
reg [2:0] bit_count;
reg [1:0] state;

localparam IDLE=2'd0;
localparam TRANSFER=2'd1;
localparam FINISH=2'd2;

always@(posedge clk) begin
if (rst) begin
sclk<=1'b0;
mosi<=1'b0;
cs_n<=1'b1;
rx_data<=8'b0;
busy<=1'b0;
done<=1'b0;
tx_shift_reg<=8'b0;
rx_shift_reg<=8'b0;
bit_count<=3'b0;
state<=IDLE;
end
else begin
case(state)
IDLE: begin
sclk<=1'b0;
mosi<=1'b0;
done<=1'b0;
busy<=1'b0;
cs_n<=1'b1;
if (start==1) begin
    busy<=1'b1;
    cs_n<=1'b0;
    tx_shift_reg<={tx_data [6:0], 1'b0};
    rx_shift_reg<=8'b0;
    bit_count<=3'd0;
    mosi<=tx_data[7];
    state<=TRANSFER;
    end
end
TRANSFER: begin
busy<=1'b1;
cs_n<=1'b0;
done<=1'b0;
sclk<=~sclk;
if (sclk==0) begin //rising edge fazė
if (bit_count==7) begin
state<=FINISH;
rx_data<={rx_shift_reg[6:0], miso};
rx_shift_reg<={rx_shift_reg[6:0], miso};
end
else begin
bit_count<=bit_count+1;
rx_shift_reg <= {rx_shift_reg[6:0], miso};
end
end
else begin //falling edge fazė (sclk==1)
mosi<=tx_shift_reg [7];
tx_shift_reg<={tx_shift_reg [6:0], 1'b0};
end
end
FINISH: begin
sclk<=1'b0;
done<=1'b1;
busy<=1'b0;
cs_n<=1'b1;
state<=IDLE;
end
default: begin
state<=IDLE;
end
endcase
end
end
endmodule
