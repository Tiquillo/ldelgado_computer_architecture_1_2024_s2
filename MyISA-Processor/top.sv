`timescale 1 ps / 1 ps
module top
(
	// Entradas
	input logic clk_FPGA, reset, start, startIO,
	
	// Salidas
	output logic EndFlag, clk_out,
	output logic [7:0] ReadDataOut,
	output logic vgaclk, // 25.175 MHz VGA clock
	output logic hsync, vsync,
	output logic sync_b, blank_b, // Para el monitor & DAC
	output logic [7:0] r, g, b
);
	logic [31:0] WriteData, DataAdr, ReadData;
	//logic [17:0] DataAdr;
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
	/*
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
	*/

	// Misma RAM que el vga
	Ram Ram_inst(
		.address(DataAdr),
		.clock(clk),
		.data(WriteData),
		.wren(MemWrite),
		.q(ReadData)
		);
	//Nueva implementación de memoria con IP_RAM
	//IP_RAM data_mem(
	//						// Entradas
	//						.address(DataAdr),
	//						.clock(clk),
	//						.data(WriteData),
	//						.wren(MemWrite),
	//						// Salidas
	//						.q(ReadData)
	//						);
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
											
	vga vd (
				// Entradas
				.clk(clk),
				.rst(reset),
				// Salidas
				.vgaclk(vgaclk),
				.hsync(hsync),
				.vsync(vsync),
				.sync_b(sync_b),
				.blank_b(blank_b),
				.r(r),
				.g(g),
				.b(b)
				);
	
	
endmodule 