timescale 1ns/1ps

module Carry_Look_Ahead_Adder_8bit_t(a, b, c0, s, c8);
reg [7:0] a, b;
reg c0;
wire [7:0] s;
wire c8;

reg CLK = 1;

Carry_Look_Ahead_Adder_8bit(
    a.(a), 
    b.(b), 
    c0.(c0), 
    s.(s), 
    c8.(c8)
);

#1 always CLK = ~CLK;

initial begin
    {a, b} = 16'b0;
    c0 = 1'b0;
    repeat (2 ** 16) begin
        @ (posedge CLK)
        Test;
        @ (negedge CLK)
        {a, b} = {a, b} + 16'b1;
    end
    #1
    {a, b} = 16'b0;
    c0 = 1'b1;
    repeat (2 ** 16) begin
        @ (posedge CLK)
        Test;
        @ (negedge CLK)
        {a, b} = {a, b} + 16'b1;
    end
    #1 $finish;
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
