`timescale 1ns/1ps

module Multiplier_4bit(a, b, p);
    input [3:0] a, b;
    output [7:0] p;
    wire [3:0] A,B,S;
    wire c;

    AND P0(p[0],a[0],b[0]);

    AND b0a1(B[0],a[1],b[0]);
    AND b1a2(B[1],a[2],b[0]);
    AND b2a3(B[2],a[3],b[0]);
    AND b3_0(B[3],1'b0, 1'b0);

    AND b1a0(A[0],a[0],b[1]);
    AND b1a1(A[1],a[1],b[1]);
    AND b1a2(A[2],a[2],b[1]);
    AND b1a3(A[3],a[3],b[1]);

    Full_Adder_4bit FA1(A,B,0,c,S);

    AND b2a0(A[0],a[0],b[2]);
    AND b2a1(A[1],a[1],b[2]);
    AND b2a2(A[2],a[2],b[2]);
    AND b2a3(A[3],a[3],b[2]);

    AND b0(A[0],a[0],b[2]);
    AND b1(A[1],a[1],b[2]);
    AND b2(A[2],a[2],b[2]);
    AND b3(A[3],a[3],b[2]);
    
    Full_Adder_4bit FA2()




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
