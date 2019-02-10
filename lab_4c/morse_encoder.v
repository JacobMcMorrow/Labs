module lab_4c(
	output [7:0] LEDR, // how to init just 1?
	input [2:0] SW, // letters
	input [1:0] KEY, // Key 0 reset, Key 1 for morse code
	input CLOCK_50
	);
	
	wire clk, encoder_out;
	
	clock_rate Clock_2Hz(clk, CLOCK_50);
	encoder (encoder_out, SW[2:0], KEY[0], KEY[1], clk);
	
	assign LEDR[0] = encoder_out;
	
endmodule

module encoder(
	output out,
	input [2:0] sel, // select letters
	input reset_n, // key 0
	input load_n, // key 1
	input clk
	);

	reg [11:0] letter;
	
	// look up table for letters
	always @(*)
	begin
		case (sel[2:0])
		3'b000: letter = 12'b1011_1000_0000; // A
		3'b001: letter = 12'b1110_1010_1000; // B
		3'b010: letter = 12'b1110_1011_1010; // C
		3'b011: letter = 12'b1110_1010_0000; // D
		3'b100: letter = 12'b1000_0000_0000; // E
		3'b101: letter = 12'b1010_1110_1000; // F
		3'b110: letter = 12'b1110_1110_1000; // G
		3'b111: letter = 12'b1010_1010_0000; // H
		default: letter = 12'b0;
		endcase
	end
	
	// 12-bit left shift register
	// shift_register_12bit(out, letter, load_n, reset_n, clk)
	shift_register_12bit(out, letter, load_n, reset_n, clk);
			

endmodule

module clock_rate(
	output reg slowed_clk, // 2Hz clk out
	input clk // 50MHz clk in
	);
	
	reg [24:0] counter;
	
	// 24999999 in dec
	always @(posedge clk)
	begin
		if (counter == 25'b0)
			begin
				counter <= 25'b1_0111_1101_0111_1000_0011_1111;
				slowed_clk <= 1;
			end
		else
			begin
				counter <= counter + 25'b1;
				slowed_clk <= 0;
			end
	end

endmodule

module shift_register_12bit(
	output out, // most significant bit
	input [11:0] letter,
	input load_n,
	input reset_n,
	input clk
	);
	
	wire [10:0] bit_out;
	// ShifterBit(out, in, load_val, load_n, shift, clk, reset_n)
	// we are shifting left
	ShifterBit bit11(out, bit_out[10], letter[11], load_n, 1, clk, reset_n);
	ShifterBit bit10(bit_out[10], bit_out[9], letter[10], load_n, 1, clk, reset_n);
	ShifterBit bit9(bit_out[9], bit_out[8], letter[9], load_n, 1, clk, reset_n);
	ShifterBit bit8(bit_out[8], bit_out[7], letter[8], load_n, 1, clk, reset_n);
	ShifterBit bit7(bit_out[7], bit_out[6], letter[7], load_n, 1, clk, reset_n);
	ShifterBit bit6(bit_out[6], bit_out[5], letter[6], load_n, 1, clk, reset_n);
	ShifterBit bit5(bit_out[5], bit_out[4], letter[5], load_n, 1, clk, reset_n);
	ShifterBit bit4(bit_out[4], bit_out[3], letter[4], load_n, 1, clk, reset_n);
	ShifterBit bit3(bit_out[3], bit_out[2], letter[3], load_n, 1, clk, reset_n);
	ShifterBit bit2(bit_out[2], bit_out[1], letter[2], load_n, 1, clk, reset_n);
	ShifterBit bit1(bit_out[1], bit_out[0], letter[1], load_n, 1, clk, reset_n);
	ShifterBit bit0(bit_out[0], 0, letter[0], load_n, 1, clk, reset_n);
	
endmodule

