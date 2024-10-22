module data_memory (
   input logic clk,                       // Clock 
   input logic [11:0] A,     // Address
   output logic [7:0] RD, Alpha       // Data output for reading
);
	logic [7:0] RS;
   // Array to store data
   logic [31:0] memory [0:7];

    // Initialize memory with content from file
   initial begin
     $readmemh("Prueba.list", memory);
   end
	
	always @(*) begin
				 // Byte read (ldrb)
				case (A[1:0])
					 2'b00: RS <= {24'b0, (memory[A[11:2]][7:0] === 8'hxx) ? 8'h00 : memory[A[11:2]][7:0]};
					 2'b01: RS <= {24'b0, (memory[A[11:2]][15:8] === 8'hxx) ? 8'h00 : memory[A[11:2]][15:8]};
					 2'b10: RS <= {24'b0, (memory[A[11:2]][23:16] === 8'hxx) ? 8'h00 : memory[A[11:2]][23:16]};
					 2'b11: RS <= {24'b0, (memory[A[11:2]][31:24] === 8'hxx) ? 8'h00 : memory[A[11:2]][31:24]};
				endcase
	end
	 
	assign Alpha = A/4;
	assign RD = RS;

endmodule
