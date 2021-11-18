`timescale 1ns/1ps

module FPGA_UI (clk, in, start,reset, enter, AN, C, LED);
	input clk;
	input [3:0] in;
	input start, reset, enter;
	output reg [3:0] AN;
	output reg [6:0] C;
	output [15:0] LED;
	wire [15:0] LED_in;

	wire [2:0] state;
	wire [3:0] A, b;
	wire start_db, reset_db, enter_db;
	wire start_pulse, reset_pulse, enter_pulse;
	
	wire [1:0] clk_17;
	wire clk_second;
	reg [25:0] count;
	
	parameter S0 = 3'b000, 		// No guess
			  S1 = 3'b001, 		// First number guessed
			  S2 = 3'b010, 		// Second number guessed
			  S3 = 3'b011, 		// Third number guessed
			  DONE = 3'b100, 	// Fourth number guessed and show result 
			  INIT = 3'b101; 	// Initial
	
	assign clk_17 = count[16:15];
	assign clk_second = count[25];
	
	always @(posedge clk) begin
		count <= count + 1'b1;
	end
	
	reg [4:0] data;
	reg [4:0] flow [3:0];
	
	always @(*) begin
		case (state)
		INIT: begin
			flow[3] = 5'h1;
			flow[2] = 5'hA;
			flow[1] = 5'h2;
			flow[0] = 5'hB;
		end
		DONE: begin
			flow[3] = {1'b0,A};
			flow[2] = 5'hA;
			flow[1] = {1'b0,b};
			flow[0] = 5'hB;
		end
		S0: begin
			flow[3] = 5'h0;
			flow[2] = 5'h0;
			flow[1] = 5'h0;
			flow[0] = {clk_second,in};
		end
		S1: begin
			flow[3] = 5'h0;
			flow[2] = 5'h0;
			flow[1] = {1'b0,LED_in[3:0]};
			flow[0] = {clk_second,in};
		end
		S2: begin
			flow[3] = 5'h0;
			flow[2] = {1'b0,LED_in[3:0]};
			flow[1] = {1'b0,LED_in[7:4]};
			flow[0] = {clk_second,in};
		end
		S3: begin
			flow[3] = {1'b0,LED_in[3:0]};
			flow[2] = {1'b0,LED_in[7:4]};
			flow[1] = {1'b0,LED_in[11:8]};
			flow[0] = {clk_second,in};
		end
		default: begin
			flow[3] = 5'h1;
			flow[2] = 5'hA;
			flow[1] = 5'h2;
			flow[0] = 5'hB;
		end
		endcase
	end
	
	always @(*) begin
		case (clk_17)
		2'b00: begin
			AN = 4'b1110;
			data = flow[0];
		end
		2'b01: begin
			AN = 4'b1101;
			data = flow[1];
		end
		2'b10: begin
			AN = 4'b1011;
			data = flow[2];
		end
		2'b11: begin
			AN = 4'b0111;
			data = flow[3];
		end
		default: begin
			AN = 4'b1111;
			data = 4'b000;
		end
		endcase
	end
	
	always @(*)begin
        case(data)
        5'h0: C = 7'b0000001; // "0"     
        5'h1: C = 7'b1001111; // "1" 
        5'h2: C = 7'b0010010; // "2" 
        5'h3: C = 7'b0000110; // "3" 
        5'h4: C = 7'b1001100; // "4" 
        5'h5: C = 7'b0100100; // "5" 
        5'h6: C = 7'b0100000; // "6" 
        5'h7: C = 7'b0001111; // "7" 
        5'h8: C = 7'b0000000; // "8"     
        5'h9: C = 7'b0000100; // "9"
		5'hA: C = 7'b0001000; // "A"
		5'hB: C = 7'b1100000; // "b"
		5'hC: C = 7'b0110001; // "C"
		5'hD: C = 7'b1000010; // "d"
		5'hE: C = 7'b0110000; // "E"
		5'hF: C = 7'b0111000; // "F"
        default: C = 7'b1111111; // "dead"
        endcase
    end
	
	
	The_1A2b_Game theGame (
		.clk(clk_second), 
		.in(in), 
		.start(start_pulse), 
		.reset(reset_pulse), 
		.enter(enter_pulse), 
		.state(state), 
		.A(A), 
		.b(b), 
		.mem(LED_in),
		.key_out(LED)
	);
	
	onepulse start_onepulser(
		.out(start_pulse), 
		.in(start_db), 
		.clk(clk_second)
	);
	onepulse reset_onepulser(
		.out(reset_pulse), 
		.in(reset_db), 
		.clk(clk_second)
	);
	onepulse enter_onepulser(
		.out(enter_pulse), 
		.in(enter_db), 
		.clk(clk_second)
	);
	
	debounce start_debouncer(
		.out(start_db), 
		.in(start), 
		.clk(clk_17[1])
	);
	debounce reset_debouncer(
		.out(reset_db), 
		.in(reset), 
		.clk(clk_17[1])
	);
	debounce enter_debouncer(
		.out(enter_db), 
		.in(enter), 
		.clk(clk_17[1])
	);

endmodule

// Onepulse: Eliminate input more than a clock cycle.
module onepulse (out, in, clk);
	input in;
	input clk;
	output reg out;
	
	reg delay;
	
	always @(posedge clk) begin
		out <= in & (! delay);
		delay <= in;
	end
	
endmodule

// Debounce: Eliminate any glitches.
module debounce (out, in, clk);
	output out;	// signal of a pushbutton after being debounced
	input in;	// signal from a pushbutton 
	input clk; 

	reg [3:0] DFF;         // use shift_reg to filter pushbutton bounce 
	
	always @(posedge clk) begin
		DFF[3:1] <= DFF[2:0];
		DFF[0] <= in;
	end
	
	assign out = &DFF;

endmodule

// The 1A2b Game: Main Game Program.
module The_1A2b_Game (clk, in, start, reset, enter, state, A, b, mem, key_out);
	input [3:0] in;
	input start;
	input clk;
	input reset;
	input enter;
	
	output reg [2:0] A, b;
	output reg [2:0] state;
	output reg [15:0] mem;
	output [15:0] key_out;
	
	reg [2:0] next_A, next_b;
	reg [2:0] next_state;
	reg [3:0] next_mem [3:0];
	
	wire [1:0] index_guessed;
	wire [15:0] key;
	
	wire exist;
	wire lose, index_matched, overflow;
	reg random;
	
	parameter S0 = 3'b000, 		// No guess
			  S1 = 3'b001, 		// First number guessed
			  S2 = 3'b010, 		// Second number guessed
			  S3 = 3'b011, 		// Third number guessed
			  DONE = 3'b100, 	// Fourth number guessed and show result 
			  INIT = 3'b101; 	// Initial
    
    assign lose = (A!==3'b100);
    assign index_matched = (state === {1'b0,index_guessed});
    assign overflow = in[3]&&(in[2]||in[1]);
    
	always@(posedge clk) begin
		if(reset) begin
			state <= INIT;
			A <= 3'b000;
			b <= 3'b000;
			mem[3:0] <= 4'b0000;
			mem[7:4] <= 4'b0000;
			mem[11:8] <= 4'b0000;
			mem[15:12] <= 4'b0000;
		end else begin
			state <= next_state;
			A <= next_A;
			b <= next_b;
			mem[3:0] <= next_mem[0];
			mem[7:4] <= next_mem[1];
			mem[11:8] <= next_mem[2];
			mem[15:12] <= next_mem[3];
		end
	end
	//assign random = ((state===INIT)&&(start))||((state===DONE)&&(enter)&&(lose));
	always @(posedge clk) begin
	    case (state)
		INIT: begin
			if(start) random = 1'b1;
			else random = 1'b0;
		end
		DONE: begin
			if(enter) begin
				if(lose) begin
					random = 1'b1;
				end else begin
					random = 1'b0;
				end
			end else random = 1'b0;
		end
		default: random = 1'b0;
		endcase
	end
	
	always @(*) begin
		next_state = state;
		next_A = A;
		next_b = b;
		next_mem[0] = mem[3:0];
		next_mem[1] = mem[7:4];
		next_mem[2] = mem[11:8];
		next_mem[3] = mem[15:12];
		
		case (state)
		INIT : begin
		    next_mem [0] = 4'h0;
		    next_mem [1] = 4'h0;
		    next_mem [2] = 4'h0;
		    next_mem [3] = 4'h0;
			if(start) begin // prep for new game
				next_state = S0;
				next_A = 3'b000;
				next_b = 3'b000;
			end else begin
				next_state = state;
				next_A = A;
				next_b = b;
			end
		end
		S0,S1,S2,S3: begin
			if(enter) begin
			    if(!overflow) begin
				    next_mem[state] = in;
                    next_state = state + 3'b001;
                    if (exist) begin
                        if(index_matched) begin	// match index
                            next_A = A + 2'b01;
                            next_b = b;
                        end else begin 			// only found
                            next_A = A;
                            next_b = b + 2'b01;
                        end
                    end else begin
                        next_A = A;
                        next_b = b;
                    end
                end else begin
                    next_state = state;
                    next_A = A;
                    next_b = b;
                end
			end else begin
				next_state = state;
				next_A = A;
				next_b = b;
			end
			end
		DONE: begin
			if(enter) begin
                next_mem [0] = 4'h0;
                next_mem [1] = 4'h0;
                next_mem [2] = 4'h0;
                next_mem [3] = 4'h0;
				if(!lose) begin
					next_state = INIT; 
					next_A = 3'b000;
					next_b = 3'b000;
				end else begin // prep for new game
					next_state = S0; 
					next_A = 3'b000;
					next_b = 3'b000;
				end
			end else begin
				next_state = state;
				next_A = A;
				next_b = b;
			end
			end
		default: begin
			next_state = INIT;
			next_A = A;
			next_b = b;
		end
		endcase
	end
	
	assign key_out = ({16{state!==INIT}})&(key);
	
    Random_Compare_Generator RCG(
		.clk(clk), 
		.reset(reset), 
		.enable(random), 
		.din(in), 
		.dout(index_guessed), 
		.exist(exist),
		.ans_key(key)
		);

endmodule


// Random Compare Generator: 
//		Input all 16-bits when wen.
//		Output exist = 1, when din exist inside.
//		Output dout = index, where din was found.
module Random_Compare_Generator(clk, reset, enable, din, dout, exist, ans_key);
    input clk;
    input reset; // reset the LFSR
    input enable;   // trigger LFSR new random data
    input [3:0] din;
    output [1:0] dout;
    output exist;
    output [15:0] ans_key;
    
    wire [15:0] random_data;
    wire [3:0] compare_val;
    
    assign ans_key = random_data;
    
    Random_Generator randomGen (
		.out(random_data), 
		.clk(clk), 
		.reset(reset), 
		.en(enable)
	);
    Comparator_Array comp_0 (
		.out(compare_val[0]), 
		.a(random_data[15:12]), 
		.b(din)
    );
    Comparator_Array comp_1 (
		.out(compare_val[1]), 
		.a(random_data[11:8]), 
		.b(din)
    );
    Comparator_Array comp_2 (
		.out(compare_val[2]), 
        .a(random_data[7:4]), 
        .b(din)
    );
    Comparator_Array comp_3 (
        .out(compare_val[3]), 
        .a(random_data[3:0]), 
        .b(din)
    );
    Priority_Encoder prior_addr_out(
        .out(dout),
        .valid(exist), 
        .in(compare_val)
    );
	
endmodule

// Comparator Array: Return 1 if value a same as b, else 0.
module Comparator_Array(out, a, b);
    input [3:0] a, b;
    output out;
    assign out = &(a~^b);
endmodule

// Priority Encoder: Highest Index Locator.
module Priority_Encoder(out, valid, in);
    parameter n = 4, m = 2;
    input [n-1:0] in;
    output reg [m-1:0] out;
    output valid;
    
    assign valid = |in;
    
    always@ (*) begin
		if(in[3])begin out = 2'b11;
        end else if(in[2])begin out = 2'b10;
        end else if(in[1])begin out = 2'b01;
        end else if(in[0])begin out = 2'b00;
        end else begin out = 2'b00;
        end
    end
	
endmodule

// Random_Generator:
//		Turn En to 1 trigger generator generate new random combination. 
//		Crossbar controlled with LSFR (random).
//		Output will assigned to crossbar output index 9, 8, 1, and 0.
module Random_Generator (out, clk, reset, en);
	input clk;
	input reset;
	input en;
	output [15:0] out;
    
	reg [3:0] mem [9:0];
	reg [3:0] next_mem [9:0];
	reg [31:0] next;
	reg [31:0] state = 32'b1101_1110_1011_1101_1010_0100_1101_0111;
	
	wire [3:0] cross_out [9:0];

	assign out = {next_mem[9],next_mem[8],next_mem[1],next_mem[0]};
    
	always @(posedge clk) begin
		if(reset===1'b1) begin
			state <= next;
			mem[0] <= 4'd0;
			mem[1] <= 4'd1;
			mem[2] <= 4'd2;
			mem[3] <= 4'd3;
			mem[4] <= 4'd4;
			mem[5] <= 4'd5;
			mem[6] <= 4'd6;
			mem[7] <= 4'd7;
			mem[8] <= 4'd8;
			mem[9] <= 4'd9;
		end else begin
			state <= next;
			mem[0] <= next_mem[0];
			mem[1] <= next_mem[1];
			mem[2] <= next_mem[2];
			mem[3] <= next_mem[3];
			mem[4] <= next_mem[4];
			mem[5] <= next_mem[5];
			mem[6] <= next_mem[6];
			mem[7] <= next_mem[7];
			mem[8] <= next_mem[8];
			mem[9] <= next_mem[9];
		end
	end
    
	always@(*)begin
	    if(en) begin
            next[0] = state[31];
            next[1] = state[0];
            next[2] = state[31]^state[1];
            next[3] = state[31]^state[2];
            next[4] = state[3];
            next[5] = state[31]^state[4];
            next[31:6] = state[30:5];
            next_mem[0] = cross_out[0];
		    next_mem[1] = cross_out[1];
		    next_mem[2] = cross_out[2];
		    next_mem[3] = cross_out[3];
		    next_mem[4] = cross_out[4];
		    next_mem[5] = cross_out[5];
		    next_mem[6] = cross_out[6];
		    next_mem[7] = cross_out[7];
		    next_mem[8] = cross_out[8];
		    next_mem[9] = cross_out[9];
		end else begin
	   		next = state;
		    next_mem[0] = mem[0];
		    next_mem[1] = mem[1];
		    next_mem[2] = mem[2];
		    next_mem[3] = mem[3];
		    next_mem[4] = mem[4];
		    next_mem[5] = mem[5];
		    next_mem[6] = mem[6];
		    next_mem[7] = mem[7];
		    next_mem[8] = mem[8];
		    next_mem[9] = mem[9];
		end
	end
	
	Crossbar_10x10_4bit cb10 (
		.in1(mem[0]), 
		.in2(mem[1]), 
		.in3(mem[2]), 
		.in4(mem[3]),
		.in5(mem[4]), 
		.in6(mem[5]), 
		.in7(mem[6]), 
		.in8(mem[7]),
		.in9(mem[8]), 
		.in10(mem[9]),  
		.out1(cross_out[0]), 
		.out2(cross_out[1]), 
		.out3(cross_out[2]), 
		.out4(cross_out[3]),
		.out5(cross_out[4]), 
		.out6(cross_out[5]), 
		.out7(cross_out[6]), 
		.out8(cross_out[7]),
		.out9(cross_out[8]), 
		.out10(cross_out[9]),
		.control(state)
	);

endmodule





// CROSSBAR 10x10 4-bits

`timescale 1ns/1ps

module Crossbar_10x10_4bit(in1, in2, in3, in4, in5, in6, in7, in8, in9, in10,
                           out1, out2, out3, out4, out5, out6, out7, out8, out9, out10, 
                           control);
	input [3:0] in1, in2, in3, in4, in5, in6, in7, in8, in9, in10;
	input [31:0] control;
	output [3:0] out1, out2, out3, out4, out5, out6, out7, out8, out9, out10;

	wire [3:0] 
	wire00, wire01, wire02, wire03,
	wire10, wire11,
	wire20, wire21, wire22, wire23,
	wire30, wire31, wire32, wire33,
	wire40, wire41, wire42, wire43,
	wire50, wire51, wire52, wire53,
	wire60, wire61,
	wire70, wire71, wire72, wire73;

	Crossbar_4x4_4bit cb4_0 (
		.in1(in1), 
		.in2(in2), 
		.in3(in3), 
		.in4(in4), 
		.out1(wire00), 
		.out2(wire01), 
		.out3(wire02), 
		.out4(wire03), 
		.control(control[4:0])
	);
	Crossbar_2x2_4bit cb2_1(
		.in1(in5),
		.in2(in6),
		.control(control[5]),
		.out1(wire10),
		.out2(wire11)
	);
	Crossbar_4x4_4bit cb4_2 (
		.in1(in7), 
		.in2(in8), 
		.in3(in9), 
		.in4(in10), 
		.out1(wire20), 
		.out2(wire21), 
		.out3(wire22), 
		.out4(wire23), 
		.control(control[10:6])
	);
	Crossbar_4x4_4bit cb4_3 (
		.in1(wire01), 
		.in2(wire02), 
		.in3(wire03), 
		.in4(wire10), 
		.out1(wire30), 
		.out2(wire31), 
		.out3(wire32), 
		.out4(wire33), 
		.control(control[15:11])
	);
	Crossbar_4x4_4bit cb4_4 (
		.in1(wire11), 
		.in2(wire20), 
		.in3(wire21), 
		.in4(wire22), 
		.out1(wire40), 
		.out2(wire41), 
		.out3(wire42), 
		.out4(wire43), 
		.control(control[20:16])
	);
	Crossbar_4x4_4bit cb4_5 (
		.in1(wire00), 
		.in2(wire30), 
		.in3(wire31), 
		.in4(wire32), 
		.out1(out1), 
		.out2(out2), 
		.out3(out3), 
		.out4(out4), 
		.control(control[25:21])
	);
	Crossbar_2x2_4bit cb2_6(
		.in1(wire33),
		.in2(wire40),
		.control(control[26]),
		.out1(out5),
		.out2(out6)
	);
	Crossbar_4x4_4bit cb4_7 (
		.in1(wire41), 
		.in2(wire42), 
		.in3(wire43), 
		.in4(wire23), 
		.out1(out7), 
		.out2(out8), 
		.out3(out9), 
		.out4(out10), 
		.control(control[31:27])
	);
	
endmodule

module Crossbar_4x4_4bit(in1, in2, in3, in4, out1, out2, out3, out4, control);
	input [3:0] in1, in2, in3, in4;
	input [4:0] control;
	output [3:0] out1, out2, out3, out4;

	wire [3:0] wire03 ,wire02, wire12, wire14, wire23, wire24;
	
	Crossbar_2x2_4bit cb2_0(
		.in1(in1),
		.in2(in2),
		.control(control[0]),
		.out1(wire03),
		.out2(wire02)
	);

	Crossbar_2x2_4bit cb2_1(
		.in1(in3),
		.in2(in4),
		.control(control[1]),
		.out1(wire12),
		.out2(wire14)
	);
							
	Crossbar_2x2_4bit cb2_2(
		.in1(wire02),
		.in2(wire12),
		.control(control[2]),
		.out1(wire23),
		.out2(wire24)
	);
							
	Crossbar_2x2_4bit cb2_3(
		.in1(wire03),
		.in2(wire23),
		.control(control[3]),
		.out1(out1),
		.out2(out2)
	);
							
	Crossbar_2x2_4bit cb2_4(
		.in1(wire24),
		.in2(wire14),
		.control(control[4]),
		.out1(out3),
		.out2(out4)
	);
	
endmodule


module Crossbar_2x2_4bit(in1, in2, control, out1, out2);
	input [3:0] in1, in2;
	input control;
	output [3:0] out1, out2;

	wire neg_control;
	not neg(neg_control, control);

	wire [3:0] wire11, wire12, wire21, wire22;

	Dmux_1x2_4bit dmux1 (
		.in(in1), 
		.out1(wire11), 
		.out2(wire12), 
		.control(neg_control)
	);
	Dmux_1x2_4bit dmux2 (
		.in(in2), 
		.out1(wire21), 
		.out2(wire22), 
		.control(control)
	);

	Mux_1x2_4bit mux1 (
		.in1(wire11), 
		.in2(wire21), 
		.out(out1), 
		.control(neg_control)
	);
	Mux_1x2_4bit mux2 (
		.in1(wire12), 
		.in2(wire22), 
		.out(out2), 
		.control(control)
	);

endmodule

module Dmux_1x2_4bit(in, out1, out2, control);
	input [3:0] in;
	input control;
	output [3:0] out1, out2;

	wire neg_control;
	not neg(neg_control, control);

	and and0 [3:0](out1, in, {4{neg_control}});
	and and1 [3:0](out2, in, {4{control}});

endmodule

module Mux_1x2_4bit(in1, in2, out, control);
	input [3:0] in1, in2;
	input control;
	output [3:0] out;

	wire neg_control;
	not neg(neg_control, control);

	wire [3:0] out1,out2;

	and and0 [3:0](out1, in1, {4{neg_control}});
	and and1 [3:0](out2, in2, {4{control}});

	or or1 [3:0] (out, out1, out2);

endmodule
