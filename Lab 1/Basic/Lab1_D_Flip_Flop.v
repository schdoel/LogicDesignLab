`timescale 1ns/1ps

module D_Flip_Flop(clk, d, q);
input clk;
input d;
output q;

wire notClk, temp;

not not1(notClk, clk);
D_Latch l1(notClk, d, temp);
D_Latch l3(clk, temp, q);

endmodule

module D_Latch(e, d, q);
input e;
input d;
output q;

wire notd, temp, temp1, notq;

not not1(notd, d);
nand nand1(temp, d,e);
nand nand2(temp1, notd, e);
nand nand3(q, notq, temp);
nand nand4(notq, q,temp1);

endmodule