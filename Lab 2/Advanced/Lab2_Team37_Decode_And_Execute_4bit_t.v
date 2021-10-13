`timescale 1ns/1ps

module Decode_and_Execute_t;

reg CLK = 1;

reg [2:0] sel = 3'b0;
reg [3:0] rs = 4'b0;
reg [30] rt = 4'b0;
wire [3:0] rd;


Decode_and_Execute dae_i (
  .sel(sel),
  .rs(rs),
  .rt(rt),
  .rd(rd)
);

always #1 CLK = ~CLK;

initial begin
  sel = 3'b000;
  repeat (2 ** 3) begin
    {rs, rt} = 8'b0;
    repeat (2 ** 8) begin
      @ (posedge CLK)
        Test;
      @ (negedge CLK)
        {rs, rt} = {rs, rt} + 8'b1;
    end
    sel = sel + 3'b001;
  end
  #1 $finish;
end


task Test;
begin
  case (sel)
    3'b000:
      // ADD
      if (rd !== rs + rt) begin
        $display("[ERROR] ADD");
        $write("rs: %d\n", rs);
        $write("rt: %d\n", rt);
        $write("rd: %d\n", rd);
        $write("expect: %d\n", rs + rt);
        $display;
      end
    3'b001:
      // SUB
      if (rd !== rs - rt) begin
        $display("[ERROR] SUB");
        $write("rs: %d\n", rs);
        $write("rt: %d\n", rt);
        $write("rd: %d\n", rd);
        $write("expect: %d\n", rs - rt);
        $display;
      end
    3'b010:
    // BITWISE AND;
      if (rd !== (rs & rt)) begin
        $display("[ERROR] BITWISE AND");
        $write("rs: %d\n", rs);
        $write("rt: %d\n", rt);
        $write("rd: %d\n", rd);
        $write("expect: %d\n", (rs & rt));
        $display;
      end
    3'b011:
      // BITWISE OR
      if (rd !== (rs | rt)) begin
        $display("[ERROR] BITWISE OR");
        $write("rs: %d\n", rs);
        $write("rt: %d\n", rt);
        $write("rd: %d\n", rd);
        $write("expect: %d\n", ~(rs | rt));
        $display;
      end
    3'b100:
      // RS CIR LEFT SHIFT 
      if (rd !== {rs[2:0], rs[3]} ) begin
        $display("[ERROR] RS CIR LEFT SHIFT");
        $write("rs: %d\n", rs);
        $write("rt: %d\n", rt);
        $write("rd: %d\n", rd);
        $write("expect: %d\n", {rs[2:0], rs[3]});
        $display;
      end
    3'b101:
      // RT ARI RIGHT SHIFT
      if (rd !== {rt[3], rt[3:1]}) begin
        $display("[ERROR] RT ARI RIGHT SHIFT");
        $write("rs: %d\n", rs);
        $write("rt: %d\n", rt);
        $write("rd: %d\n", rd);
        $write("expect: %d\n", {rt[3], rt[3:1]});
        $display;
      end
    3'b110:
      // COMPARE EQ
      if (rd !== {rs == rt}) begin
        $display("[ERROR] COMPARE EQ");
        $write("rs: %d\n", rs);
        $write("rt: %d\n", rt);
        $write("rd: %d\n", rd);
        $write("expect: %d\n", {rs == rt});
        $display;
      end
    3'b111:
      // COMPARE GT
      if (rd !== {rs > rt}) begin
        $display("[ERROR] COMPARE GT");
        $write("rs: %d\n", rs);
        $write("rt: %d\n", rt);
        $write("rd: %d\n", rd);
        $write("expect: %d\n", {rs > rt});
        $display;
      end
    default:
      $display("[ERROR] unknown sel: %d", sel);
  endcase
end
endtask

endmodule
