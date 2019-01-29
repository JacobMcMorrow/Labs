module lab_2b(
	output [9:0] LEDR, // [9] LEDR for cout, [3:0] LEDR for sums
	input [8:0] SW, // [8] cin, [7:4] A, [3:0] B
	);
	
	wire fa0_cout, fa1_cout, fa2_cout;
	
	full_adder fa0(fa0_cout, LEDR[0], SW[4], SW[0], SW[8]);
	full_adder fa1(fa1_cout, LEDR[1], SW[5], SW[1], fa0_cout);
	full_adder fa2(fa2_cout, LEDR[2], SW[6], SW[2], fa1_cout);
	full_adder fa3(LEDR[9], LEDR[3], SW[7], SW[3], fa2_cout);
	
endmodule

module full_adder(cout, sum, a, b, cin);
	input a, b, cin;
	output cout, sum;
	
	assign cout = a & b | a & cin | b & cin;
	assign sum = a ^ b ^ cin;
endmodule