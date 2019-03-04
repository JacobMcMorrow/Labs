module lab_6(
	input [9:0] SW,
	input [1:0] KEY,
	output [6:0] HEX0, HEX2, HEX4, HEX5
);

	wire [3:0] ram_out;
	
	ram32x4 my_ram(
		.address(SW[8:4]),
		.clock(KEY[1]),
		.data(SW[3:0]),
		.wren(SW[9]),
		.q(ram_out)
		);
	
	hex_display HEX_0(ram_out, HEX0[6:0]); // data out
	hex_display HEX_2(SW[3:0], HEX2[6:0]); // data in
	hex_display HEX_4(SW[7:4], HEX4[6:0]); // lower 4 bit address
	hex_display HEX_5({3'b0, SW[8]}, HEX5[6:0]); // bit 5 address pad 0s to front
	
endmodule