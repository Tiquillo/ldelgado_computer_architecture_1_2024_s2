module segment_mem_wb 
(
	// Entradas
	input logic clk, reset, RegWriteM, MemtoRegM, FlagsWriteM, 
	input logic [1:0] ALUFlagsM,
	input logic [3:0] WA3M, 
	input logic [31:0] ReadDataM, ALUOutM,
	
	
	// Salidas
	output logic RegWriteW, MemtoRegW, FlagsWriteW, 
	output logic [1:0] ALUFlagsW,
	output logic [3:0] WA3W,
	output logic [31:0] ReadDataW, ALUOutW
);
			
	always_ff@(negedge clk, posedge reset)
		if(reset)
			begin
				
				RegWriteW = 0;
				MemtoRegW = 0;
				ReadDataW = 0;
				ALUOutW = 0;
				WA3W = 0;
				FlagsWriteW = 0;
				ALUFlagsW = 0;
				
			end
			
		else 
			begin
			
				RegWriteW = RegWriteM;
				MemtoRegW = MemtoRegM;
				ReadDataW = ReadDataM;
				ALUOutW = ALUOutM;
				WA3W = WA3M;
				FlagsWriteW = FlagsWriteM;
				ALUFlagsW = ALUFlagsM;
				
			end
		
endmodule
