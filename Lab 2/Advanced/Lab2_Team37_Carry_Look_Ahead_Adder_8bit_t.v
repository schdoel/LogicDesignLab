timescale 1ns/1ps

module Carry_Look_Ahead_Adder_8bit_t(a, b, c0, s, c8);
reg [7:0] a, b;
reg c0;
wire [7:0] s;
wire c8;

Carry_Look_Ahead_Adder_8bit(
    a.(a), 
    b.(b), 
    c0.(c0), 
    s.(s), 
    c8.(c8)
);

initial begin
  repeat (2 ** 8) begin
    #1
    {a, b} = {a, b} + 8'b1;
    assert(a, b, c0, c8, s);
    #1
    c0 = c0 + 1'b1;
    assert(a, b, c0, c8, s);
  end
  #1 $finish;
end

task assert;
  input [7:0] a;
  input [7:0] b;
  input c0;
  input c8;
  input [7:0] s;
  begin
    t_a = a;
    t_b = b;
    t_cin = cin;
    t_sum = (t_a + t_b + t_cin);
    t_cout = (t_a + t_b + t_cin) >> 4;
  end
endtask

endmodule