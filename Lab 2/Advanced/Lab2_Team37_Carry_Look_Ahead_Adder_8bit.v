timescale 1ns/1ps

module Carry_Look_Ahead_Adder_8bit(a, b, c0, s, c8);
input [7:0] a, b;
input c0;
output [7:0] s;
output c8;

wire [7:0] c;
wire [7:0] p,g;

Full_Adder_PG fa0 (a[0], b[0], c0 , s[0], p[0], g[0]);
Full_Adder_PG fa1 (a[1], b[1], c[1], s[1], p[1], g[1]);
Full_Adder_PG fa2 (a[2], b[2], c[2], s[2], p[2], g[2]);
Full_Adder_PG fa3 (a[3], b[3], c[3], s[3], p[3], g[3]);

Full_Adder_PG fa4 (a[4], b[4], c[4], s[4], p[4], g[4]);
Full_Adder_PG fa5 (a[5], b[5], c[5], s[5], p[5], g[5]);
Full_Adder_PG fa6 (a[6], b[6], c[6], s[6], p[6], g[6]);
Full_Adder_PG fa7 (a[7], b[7], c[7], s[7], p[7], g[7]);

C4_Generator cg0 (c0,p[3:0],g[3:0],c4);
C4_Generator cg1 (c4,p[7:4),g[7:4],c8);

Carry_Gen_4bit cg30 (.c_in(c[0]),.p_in([3:0]),.g_in,.c(c[3:1]));
Carry_Gen_4bit cg74 (.c_in(c[4]),.p_in([7:4]),.g_in,.c(c[7:5]));

endmodule

// Generate c1,c2,c3 instantly
module Carry_Gen_4bit(c_in,p_in,g_in,c_out);
input c_in;
input [3:0] p_in, g_in;
output [3:1] c_out;

wire w0,w10,w11,w12,w20,w21,w22,w23;
wire o;
//c_out [1]
AND oa00 (w0,p[0],c_in);
OR oo00 (c_out[1], w0, g[0]);
//c_out [2]
AND oa10 (w10,w0,p[1]);
AND oa11 (w11,g[0],p[1]);
OR oo10 (w12,w10,w11);
OR oo12 (c_out[2],g[1],w12);
//c_out [3]
AND oa20 (w20,w10,p[2]);
AND oa21 (w21,w11,p[2]);
AND oa22 (w22,g[1],p[2]);
OR oo20 (w23,w20,w21);
OR oo21 (w24,w23,w22);
OR oo22 (c_out[3],g[2],w24);
endmodule

// Generate c4 instantly
module C4_Generator(c0,p,g,c4);
input c0;
input [3:0] p, g;
output c4;

wire w0,w10,w11,w12,w20,w21,w22,w23,w30,w31,w32,w33;
wire o0,o1;

AND oa00 (w0,p[0],c_in);

AND oa10 (w10,w0,p[1]);
AND oa11 (w11,g[0],p[1]);

AND oa20 (w20,w10,p[2]);
AND oa21 (w21,w11,p[2]);
AND oa22 (w22,g[1],p[2]);

AND oa30 (w30,w20,p[3]);
AND oa31 (w31,w21,p[3]);
AND oa32 (w32,w22,p[3]);
AND oa33 (w33,g[2],p[3]);

OR(o0,w30,w31);
OR(o1,w32,w33);
OR(c4,o1,o0);
endmodule


module Full_Adder_PG (a, b, cin, sum, p, g);
    input a, b, cin;
    output sum, p, g;

    wire temp1, temp2, tempsum;

    Half_Adder ha1(a,b,temp1,tempsum);
    Half_Adder ha2(cin, tempsum, temp2, sum);
	
	AND gi(g,a,b);
	XOR pi(p,a,b);
endmodule

module Half_Adder(a, b, cout, sum);
    input a, b;
    output cout, sum;

    XOR xor1(sum, a, b);
    AND and1(cout, a, b);
endmodule
/*
module XOR_4bit (out,a,b);
input [3:0] a,b;
output [3:0] out;
XOR x0 (out[0],a[0],b[0]);
XOR x1 (out[1],a[1],b[1]);
XOR x2 (out[2],a[2],b[2]);
XOR x3 (out[3],a[3],b[3]);
endmodule
*/
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

/*
module AND_4bit (out,a,b);
input [3:0] a,b;
output [3:0] out;
AND a0 (out[0],a[0],b[0]);
AND a1 (out[1],a[1],b[1]);
AND a2 (out[2],a[2],b[2]);
AND a3 (out[3],a[3],b[3]);
endmodule
*/
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

module XOR (out, in1, in2);
    input in1,in2;
    output out;
    wire xor0,xor1,xor2;
    nand n40(xor0,in1,in2);
    nand n41(xor1,xor0,a);
    nand n42(xor2,xor0,b);
    nand n43(out,xor1,xor2);
endmodule

s
