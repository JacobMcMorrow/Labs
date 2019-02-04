module register(q, clk, reset_b, d);
	input clk, reset_b;
	input [7:0] d;
	output reg [7:0] q;
	
	always @(posedge clk)
	begin 
		if (reset_b == 1'b0)
			q <= 0;
		else
			q <= d;
	end
endmodule