module lab_2b(
	output [9:0] LEDR, // [9] LEDR for cout, [3:0] LEDR for sums
	input [8:0] SW, // [8] cin, [7:4] A, [3:0] B
	);
	
	full_adder_4bits(LEDR[9], LEDR[3:0], SW[7:4], SW[3:0], SW[8]);
	
endmodule

module full_adder(cout, sum, a, b, cin);
	input a, b, cin;
	output cout, sum;
	
	assign cout = a & b | a & cin | b & cin;
	assign sum = a ^ b ^ cin;
endmodule

module full_adder_4bits(cout, sum, a, b, cin);
	output cout;
	output [3:0] sum;
	input [3:0] a, b;
	input cin;
	
	wire fa0_cout, fa1_cout, fa2_cout;
	
	full_adder fa0(fa0_cout, sum[0], a[0], b[0], cin);
	full_adder fa1(fa1_cout, sum[1], a[1], b[1], fa0_cout);
	full_adder fa2(fa2_cout, sum[2], a[2], b[2], fa1_cout);
	full_adder fa3(cout, sum[3], a[3], b[3], fa2_cout);
	
endmodule
	
