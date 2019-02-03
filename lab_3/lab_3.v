module lab_3(
	input [9:0] SW,
	output [9:0] LEDR // will only use 0
	);
	
	alu my_alu(LEDR[0], SW[6:0], SW[9:7]);
endmodule

module alu(
	output reg out,
	input[6:0] SW,
	input[2:0] sel
	);
	
	always @(*)
	begin
		case (sel)
			// A + B full adder
			3'b000: out = SW[0];
			// A + B verilog '+'
			3'b001: out = SW[1];
			// A XOR B lower four bits A OR B upper four bits
			3'b010: out = SW[2];
			// 
			3'b011: out = SW[3];
			// 
			3'b100: out = SW[4];
			// 
			3'b101: out = SW[5];
			// 
			3'b110: out = SW[6];
			default: out = 1'b0; // default to 1 bit 0
		endcase
	end
endmodule