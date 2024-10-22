module TB_ALU;
		localparam N = 32;
			logic [N-1:0] result;
			logic [2:0] opcode;
			logic [N-1:0] a;
			logic [N-1:0] b;
			logic [1:0] ALUFlags;
			
			alu #(.N(N)) alu_unit (
					.opcode_i(opcode),
					.a_i(a),
					.b_i(b),
					.result_o(result),
					.ALUFlags(ALUFlags)
			);
			
			initial begin
					// ADD
					opcode = 3'b000;
					a = 32'd1;
					b = 32'd10;
					#10;
					// SUB
					opcode = 3'b001;
					a = 32'd10;
					b = 32'd5;
					#10;
					// CR
					opcode = 3'b010;
					a = 32'd11;
					b = 32'd11;
					#10;
					// MUL
					opcode = 3'b011;
					a = 32'd5;
					b = 32'd5;
					#10;
			end
endmodule
