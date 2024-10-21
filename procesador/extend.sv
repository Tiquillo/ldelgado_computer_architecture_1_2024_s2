module extend
(
	// Entradas
	input logic [17:0] Imm,
	
	// Salidas
	output logic [31:0] ExtImm
);

	assign ExtImm = {14'b0, Imm} ;											

endmodule