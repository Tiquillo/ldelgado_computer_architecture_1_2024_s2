module clock_manager
(
	input clk_FPGA,
	input COMFlag, // COM Flag
	output logic clk
);


	localparam BAUD_RATE = 9600;

	clockDivider #(BAUD_RATE) div (
											.clk_in(clk_FPGA), 
											.clk_out(clk_Serial)
											);
	mux2 #(1) clk_mux	(
							.d0(clk_FPGA), 
							.d1(clk_Serial), 
							.s(COMFlag), 
							.y(clk)
							);
	
endmodule 