`timescale 1ns/1ps

module Mux_4x1_4bit(a, b, c, d, sel, f);
input [3:0] a, b, c, d;
input [1:0] sel;
output [3:0] f;

wire [1:0] notsel;
wire [3:0] outA, outB, outC, outD;

not Notsel[1:0](notsel, sel);

and AndOutA[3:0](outA, a, {4{notsel[1]}}, {4{notsel[0]}});
and AndOutB[3:0](outB, b, {4{notsel[1]}}, {4{sel[0]}});
and AndOutC[3:0](outC, c, {4{sel[1]}}, {4{notsel[0]}});
and AndOutD[3:0](outD, d, {4{sel[1]}}, {4{sel[0]}});

or OutOr[3:0](f, outA, outB, outC, outD);

endmodule

// wire A,B,C,D;

// not Not(notsel[0],sel[0]);
// not Not1(notsel[1],sel[1]);

// and And(A, notsel[0], notsel[1]);
// and And1(B, sel[0], notsel[1]);
// and And2(C, notsel[0], sel[1]);
// and And3(D, sel[0], sel[1]);

// wire [3:0] AA,BB,CC,DD;

// and and4(AA[0], A, a[0]);
// and and5(BB[0], B, b[0]);
// and and6(CC[0], C, c[0]);
// and and7(DD[0], D, d[0]);

// and and8(AA[1], A, a[1]);
// and and9(BB[1], B, b[1]);
// and and10(CC[1], C, c[1]);
// and and11(DD[1], D, d[1]);

// and and12(AA[2], A, a[2]);
// and and13(BB[2], B, b[2]);
// and and14(CC[2], C, c[2]);
// and and15(DD[2], D, d[2]);

// and and16(AA[3], A, a[3]);
// and and17(BB[3], B, b[3]);
// and and18(CC[3], C, c[3]);
// and and19(DD[3], D, d[3]);

// or or0(f[0], AA[0], BB[0], CC[0], DD[0]);
// or or1(f[1], AA[1], BB[1], CC[1], DD[1]);
// or or2(f[2], AA[2], BB[2], CC[2], DD[2]);
// or or3(f[3], AA[3], BB[3], CC[3], DD[3]);

// endmodule