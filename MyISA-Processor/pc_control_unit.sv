module pc_control_unit
(	
	// Entradas
	input logic clk, reset, FlagsW, start,
	input logic [1:0] ALUFlags,
	input logic [3:0] Id,
	input logic [17:0] Imm,
	
	// Salidas
	output logic EndFlag, COMFlag,
	output logic [31:0] PCNext
);

	logic [1:0] ALUFlagsTemp;
	logic	COMFlagTemp;
	logic [31:0] PC;
	
	flopenr #(2) flagreg1(
								// Entradas
								.clk(clk), 
								.reset(reset), 
								.en(FlagsW), 
								.d(ALUFlags), 
								// Salidas
								.q(ALUFlagsTemp)
								);
								
	flopenr #(1) flagreg2(
								// Entradas
								.clk(clk), 
								.reset(reset), 
								.en(COMFlagTemp), 
								.d(1'b1), 
								// Salidas
								.q(COMFlag)
								);
	
	flopr #(32) pcreg	(
							// Entradas
							.clk(clk), 
							.reset(reset), 
							.start(start), 
							.d(PC), 
							// Salidas
							.q(PCNext)
							);
							
	always_comb begin
		case(Id)
	
			4'b0000: begin
			
				PC <= PCNext + 4;		 		// NOP
				
			end 
			4'b0001: begin 							// COM
			
				PC <= PCNext + 4;							
				$display("\n\n *** Se inicia la comunicacion con el interprete ***");
				
			end
			4'b0010: begin 
			
				PC <= PCNext;							// END
				$display("\n\n *** El programa ha terminado exitosamente ***");
				
			end
	
			4'b1100: PC <= Imm; 						// BRIN
			
			4'b1101: if (ALUFlagsTemp[0])		 	// BETO
						begin 
							PC <= Imm;	
						end
						else begin
							PC <= PCNext + 4;
						end
						
			4'b1110: if (ALUFlagsTemp[1])			// BMNQ
						begin
							PC <= Imm;
						end
						
						else begin
							PC <= PCNext + 4;
						end
			
			default: PC <= PCNext + 4;				// Not control instruction
		
		endcase
		
	end
	
	assign EndFlag = (Id == 4'b0010);
	assign COMFlagTemp = (Id == 4'b0001);
	
endmodule