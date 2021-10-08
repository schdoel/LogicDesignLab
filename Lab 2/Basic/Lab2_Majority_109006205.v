`timescale 1ns/1ps

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