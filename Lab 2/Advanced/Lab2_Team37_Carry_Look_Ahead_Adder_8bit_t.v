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


//ini juga very gak yakin soalnya yg di internet bikin reg clock???
initial begin
    {a,b} = 16'b0;
    c0 = 1'b0;
    repeat (2 ** 16) begin
        #1 {a,b} = {a,b} + 16'b1;
        test;
    end
    #1
    {a,b} = 16'b0;
    c0 = 1'b1;
    repeat(2 ** 16) begin
        #1 {a,b} = {a,b} +16'b1;
        test;
    end
    #1
    $finish;
end

//ini maksudnya apa aaaaaaaa aku gak tau ketemu diinternet ehe 
task Test;
begin
  if (s !== (a + b + c0) & 16'b00001111) begin
    $display("[ERROR] sum (c)");
    $write("a: %d\n", a);
    $write("b: %d\n", b);
    $write("c0: %d\n", c0);
    $write("s: %d\n", s);
    $display;
  end
  if (c8 !== (a + b + c0) & 16'b00010000) begin
    $display("[ERROR] cout (c8)");
    $write("a: %d\n", a);
    $write("b: %d\n", b);
    $write("c0: %d\n", c0);
    $write("c8: %d\n", c8);
    $display;
  end
end
endtask

endmodule

/*
`timescale 100ps/1ps

module Carry_Look_Ahead_Adder_t;

parameter SIZE = 4;

reg CLK = 0;

reg [SIZE-1:0] a = 4'b0;
reg [SIZE-1:0] b = 4'b0;
reg c0 = 1'b0;
wire c8;
wire [SIZE-1:0] s;


Carry_Look_Ahead_Adder cla_adder (
  .a (a),
  .b (b),
  .c0 (c0),
  .c8 (c8),
  .s (s)
);

always #1 CLK = ~CLK;

initial begin
  {a, b} = 8'b0;
  c0 = 1'b0;
  repeat (2 ** 8) begin
    @ (posedge CLK)
      Test;
    @ (negedge CLK)
      {a, b} = {a, b} + 8'b1;
  end
  #1
  {a, b} = 8'b0;
  c0 = 1'b1;
  repeat (2 ** 8) begin
    @ (posedge CLK)
      Test;
    @ (negedge CLK)
      {a, b} = {a, b} + 8'b1;
  end
  #1 $finish;
end

task Test;
begin
  if (s !== (a + b + c0) & 8'b00001111) begin
    $display("[ERROR] s");
    $write("a: %d\n", a);
    $write("b: %d\n", b);
    $write("c0: %d\n", c0);
    $write("s: %d\n", s);
    $display;
  end
  if (c8 !== (a + b + c0) & 8'b00010000) begin
    $display("[ERROR] c8");
    $write("a: %d\n", a);
    $write("b: %d\n", b);
    $write("c0: %d\n", c0);
    $write("c8: %d\n", c8);
    $display;
  end
end
endtask

endmodule
*/
