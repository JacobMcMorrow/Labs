module lab_2c(
	output [7:0] LEDR, // binary representation of ALUout[7:0]
	output [6:0] HEX0, // display value of B
	output [6:0] HEX1, // set to display 0
	output [6:0] HEX2, // display value of A
	output [6:0] HEX3, // set to display 0
	output [6:0] HEX4, // display addition results ALUout[3:0]
	output [6:0] HEX5, // display addition results ALUout[7:4]
	input [7:0] SW,
	input [2:0] KEY
	);
	
	wire [7:0] ALUout, ALUtoMux_case0, ALUtoMux_case1, ALUtoMux_case2;
	wire [7:0] ALUtoMux_case3, ALUtoMux_case4, ALUtoMux_case5, ALUtoMux_default;
	wire [7:0] ABin;
	
	// concatenate A and B for ALUin
	assign ABin = {A, B};
	
	// 8 bit mux
	mux7to1_8bit my_mux(
		ALUout,
		ALUtoMux_case0,
		ALUtoMux_case1,
		ALUtoMux_case2,
		ALUtoMux_case3,
		ALUtoMux_case4,
		ALUtoMux_case5,
		ALUtoMux_default,
		KEY[2:0]
		);
	
	// ALU
	ALU my_ALU(
		ALUtoMux_case0,
		ALUtoMux_case1,
		ALUtoMux_case2,
		ALUtoMux_case3,
		ALUtoMux_case4,
		ALUtoMux_case5,
		ALUtoMux_default,
		ABin
		);
		
	// HEX 0 and 2
	hex_display HEX0(
		.IN(SW[3:0]),
		.OUT(HEX0[6:0])
		);
	
	hex_display HEX2(
		.IN(SW[7:4]),
		.OUT(HEX2[6:0])
		);
	
	// HEX 1 and 3 - set to display 0
	hex_display HEX1(
		.IN(3'b0000),
		.OUT(HEX1[6:0])
		);
		
	hex_display HEX3(
		.IN(3'b0000),
		.OUT(HEX3[6:0])
		);
	
	// HEX 4 and 5 display using HEX decoder
	hex_display HEX4)
		.IN(ALUout[3:0]),
		.OUT(HEX4[6:0])
		);
	
	hex_display HEX5)
		.IN(ALUout[7:4]),
		.OUT(HEX5[6:0])
		);
		
	
	// LEDR binary display for ALUout
	assign LEDR = ALUout;
	
	
module mux7to1_8bit(out, in0, in1, in2, in3, in4, in5, in6, sel);
	output [7:0] out;
	input [7:0] in0, in1, in2, in3, in4, in5, in6;
	input[2:0] sel;
	
	always @(*)
	begin
		case (sel)
			3'b000: out = in0;
			3'b001: out = in1;
			3'b010: out = in2;
			3'b011: out = in3;
			3'b100: out = in4;
			3'b101: out = in5;
			default: out = 1'b0; // default to 1 bit 0
		endcase
	end
endmodule

module ALU(
	output [7:0] ALUout_case0,
	output [7:0] ALUout_case1,
	output [7:0] ALUout_case2,
	output [7:0] ALUout_case3,
	output [7:0] ALUout_case4,
	output [7:0] ALUout_case5,
	output [7:0] ALUout_default,
	input [7:0] ALUin
	);
	
	// default case
	assign ALUout_default = 8'b00000000;
	
	// case 0 - ALUout[4] is cout and ALUin[3:0] is sum
	full_adder_4bits(ALUout_case0[4], ALUout_case0[3:0], ALUin[7:4], ALUin[3:0], 0);
	
	// case 1 - A+B
	assign ALUout_case1 = ALUin[7:4] + ALUin[3:0];
	
	// case 2 - A XOR B in lower 4 bits and A or B in upper 4 bits
	assign ALUout_case2 [7:4] = ALUin[7:4] | ALUin[3:0];
	assign ALUout_case2 [3:0] = ALUin[7:4] ^ ALUin[3:0];
	
	// case 3 - output 1 if there is a 1 in the 2 inputs
	assign ALUout_case3 = |{A, B}; // not sure if I can put both in 1 line
	
	// case 4 - output 1 if all the bits are 1
	assign ALUout_case4 = &{A, B}; // not sure if I can put both in 1 line
	
	// case 5 - concatenate A and B to BA
	assign ALUout_case5 = {B, A};
	
endmodule
	