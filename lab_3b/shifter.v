module lab_3b(
	output [7:0] LEDR, // connect to Q[7:0] on shifter
	input [9:0] SW, // 7:0 for load val, 9 for reset
	input [3:0] KEY // 3 for ASR, 2 for ShiftRight, 1 for Load_n, 0 for clock
	);
	
	Shifter shifter_8bit(
		.Q(LEDR[7:0]),
		.load_val(SW[7:0]),
		.load_n(KEY[1]),
		.shiftright(KEY[2]),
		.clk(KEY[0]),
		.reset_n(SW[9]),
		.ASR(KEY[3])
		);
	
endmodule

module ShifterBit(
	output reg out,
	input in,
	input load_val,
	input load_n,
	input shiftright,
	input clk,
	input reset_n
	);
	
	wire shift_mux_out, load_mux_out;
	
	// mux
	mux2to1 shift_mux(out, in, shiftright, shift_mux_out);
	mux2to1 load_mux(load_val, shift_mux_out, load_n, load_mux_out);
	
	// dff
	always @(posedge clk)
	begin
		if (reset_n == 1'b0)
			out <= 0;
		else
			out <= load_mux_out;
	end

endmodule
	
module Shifter(
	output [7:0] Q,
	input [7:0] load_val,
	input load_n,
	input shiftright,
	input clk,
	input reset_n,
	input ASR // shifter only
	);
	
	reg load_bit;
	
	always@(ASR, Q[7])
	begin
		if (ASR == 1'b1)
			// copy bit 7 if ASR is high
			load_bit <= Q[7];
		else
			load_bit <= 0;
	end
	
	// ShifterBit (out, in, load_val, load_n, shift, clk, reset_n)
	ShifterBit bit7(Q[7], load_bit, load_val[7], load_n, shiftright, reset_n); // left most bit depend on ASR as the input
	ShifterBit bit6(Q[6], Q[7], load_val[6], load_n, shiftright, reset_n);
	ShifterBit bit5(Q[5], Q[6], load_val[5], load_n, shiftright, reset_n);
	ShifterBit bit4(Q[4], Q[5], load_val[4], load_n, shiftright, reset_n);
	ShifterBit bit3(Q[3], Q[4], load_val[3], load_n, shiftright, reset_n);
	ShifterBit bit2(Q[2], Q[3], load_val[2], load_n, shiftright, reset_n);
	ShifterBit bit1(Q[1], Q[2], load_val[1], load_n, shiftright, reset_n);
	ShifterBit bit0(Q[0], Q[1], load_val[0], load_n, shiftright, reset_n);
	
endmodule

module mux2to1(x, y, s, m);
    input x; //selected when s is 0
    input y; //selected when s is 1
    input s; //select signal
    output m; //output
  
    assign m = s & y | ~s & x;
    // OR
    // assign m = s ? y : x;
endmodule
