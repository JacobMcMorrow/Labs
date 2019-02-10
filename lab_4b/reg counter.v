module lab_4b(
	output [6:0] HEX0,
	input [8:0] SW,
	input CLOCK_50
	);
	
	wire [3:0] counter_out;
	
	// register_4bit(q, d, sel, clear_b, parload, clk)
	register_4bit my_counter(
		.q(counter_out[3:0]),
		.d(SW[5:2]),
		.sel(SW[1:0]),
		.clear_b(SW[6]),
		.parload(SW[7]),
		.clk(CLOCK_50)
		);
	
	hex_display(
		.IN(counter_out[3:0]),
		.OUT(HEX0[6:0])
		);
	
endmodule

module register_4bit(
	output [3:0] q,
	input [3:0] d,
	input [1:0] sel,
	input clear_b,
	input parload,
	input clk
	);
	
	wire [27:0] rd0_out, rd1_out, rd2_out, rd3_out;
	reg enable;

	// rate_divider(out, max_clock, clk)
	rate_divider rd0(rd0_out, 28'b0, clk);
	rate_divider rd1(rd1_out, 28'b10_1111_1010_1111_0000_0111_1111, clk);
	rate_divider rd2(rd2_out, 28'b101_1111_0101_1110_0000_1111_1111, clk);
	rate_divider rd3(rd3_out, 28'b1011_1110_1011_1100_0001_1111_1111, clk);
	
	// display_counter(out, enable, clear_b, parload, load, clk)
	display_counter(q, enable, clear_b, parload, d, clk);
	
	always @(*)
	begin
		case (sel)
			2'b00: enable = (rd0_out == 28'b0) ? 1 : 0; 
			2'b01: enable = (rd1_out == 28'b0) ? 1 : 0; 
			2'b10: enable = (rd2_out == 28'b0) ? 1 : 0; 
			2'b11: enable = (rd3_out == 28'b0) ? 1 : 0; 
		endcase
	end
	
endmodule

module rate_divider(
	output reg [27:0] out,
	input [27:0] max_clock,
	input clk
	);
	
	always @(posedge clk)
	begin
		if (out == 28'b0)
			out <= max_clock;
		else
			out <= out - 1;
	end
	
endmodule

module display_counter(out, enable, clear_b, parload, load, clk);
	output reg [3:0] out;
	input enable, clear_b, clk;
	input parload;
	input [3:0] load;
	
	always @(posedge clk)
	begin
		if (clear_b == 1'b0)
			out <= 0;
		else if (parload == 1'b1)
			out <= load;
		else if (out == 4'b1111)
			out <= 0;
		else if (enable == 1'b1)
			out <= out + 1'b1;
	end
	
	
endmodule
