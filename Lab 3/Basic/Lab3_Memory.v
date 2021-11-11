`timescale 1ns/1ps

module Memory (clk, ren, wen, addr, din, dout);
input clk;
input ren, wen;
input [6:0] addr;
input [7:0] din;
output reg [7:0] dout;

parameter M = 128;
parameter N = 8;

reg [N-1:0] mem0 [M-1:0];

//assign memory = memory[addr] <= memory[addr];
always @(posedge clk) begin
    //read enable
    if(ren == 1'b1) begin
        //read memory to dout 
        dout <= mem0[addr];
    end
    else begin
        //write enable
        if(wen == 1'b1)begin
            //write din to memory, dout = 0
            mem0[addr] <= din;
        end
        //do nothing memory = memory
        dout <= 8'b0;
    end
end

endmodule