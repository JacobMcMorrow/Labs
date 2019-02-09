module lab_4(
	output [6:0] HEX0,
	output [6:0] HEX1, 
	input [1:0] SW, // SW[1] enable, SW[0] clear_b
	input [3:0] KEY // using KEY[3] as clk
	);
	
	wire [7:0] Q;
	
	// counter_8bit(Q, enable, clk, clear_b)

	counter_8bit my_counter(
		Q[7:0],
		SW[1],
		KEY[3],
		SW[0]
		);

	
	// HEX displays HEX1 is most significant
	hex_display HEX_0(
		.IN(Q[3:0]),
		.OUT(HEX0[6:0])
		);
		
	hex_display HEX_1(
		.IN(Q[7:4]),
		.OUT(HEX1[6:0])
		);

endmodule


// TFF(Q, T, clk, clear_b)
module TFF(
	output reg Q,
	input T,
	input clk,
	input clear_b
	);
	
	always @(posedge clk, clear_b)
	begin
		if (clear_b == 1'b0)
			Q <= 0;
		else
			Q <= T;
	end

	
endmodule

// 8 bit counter ( Q[7:0], enable, clk, clear_b )

module counter_8bit(
	output [7:0] Q,
	input enable,
	input clk,
	input clear_b
	);
	
	wire Q0_and_en, Q1_and_Q0, Q2_and_Q1, Q3_and_Q2, Q4_and_Q3, Q5_and_Q4, Q6_and_Q5;
	
	assign Q0_and_en = Q[0] & enable;
	assign Q1_and_Q0 = Q[1] & Q0_and_en;
	assign Q2_and_Q1 = Q[2] & Q1_and_Q0;
	assign Q3_and_Q2 = Q[3] & Q2_and_Q1;
	assign Q4_and_Q3 = Q[4] & Q3_and_Q2;
	assign Q5_and_Q4 = Q[5] & Q4_and_Q3;
	assign Q6_and_Q5 = Q[6] & Q5_and_Q4;
	
	// TFF(Q, T, clk, clear_b)
	TFF TFF0(Q[0], enable, clk, clear_b); 
	TFF TFF1(Q[1], Q0_and_en, clk, clear_b); 
	TFF TFF2(Q[2], Q1_and_Q0, clk, clear_b); 
	TFF TFF3(Q[3], Q2_and_Q1, clk, clear_b); 
	TFF TFF4(Q[4], Q3_and_Q2, clk, clear_b); 
	TFF TFF5(Q[5], Q4_and_Q3, clk, clear_b); 
	TFF TFF6(Q[6], Q5_and_Q4, clk, clear_b); 
	TFF TFF7(Q[7], Q6_and_Q5, clk, clear_b); 
	
endmodule
