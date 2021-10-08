`timescale 1ns/1ps

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