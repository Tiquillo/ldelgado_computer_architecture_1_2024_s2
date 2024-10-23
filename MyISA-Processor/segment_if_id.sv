module segment_if_id
(
	// Entradas
	input logic clk, reset,
	input logic [31:0] InstrF,
	
	// Salidas
	output logic [31:0] InstrD
);
			
	always_ff@(negedge clk, posedge reset)
		if(reset)
			begin
				InstrD = 0;
			end
			
		else 
			begin
				InstrD = InstrF;
			end
		
endmodule