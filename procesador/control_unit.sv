module control_unit
(	
	// Entradas
	input logic [5:0] Id,
	
	// Salidas
	output logic RegWrite, MemtoReg, MemWrite, ALUSrc, FlagsWrite, RegSrc,
	output logic [2:0] ALUControl
);
	
	// RegSrc: señal de seleccion de los dos mux que entran al banco de registros.
					// El MSB (ra2mux): selecciona entre RM y RD
					
	// ALUSrc: señal de seleccion de la entrada B del ALU.
					// 0: selecciona el registro RD2.
				   // 1: selecciona el immediato exentedido.
	
	// MemtoReg: señal del mux que selecciona entre el resultado de la ALU o el dato leido de mem.
					// 0: ALURESULT
					// 1: ReadData (mem)
	
	// RegWrite: enable para escribir en el banco de registros
	
	// MemWrite: enable para escribir en la memoria
	
	
	
	// Instruction decoder
	always_comb
		casex(Id[5:4])
		
			2'b00: begin	// System operation
			
				FlagsWrite = 1'b0;
				RegSrc = 1'b0; 
				ALUSrc = 1'b0;
				MemtoReg = 1'b0;
				RegWrite = 1'b0;
				MemWrite = 1'b0;
			
			end
										
			2'b01: begin	// Data-processing 
			
					if (Id[0]) ALUSrc = 1;			// Si la instruccion utiliza el inmediato
					else ALUSrc = 0;
					
					if (Id[3:1] == 3'b100) begin // CE: modifica las banderas pero no registros
						FlagsWrite = 1;
						RegWrite = 0;
						
					end else begin 						// Operaciones sobre registros: modifica registros pero no banderas
						FlagsWrite = 0;
						RegWrite = 1;
					end
					
					RegSrc = 0; 
					MemtoReg = 0;
					MemWrite = 0;
				
			end
				
			2'b10: begin	// Memory
			
					FlagsWrite = 0;
					ALUSrc = 1;			// Selecciona el immediato extendido para generar la addr = RN + EXT_IMM
					
					if (Id[3])	begin // STR = TOME
					
						RegSrc = 1; 	// Selecciona RD = WriteData (Dato a guardar en mem)
						MemtoReg = 0;	
						RegWrite = 0;
						MemWrite = 1;
						
						
					end else begin 	// LDR = DEME
					
						RegSrc = 0; 	// Selecciona 
						MemtoReg = 1;
						RegWrite = 1;
						MemWrite = 0;
						
					end
			end
			
			2'b11: begin				// JMPS
			
				FlagsWrite = 1'b0;
				RegSrc = 1'b0; 
				ALUSrc = 1'b0;
				MemtoReg = 1'b0;
				RegWrite = 1'b0;
				MemWrite = 1'b0;
			
			end

			default: begin // Unimplemented
						
						FlagsWrite = 1'bx;
						RegSrc = 1'bx; 
						ALUSrc = 1'bx;
						MemtoReg = 1'bx;
						RegWrite = 1'bx;
						MemWrite = 1'bx;
			end		    
			
		endcase
		
	
	
	// ALU Decoder
	always_comb
	
		if (Id[5:4] == 2'b10) begin	// ADD for MEM Instructions
		
			ALUControl = 3'b000;
		
		end else
		case(Id[3:1])
			3'b000: ALUControl = 3'b000; // SUM
			3'b001: ALUControl = 3'b001; // RES
			3'b010: ALUControl = 3'b010; // CR
			3'b011: ALUControl = 3'b011; // MUL
			3'b100: ALUControl = 3'b001; // CMP
			
			default: ALUControl = 3'bx; // unimplemented
		endcase
					
endmodule
						