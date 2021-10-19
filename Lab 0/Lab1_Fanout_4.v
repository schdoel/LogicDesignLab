`timescale 1ns/1ps

module Fanout_4(in, out);
    input in;
    input [3:0] out;
    wire IN;
    not NOT0(IN, in);
    not NOT1(out[3], out[2], out[1], out[0], IN);

endmodule