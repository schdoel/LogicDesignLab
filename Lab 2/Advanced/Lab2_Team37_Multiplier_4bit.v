`timescale 1ns/1ps

module Multiplier_4bit(a, b, p);
    input [3:0] a, b;
    output [7:0] p;
    wire [3:0] A0,A1,A2,A3,B0,B1;

    AND_bitwise4x1 b0 (a[3:0],b[0],{A0[3:1],p[0]});
    AND_bitwise4x1 b1 (a[3:0],b[1],A1[3:0]);
    AND_bitwise4x1 b2 (a[3:0],b[2],A2[3:0]);
    AND_bitwise4x1 b3 (a[3:0],b[3],A3[3:0]);
    
    Full_Adder_4bit fa0(A1[3:0],{1'b0,A0[3:1]},1'b0,B0[3],{B0[2:0],p[1]});
    Full_Adder_4bit fa1(A2[3:0],B0[3:0],1'b0,B1[3],{B1[2:0],p[2]});
    Full_Adder_4bit fa1(A3[3:0],B1[3:0],1'b0,p[7],p[6:3]);

endmodule

module AND_bitwise4x1 (a,b,out);
    input [3:0] a;
    input b;
    output [3:0] out;

    AND a0 (out[0],a[0],b);
    AND a1 (out[1],a[1],b);
    AND a2 (out[2],a[2],b);
    AND a3 (out[3],a[3],b);
endmodule

module Full_Adder_4bit (a,b,cin,cout,sum);
    input [3:0]a,b;
    input cin;
    output cout;
    output [3:0] sum;
    wire wc1, wc2, wc3;

    Full_Adder fa0 (a[0], b[0], cin, sum[0], wc1);
    Full_Adder fa1 (a[1], b[1], wc1, sum[1], wc2);
    Full_Adder fa2 (a[2], b[2], wc2, sum[2], wc3);
    Full_Adder fa3 (a[3], b[3], wc3, sum[3], cout);

endmodule

module Half_Adder(a, b, cout, sum);
    input a, b;
    output cout, sum;

    XOR xor1(sum, a, b);
    AND and1(cout, a, b);

endmodule

module Full_Adder (a, b, cin, cout, sum);
    input a, b, cin;
    output cout, sum;

    wire temp1, temp2, tempsum;

    Half_Adder ha1(a,b,temp1,tempsum);
    Half_Adder ha2(cin, tempsum, temp2, sum);
    Majority m1(a,b,cin, cout);

endmodule

module XOR(out, in1, in2);
    input in1, in2;
    output out;
    wire AB, ABA, ABB;
    nand nandAB(AB, in1, in2);
    nand nand1(ABA, AB, in1);
    nand nand2(ABB, AB, in2);
    nand xorAB(out, ABA, ABB);
endmodule

module Majority(a, b, c, out);
    input a, b, c;
    output out;

    wire andAB, andAC, andBC, orABAC;

    AND andab(andAB, a, b);
    AND andac(andAC, a, c);
    AND andbc(andBC, b, c);
    OR orabac(orABAC, andAB, andAC);

    OR oror1andbc(out, orABAC, andBC);  

endmodule

module AND(out, in1, in2);
    input in1, in2;
    output out;
    wire nandAB;
    nand nand1(nandAB, in1, in2);
    nand nand2(out, nandAB, nandAB);
endmodule

module OR(out, in1, in2);
    input in1, in2;
    output out;
    wire A,B;
    nand nand1(A, in1, in1);
    nand nand2(B, in2, in2);
    nand orAB(out, A, B);
endmodule
