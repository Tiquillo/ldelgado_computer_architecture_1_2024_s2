module top
(
	// Entradas
	input logic clk_FPGA, reset, start, startIO,
	
	// Salidas
	output logic EndFlag, clk_out,
	output logic [7:0] ReadDataOut
);
	logic [31:0] WriteData, DataAdr, ReadData;
	logic MemWrite, MemtoReg;
	logic [31:0] PC, Instr;
	logic clk;
	
	
	// Modulo para cambiar de clk
	clock_manager cm (
							.clk_FPGA(clk_FPGA),
							.COMFlag(COMFlag),
							.clk(clk)
	
	);
	
	
	// Instancia del procesador
	pipelined_processor cpu(
									// Entradas
									.clk(clk), 
									.reset(reset), 
									.start(start), 
									.Instr(Instr), 
									.ReadData(ReadData), 
									// Salidas
									.MemWrite(MemWrite), 
									.MemtoRegM(MemtoReg),
									.EndFlag(EndFlag),
									.COMFlag(COMFlag),
									.PC(PC), 
									.ALUResult(DataAdr),
									.WriteData(WriteData)
									); 
									
									
	// Memoria de instrucciones
	P_ROM instr_mem(
								// Entradas
								.A(PC),
								// Salidas
								.RD(Instr)
								);
	
	// Memoria de datos
	P_RAM data_mem(
							// Entradas
							.clk(clk), 
							.WE(MemWrite), 
							.A(DataAdr), 
							.WD(WriteData),
							.startIO(startIO),
							// Salidas
							.RD(ReadData)
							);
	// Modulo para comuncacion con interprete
	interpreter_comunication ic 	(
											// Entradas
											.clk(clk), 
											.reset(reset), 
											.MemtoReg(MemtoReg),
											.COM(COMFlag),
											.ReadData(ReadData),
											// Salidas
											.clk_out(clk_out),
											.ReadDataOut(ReadDataOut)
											);
	
	
endmodule 