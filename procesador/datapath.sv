module datapath
(
	// Entradas
	input logic clk, reset, RegWrite, ALUSrc, MemtoReg, MemWrite, FlagsWriteD, RegSrc,
	input logic [2:0] ALUControl,
	input logic [31:0] InstrF, ReadData, PCNext,
	
	// Salidas
	output logic MemWriteM, FlagsWriteW, MemtoRegM,
	output logic [1:0] ALUFlagsW,
	output logic [31:0] ALUOutM, WriteDataM, InstrD
);	

	// ***************************** Wires *****************************************
	
	// Fetch ***********************************************************************
	
	// Decode **********************************************************************
	
	logic RegWriteE, MemtoRegE, MemWriteE, ALUSrcE, FlagsWriteE;
	logic [1:0] ALUFlagsE;
	logic [2:0] ALUControlE;
	logic [3:0] RA2, WA3E;
	logic [31:0] RD1D, RD2D, rd1E, rd2E, ExtImm, ExtImmE;
	
	// Execute *********************************************************************
	
	logic RegWriteM, FlagsWriteM;
	logic [1:0] ALUFlagsM;
	logic [3:0] WA3M;
	logic [31:0] SrcBE, ALUResultE;
	
	// MEM *************************************************************************
	
	logic RegWriteW, MemtoRegW;
	logic [3:0] WA3W;
	logic [31:0] ReadDataW, ALUOutW;
	
	// WB **************************************************************************
	
	logic [31:0] Result;
	
	// ------------------------------- Etapas --------------------------------------
	
	
	// Fetch -----------------------------------------------------------------------
	
	segment_if_id seg_if_id	(
									// Entradas
									.clk(clk), 
									.reset(reset), 
									.InstrF(InstrF), 
									// Salidas
									.InstrD(InstrD)
									);

	// Decode ----------------------------------------------------------------------
	
	
	mux2 #(4) ra2mux	(
							// Entradas
							.d0(InstrD[17:14]), 
							.d1(InstrD[25:22]), 
							.s(RegSrc), 
							// Salidas
							.y(RA2)
							);
	
	regfile rf	(
					// Entradas
					.clk(clk), 
					.WE3(RegWriteW), 
					.A1(InstrD[21:18]), 
					.A2(RA2), 
					.A3(WA3W), 
					.WD3(Result),
					// Salidas
					.RD1(RD1D), 
					.RD2(RD2D)
					);
					
	extend ext	(
					// Entradas
					.Imm(InstrD[17:0]), 
					// Salidas
					.ExtImm(ExtImm)
					);

	
	segment_id_ex seg_id_ex	(
									// Entradas
									.clk(clk), 
									.reset(reset), 
									.RegWriteD(RegWrite), 
									.MemtoRegD(MemtoReg), 
									.MemWriteD(MemWrite), 
									.ALUSrcD(ALUSrc), 
									.FlagsWriteD(FlagsWriteD),
									.ALUControlD(ALUControl),
									.WA3D(InstrD[25:22]),
									.rd1D(RD1D), 
									.rd2D(RD2D), 
									.ExtImmD(ExtImm),
									// Salidas
									.RegWriteE(RegWriteE), 
									.MemtoRegE(MemtoRegE), 
									.MemWriteE(MemWriteE), 
									.ALUSrcE(ALUSrcE), 
									.FlagsWriteE(FlagsWriteE),
									.ALUControlE(ALUControlE), 
									.WA3E(WA3E),
									.rd1E(rd1E), 
									.rd2E(rd2E), 
									.ExtImmE(ExtImmE)
									);
	
	// Execute ------------------------------------------------------------------------------
	
	mux2 #(32) srcbmux(
							// Entradas
							.d0(rd2E), 
							.d1(ExtImmE), 
							.s(ALUSrcE), 
							// Salidas
							.y(SrcBE)
							);
	
	alu #(32) alu	(
						// Entradas
						.a_i(rd1E), 
						.b_i(SrcBE),
						.opcode_i(ALUControlE), 
						// Salidas
						.result_o(ALUResultE),
						.ALUFlags(ALUFlagsE)
						);
	
	segment_ex_mem seg_ex_mem	(
										// Entradas
										.clk(clk), 
										.reset(reset), 
										.RegWriteE(RegWriteE), 
										.MemtoRegE(MemtoRegE), 
										.MemWriteE(MemWriteE), 
										.FlagsWriteE(FlagsWriteE),
										.ALUFlagsE(ALUFlagsE),
										.WA3E(WA3E), 
										.ALUResultE(ALUResultE), 
										.WriteDataE(rd2E),
										// Salidas
										.RegWriteM(RegWriteM), 
										.MemtoRegM(MemtoRegM), 
										.MemWriteM(MemWriteM), 
										.FlagsWriteM(FlagsWriteM),
										.ALUFlagsM(ALUFlagsM),
										.WA3M(WA3M), 
										.ALUOutM(ALUOutM),
										.WriteDataM(WriteDataM)
										);
		
	// MEM -----------------------------------------------------------------
	
	segment_mem_wb seg_mem_wb 	(
										// Entradas
										.clk(clk), 
										.reset(reset), 
										.RegWriteM(RegWriteM), 
										.MemtoRegM(MemtoRegM), 
										.FlagsWriteM(FlagsWriteM),
										.ALUFlagsM(ALUFlagsM),
										.WA3M(WA3M), 
										.ReadDataM(ReadData), 
										.ALUOutM(ALUOutM),
										// Salidas
										.RegWriteW(RegWriteW), 
										.MemtoRegW(MemtoRegW), 
										.FlagsWriteW(FlagsWriteW),
										.ALUFlagsW(ALUFlagsW),
										.WA3W(WA3W), 
										.ReadDataW(ReadDataW), 
										.ALUOutW(ALUOutW)
										);
								
	// WB --------------------------------------------------------------------
					
	mux2 #(32) resmux(
							// Entradas
							.d0(ALUOutW), 
							.d1(ReadDataW), 
							.s(MemtoRegW), 
							// Salidas
							.y(Result)
							);
	
endmodule