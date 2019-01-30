module lab_2(
	input [9:0] SW,
	output [9:0] LEDR // will only use 0
	);
	
	mux7to1 mux1(LEDR[0], SW[6:0], SW[9:7]);
endmodule

module mux7to1(
	output reg out,
	input[6:0] SW,
	input[2:0] sel
	);
	
	always @(*)
	begin
		case (sel)
			3'b000: out = SW[0];
			3'b001: out = SW[1];
			3'b010: out = SW[2];
			3'b011: out = SW[3];
			3'b100: out = SW[4];
			3'b101: out = SW[5];
			3'b110: out = SW[6];
			default: out = 1'b0; // default to 1 bit 0
		endcase
	end
endmodule
