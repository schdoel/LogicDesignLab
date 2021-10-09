`timescale 1ns/1ps

module Carry_Look_Ahead_Adder_8bit(a, b, c0, s, c8);
input [7:0] a, b;
input c0;
output [7:0] s;
output c8;


// Carry  (C): Ci+1=Gi+Pi
//capek lah udahlah bingung jadinya apsih maunya huh




endmodule

module Carry_Look_Ahead_Adder_2bit(a,b,c0,s,c2);
    input[1:0] a,b;
    input c0;
    output[1:0] s;
    output c2;

    
endmodule

module Carry_Look_Ahead_Adder_4bit(a,b,c0,s,c4);
    input[3:0] a,b;
    input c0;
    output[3:0] s;
    output c4;

    wire [4:0] wc;
    
    // Carry  (C): Ci+1=Gi+Pi
    Carry c1(a[0],b[0],c0,wc[0]);
    Carry c2(a[1],b[1],wc[0],wc[1]);
    Carry c3(a[2],b[2],wc[1],wc[2]);
    Carry c4(a[3],b[3],wc[2],wc[3]);

    // Full adder
    Full_Adder fa1(a[0],b[0],c0,s[0]);
    Full_Adder fa2(a[1],b[1],wc[1],s[1]);
    Full_Adder fa3(a[2],b[2],wc[2],s[2]);
    Full_Adder fa4(a[3],b[3],wc[3],s[3]);

    AND result(),
endmodule

module Carry(a,b,c,cout);
    input a,b,c;
    output cout;

    wire and_ab, xor_ab, and_CxorAB;
    // Generate (G): Gi=AiBi
    AND G(and_ab, a, b);
    // Propagate (P): Pi=Ai+Bi
    XOR P(xor_ab, a, b);
    AND andCxorAB(and_CxorAB, c, xor_ab);
    // Carry  (C): Ci+1=Gi+Pi
    OR outputOR(cout, and_CxorAB, andAB);
endmodule



module Full_Adder (a, b, cin, cout, sum);
    input a, b, cin;
    output cout, sum;

    wire temp1, temp2, tempsum;

    Half_Adder ha1(a,b,temp1,tempsum);
    Half_Adder ha2(cin, tempsum, temp2, sum);
    Majority m1(a,b,cin, cout);
endmodule

module Half_Adder(a, b, cout, sum);
    input a, b;
    output cout, sum;

    XOR xor1(sum, a, b);
    AND and1(cout, a, b);
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

module XOR (out, in1, in2);
    input in1,in2;
    output out;
    wire xor0,xor1,xor2;
    nand n40(xor0,in1,in2);
    nand n41(xor1,xor0,a);
    nand n42(xor2,xor0,b);
    nand n43(out,xor1,xor2);
endmodule


// module Full_Adder_4bit (a,b,cin,cout,sum);
//     input [3:0]a,b;
//     input cin;
//     output cout;
//     output [3:0] sum;
//     wire wc1, wc2, wc3;

//     Full_Adder fa0 (a[0], b[0], cin, sum[0], wc1);
//     Full_Adder fa1 (a[1], b[1], wc1, sum[1], wc2);
//     Full_Adder fa2 (a[2], b[2], wc2, sum[2], wc3);
//     Full_Adder fa3 (a[3], b[3], wc3, sum[3], cout);

// endmodule

/*
module tb_fulladd;  
    // 1. Declare testbench variables  
   reg [3:0] a;  
   reg [3:0] b;  
   reg c_in;  
   wire [3:0] sum;  
   integer i;  
  
    // 2. Instantiate the design and connect to testbench variables  
   fulladd  fa0 ( .a (a),  
                  .b (b),  
                  .c_in (c_in),  
                  .c_out (c_out),  
                  .sum (sum));  
  
    // 3. Provide stimulus to test the design  
   initial begin  
      a <= 0;  
      b <= 0;  
      c_in <= 0;  
  
      $monitor ("a=0x%0h b=0x%0h c_in=0x%0h c_out=0x%0h sum=0x%0h", a, b, c_in, c_out, sum);  
  
        // Use a for loop to apply random values to the input  
      for (i = 0; i < 5; i = i+1) begin  
         #10 a <= $random;  
             b <= $random;  
                 c_in <= $random;  
      end  
   end  
endmodule  
*/
