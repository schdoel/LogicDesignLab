`timescale 1ns/1ps

module NAND_Implement (a, b, sel, out);
input a, b;
input [2:0] sel;
output out;

wire [2:0] notsel;
wire out0, out1, out2, out3, out4, out5, out6, out7;
wire nandAB, andAB, orAB, norAB, xorAB, xnorAB, notA;
wire s0, s1, s2, s3, s4, s5, s6, s7;

NOT Notsel2(notsel[2], sel[2]);
NOT Notsel1(notsel[1], sel[1]);
NOT Notsel0(notsel[0], sel[0]);

NAND nandab(nandAB, a, b);
AND andab(andAB, a, b);
OR orab(orAB, a, b);
NOR norab(norAB, a, b);
XOR xorab(xorAB, a, b);
XNOR xnorab(xnorAB, a, b);
NOT nota(notA, a);

AND3bit a0(s0,notsel[2], notsel[1], notsel[0]);
AND3bit a1(s1,notsel[2], notsel[1], sel[0]);
AND3bit a2(s2,notsel[2], sel[1],    notsel[0]);
AND3bit a3(s3,notsel[2], sel[1],    sel[0]);
AND3bit a4(s4,sel[2],    notsel[1], notsel[0]);
AND3bit a5(s5,sel[2],    notsel[1], sel[0]);
AND3bit a6(s6,sel[2],    sel[1],    notsel[0]);
AND3bit a7(s7,sel[2],    sel[1],    sel[0]);

AND o0(out0, nandAB, s0);
AND o1(out1, andAB,  s1);
AND o2(out2, orAB,   s2);
AND o3(out3, norAB,  s3);
AND o4(out4, xorAB,  s4);
AND o5(out5, xnorAB, s5);
AND o6(out6, notA,   s6);
AND o7(out7, notA,   s7);

outputOR outOr(out, out0, out1, out2, out3, out4, out5, out6, out7);
endmodule

module AND3bit(out, in1, in2, in3);
input in1, in2, in3;
output out;
wire and12;
AND a1(and12, in1, in2);
AND a2(out, and12, in3);
endmodule

module outputOR(out, in1, in2, in3, in4, in5, in6, in7, in8);
input in1, in2, in3, in4, in5, in6, in7, in8;
output out;
wire or12, or34, or56, or78, or1278,or3456;
OR o1(or12, in1, in2);
OR o2(or34, in3, in4);
OR o3(or56, in5, in6);
OR o4(or78, in7, in8);
OR o6(or1278, or78, or12);
OR o5(or3456, or34, or56);
OR of(out, or1278, or3456);
endmodule

module NAND(out, in1, in2);
input in1, in2;
output out;
nand nand1(out, in1, in2);
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

module XNOR(out, in1, in2);
input in1, in2;
output  out;
wire AB;

XOR xor1(AB, in1, in2);
NOT not1(out, AB);
endmodule

module NOR(out, in1, in2);
input in1, in2;
output out;
wire A, B, AB;
nand nand1(A, in1, in1);
nand nand2(B, in2, in2);
nand nandAB(AB, A, B);
nand norAB(out, AB, AB);
endmodule

module XOR(out, in1, in2);
input in1, in2;
output out;
wire AB, ABA, ABB;

nand ab(AB, in1, in2);
OR o1(ABA, in1, in2);
AND a1(out, AB, ABA);

endmodule

module NOT(out, in1);
input in1;
output out;
nand notA(out, in1, in1);
endmodule