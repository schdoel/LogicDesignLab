`timescale 1ns/1ps

module Multiplier_4bit_t(a, b, p);

    reg [3:0] a = 4'b0;
    reg [3:0] b = 4'b0;
    wire [7:0] p;

    Multiplier_4bit(
        a.(a), 
        b.(b), 
        p.(p)
    );

    initial begin 
        #10 a=4'b0; b=4'b0;
        #10 a=4'b1; b=4'b0;
        #10 a=4'b2; b=4'b0;
        #10 a=4'b3; b=4'b0;

        #10 a=4'b0; b=4'b1;
        #10 a=4'b1; b=4'b1;
        #10 a=4'b2; b=4'b1;
        #10 a=4'b3; b=4'b1;

        #10 a=4'b0; b=4'b2;
        #10 a=4'b1; b=4'b2;
        #10 a=4'b2; b=4'b2;
        #10 a=4'b3; b=4'b2;

        #10 a=4'b0; b=4'b3;
        #10 a=4'b1; b=4'b3;
        #10 a=4'b2; b=4'b3;
        #10 a=4'b3; b=4'b3;

        #10 $finish
    end 


endmodule