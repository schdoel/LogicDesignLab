`timescale 10ps/1ps

module Multiplier_4bit_t(a, b, p);

    reg [3:0] a = 4'b0;
    reg [3:0] b = 4'b0;
    wire [7:0] p;

    Multiplier_4bit(
        .a(a), 
        .b(b), 
        .p(p)
    );

    initial begin
        repeat (2 ** 4) begin
            #1 a = a + 4'b1; b = 1'b0;
            test();
            repeat (2 ** 4) begin
                #1 b = b + 4'b1;
                test();
            end
        end
        #1 $finish;
    end

    task test;
    reg [7:0] res;
    begin
        if(p != res) begin
            $display("[ERROR]");
            $write("a: %d\t", a);
            $write("b: %d\n", b);
            $write("WRONG p: %d\t", p);
            $write("SUPPOSED p: %d\n", res);
            $display;
        end
        res = a*b;
    end
    endtask

endmodule



