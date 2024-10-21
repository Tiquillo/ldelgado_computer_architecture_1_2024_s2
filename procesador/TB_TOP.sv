module TB_TOP();
	logic clk, reset, start, EndFlag, ReadEnable, startIO;
	logic [7:0] ByteOut;
	
	// instantiate device to be tested
	top dut(
		.clk_FPGA(clk), 
		.reset(reset), 
		.start(start), 
		.EndFlag(EndFlag),
		.clk_out(ReadEnable),
		.startIO(startIO),
		.ReadDataOut(ByteOut)
	);
	// generate clock to sequence tests
	always
	begin
		//clk <= 1; # 5; clk <= 0; # 5;
		#10 clk = ~clk;
	end
	
	// initialize test
	initial begin
		startIO = 0;
		
		
		//reset = 1;
		//clk = 0;
		//#1000;
		//clk = 1;
		//#10;
		//clk = 0;
		//reset = 0;
	
		//#10;
		
		
		//#200;
		startIO = 1;
		#200
		//$stop;
		reset <= 1; # 22; reset <= 0;
		
		
		#10;
		start <= 0; # 3; start <= 1;
		#10;
		start <= 0;
		//startIO = 1;
		
		#100;
		startIO <= 1;
		
		#1000;
		
	end
	
	
	
		
endmodule