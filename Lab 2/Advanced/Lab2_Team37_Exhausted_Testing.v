`timescale 1ns/1ps

module Exhausted_Testing(a, b, cin, error, done);
output [3:0] a, b;
output cin;
output error;
output done;

// input signal to the test instance.
reg [3:0] a = 4'b0000;
reg [3:0] b = 4'b0000;
reg cin = 1'b0;

// output from the test instance.
wire [3:0] sum;
wire cout;

// instantiate the test instance.
Ripple_Carry_Adder rca(
    .a (a), 
    .b (b), 
    .cin (cin),
    .cout (cout),
    .sum (sum)
);

initial begin
    // design you test pattern here.
    // Remember to set the input pattern to the test instance every 5 nanasecond
    // Check the output and set the `error` signal accordingly 1 nanosecond after new input is set.
    // Also set the done signal to 1'b1 5 nanoseconds after the test is finished.
    // Example:
    // setting the input
    // a = 4'b0000;
    // b = 4'b0000;
    // check the output
    // #1
    // check_output;
    // #4
    // setting another input
    // a = 4'b0001;
    // b = 4'b0000;
    //.....
    // #4
    // The last input pattern
    // a = 4'b1111;
    // b = 4'b1111;
    // #1
    // check_output;
    // #4
    // setting the done signal
    // done = 1'b1;
end

endmodule

/*
module testbench_4bitadder

reg [3:0] ta, testbench; reg tc; //initialise test vector

wire [3:0] tsum,; wire tcr;

adder4bit fa4 (.sum(tsum), .cr(tcr),.a(ta), .b( testbench), .c(tc));

initial

begin

#0 ta=4’b0000; testbench=4’b0000; tc=1’b0;

#10 ta=4’b0100; testbench=4’b0011; tc=1’b1;

#20 ta=4’b0011; testbench=4’b0111; tc=1’b1;

#30 ta=4’b1000; testbench=4’b0100; tc=1’b0;

#40 ta=4’b0101; testbench=4’b0101; tc=1’b1;

(or we can also write : #10 ta=4’d5; testbench=4’d6; tc=1’d1;)

end

$initial

begin

$monitor (“$time ta=%d testbench=%d tc=%c tsum=%d tcr=%d”, ta, testbench,tc,tsum,tcr);

end

endmodule
*/
