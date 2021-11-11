`timescale 1ns/1ps

module Many_To_One_LFSR(clk, rst_n, out);
input clk;
input rst_n;
output reg [7:0] out;

reg [7:0] next, state;

always@(posedge clk) begin
    if(rst_n==1'b0) state <= 8'b10111101;
    else state<=next;
end

always @(*) begin
    next[0] = (state[1]^state[2])^(state[3]^state[7]);
    next[7:1] = state[6:0];
end

endmodule

