`timescale 1 ps / 1 ps
module TB_TOP();
	logic clk, reset, start, EndFlag, ReadEnable;
	logic [7:0] ByteOut;
	
	// instantiate device to be tested
	top dut(
		.clk_FPGA(clk), 
		.reset(reset), 
		.start(start), 
		.EndFlag(EndFlag),
		.clk_out(ReadEnable),
		.ReadDataOut(ByteOut)
	);
	// generate clock to sequence tests
	always
	begin
		clk <= 1; # 5; clk <= 0; # 5;
	end
	
	// initialize test
	initial begin

		#10 reset = 1;
		#10 reset = 0;
		#10 start = 1;
		#10 start = 0;

		$stop;
		
	end
	
	
	
		
endmodule