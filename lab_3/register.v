module register(q, clk, reset_n, d);
	input clk, reset_n;
	input [7:0] d;
	output reg [7:0] q;
	
	always @(posedge clk)
	begin 
		if (reset_n == 1'b0)
			q <= 0;
		else
			q <= d;
	end
endmodule