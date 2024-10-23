module TB_PC_CONTROL_UNIT;
	
	logic clk, reset, start, FlagsW, EndFlag, COMFlag;
	logic [31:0] Instr, PC;
	logic [1:0] ALUFlags;
	
	pc_control_unit pcu(
					// Entradas
					.clk(clk), 
					.reset(reset),
					.start(start),
					.FlagsW(FlagsW),
					.Id(Instr[31:28]), 
					.ALUFlags(ALUFlags),
					.Imm(Instr[17:0]),
					// Salidas
					.EndFlag(EndFlag),
					.COMFlag(COMFlag),
					.PCNext(PC)
					);
	
	// generate clock to sequence tests
	always
	begin
		clk <= 1; # 5; clk <= 0; # 5;
	end
 
	initial begin
		// start
		reset = 0;
		#10
		
		FlagsW = 0;
		ALUFlags = 2'b00;
		EndFlag = 0;
		COMFlag = 0;
		Instr = 31'h65000007; // mov r7, #8    -> pc = pc+4
		
		reset = 1;
		start = 1;
		#10;

		// JMP encrypt_store
		Instr = 31'hC0000050;
		#10;
		
		// JEQ fin2
		ALUFlags = 2'b01;
		FlagsW = 1;
		Instr = 31'hD000013C;
		#10;
		
		// JLT exp_add
		ALUFlags = 2'b10;
		FlagsW = 1;
		Instr = 31'hE0000094;
		#10;
	end
endmodule