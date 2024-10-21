module interpreter_comunication
(
	// Entradas
	input logic clk, reset, MemtoReg, COM,
	input logic [31:0] ReadData,
	
	// Salidas
	output logic clk_out,
	output logic [14:0] ReadDataOut
);

	always_ff @(posedge MemtoReg, posedge reset) begin
	
		if (reset) begin 
			ReadDataOut <= 0; 
		end
		else if(COM) begin 
			ReadDataOut <= ReadData[14:0];
		end else begin
			ReadDataOut <= -1;
		end
		
	end
	
	assign clk_out = (MemtoReg & COM);
	
	
endmodule