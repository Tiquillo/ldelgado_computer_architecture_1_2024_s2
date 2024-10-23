module flopenr #(parameter WIDTH = 8)
(
	// Entradas
	input logic clk, reset, en,
	input logic [WIDTH-1:0] d,
	
	// Salidas
	output logic [WIDTH-1:0] q
);

	always_ff @(posedge clk, posedge reset)
		if (reset) q <= 0;
		else if (en) q <= d;
		
endmodule