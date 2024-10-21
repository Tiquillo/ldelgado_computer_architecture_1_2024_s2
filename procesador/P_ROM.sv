module P_ROM
(
	// Entradas
	input logic [31:0] A,
	
	// Salidas
	output logic [31:0] RD
);

	logic [31:0] RAM[100:0];
	
	// Se inicializa la memoria de instrucciones
	initial
		$readmemh("ROMdata.dat",RAM);
	
	assign RD = RAM[A[31:2]];
	
endmodule