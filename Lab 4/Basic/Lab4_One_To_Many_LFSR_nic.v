`timescale 1ns/1ps

module One_TO_Many_LFSR(clk, rst_n, out);
input clk;
input rst_n;
output reg [7:0] out;

wire [7:0] next,state;

always@(posedge clk)begin
    if(rst_n==1'b0) out<=8'b10111101;
    else state<=next;
end

always@(*)begin
    next[0] = state[7];
    next[1] = state[0];
    next[2] = state[7]^state[1];
    next[3] = state[7]^state[2];
    next[4] = state[7]^state[3];
    next[7:5] = state[6:4];
    out = state;
end

endmodule