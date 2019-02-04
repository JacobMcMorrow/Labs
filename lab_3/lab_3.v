module lab_3(
	output [7:0] LEDR, // binary representation of ALUout[7:0]
	output [6:0] HEX0, // hex representation of Data
	output [6:0] HEX4, // display least significant bit of register
	output [6:0] HEX5, // display most significant bit of register
	input [9:0] SW,
	input [3:0] KEY
	);
	
	wire [7:0] ALUout, REGout;
	
	alu my_alu(ALUout, SW[3:0], REGout[3:0], KEY[3:1]);
	register my_register(REGout, KEY0, SW[9], ALUout);

	// Display Data in hex
	hex_display HEX_0(
		.IN(SW[3:0]),
		.OUT(HEX0[7:0])
		);

	// Display register out least and most significant bits
	hex_display HEX_4(
		.IN(REGout[3:0]),
		.OUT(HEX0[7:0])
		);
	
	hex_display HEX_5(
		.IN(REGout[7:3]),
		.OUT(HEX0[7:0])
		);
	
	// LEDR binary display for ALUout
	assign LEDR = ALUout;
endmodule

module alu(out, A, B, sel);
	output reg [7:0] out;
	input[3:0] A, B;
	input[2:0] sel;

	wire [7:0] fa_out;
	
	always @(*)
	begin
		case (sel)
			// A + B lab 2 full adder
			3'b000: begin
						full_adder_4bits(fa_out[4], fa_out[3:0], A, B, 0);
						out = fa_out;
					end
			// A + B verilog '+'
			3'b001: out = A + B;
			// A XOR B lower four bits A OR B upper four bits
			3'b010: begin
						out[7:4] = A | B;
						out[3:0] = A ^ B;
					end
			// output 1 if there is a 1 in the 2 inputs
			3'b011: out = |{A, B};
			// output 1 if there is a 1 in the 2 inputs
			3'b100: out = &{A, B};
			// Left shift B by A bits
			3'b101: out = B << A;
			// Right shift B by A bits 
			3'b110: out = B >> A;
			// A x B verilog '*'
			3'b111: out = A * B;
			// default to 8 bit 0
			default: out = 8'b00000000;
		endcase
	end
endmodule