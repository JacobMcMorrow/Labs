// Part 2 skeleton

module lab_6b
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire resetn;
	reg [6:0] load_x;
	assign resetn = KEY[0];
	assign colour = SW[9:7];
	
	always @(~KEY[3]) // because keys are flipped
	begin
		assign load_x <= SW[6:0];
	end
	
	assign x = load_x;
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.
    
    // Instansiate datapath
	// datapath d0(...);

    // Instansiate FSM control
    // control c0(...);
    
endmodule

module control(
		input go,
		input reset,
		input clk,
		output out
	)
	
	wire [3:0] counter_out;
	
	counter_4bit count(counter_out, 1, clk);
	
	reg [4:0] current_state, next_state;
	localparam S_LOAD_WAIT = 5'd0,
		S_PIXEL1 = 5'd1,
		S_PIXEL2 = 5'd2,
		S_PIXEL3 = 5'd3,
		S_PIXEL4 = 5'd4,
		S_PIXEL5 = 5'd5,
		S_PIXEL6 = 5'd6,
		S_PIXEL7 = 5'd7,
		S_PIXEL8 = 5'd8,
		S_PIXEL9 = 5'd9,
		S_PIXEL10 = 5'd10,
		S_PIXEL11 = 5'd11,
		S_PIXEL12 = 5'd12,
		S_PIXEL13 = 5'd13,
		S_PIXEL14 = 5'd14,
		S_PIXEL15 = 5'd15,
		S_PIXEL16 = 5'd16;
	
	// state table
	always @(*)
	begin: state_table
		case(current_state)
			S_LOAD_WAIT: next_state = go ? S_LOAD_WAIT : S_PIXEL1; // loop until signal goes low
			S_PIXEL1: next_state = S_PIXEL2;
			S_PIXEL2: next_state = S_PIXEL3;
			S_PIXEL3: next_state = S_PIXEL4;
			S_PIXEL4: next_state = S_PIXEL5;
			S_PIXEL5: next_state = S_PIXEL6;
			S_PIXEL6: next_state = S_PIXEL7;
			S_PIXEL7: next_state = S_PIXEL8;
			S_PIXEL8: next_state = S_PIXEL9;
			S_PIXEL9: next_state = S_PIXEL10;
			S_PIXEL10: next_state = S_PIXEL11;
			S_PIXEL11: next_state = S_PIXEL12;
			S_PIXEL12: next_state = S_PIXEL13;
			S_PIXEL13: next_state = S_PIXEL14;
			S_PIXEL14: next_state = S_PIXEL15;
			S_PIXEL15: next_state = S_PIXEL16;
			S_PIXEL16: next_state = S_LOAD_WAIT;
		default: next_state = S_LOAD_WAIT;
		endcase
	end
	
	// TODO: output logic for datapath
	// probably something like x + counter_out[1:0] and y + counter_out[3:2]
	
	// current state FFs
	always @(posedge clk)
	begin: state_FFs
		if (!reset)
			current_state <= S_LOAD_WAIT;
		else
			current_state <= next_state;
	end
endmodule

module counter_4bit(
	output [3:0] Q,
	input en,
	input clk
);
	
	wire Q0_and_en, Q1_and_Q0, Q2_and_Q1;
	
	assign Q0_and_en = Q[0] & en;
	assign Q1_and_Q0 = Q[1] & Q0_and_en;
	assign Q2_and_Q1 = Q[2] & Q1_and_Q0;
	
	// T_FF (Q, T, clk)
	T_FF TFF0(Q[0], en, clk);
	T_FF TFF1(Q[1], Q0_and_en, clk);
	T_FF TFF2(Q[2], Q1_and_Q0, clk);
	T_FF TFF3(Q[3], Q2_and_Q1, clk);
	
endmodule

module T_FF(
	output reg Q,
	input T,
	input clk
);
	always @(posedge clk)
	begin
		Q <= Q ^ T;
	end
endmodule

