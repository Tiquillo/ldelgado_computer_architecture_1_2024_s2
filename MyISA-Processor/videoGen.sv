//Metodo de dibujado
module videoGen(input logic [9:0] x, y, input logic clk, output logic [7:0] r, g, b);

	logic [31:0] Q;
	logic [31:0] Temp;
	IP_RAM Ram_inst(
		.address((x + 392*y)/4), //Avanza en memoria por pixel, el 392 viene de ser una imagen 256x256
		.clock(clk),
		.data(0),
		.wren(0),
		.q(Q));

	// intentar usar la misma memoria que el procesador
	// P_RAM Ram_inst(
	// 	.clk(clk),
	// 	.WE(0),
	// 	.A((x + 392*y)/4),
	// 	.WD(0),
	// 	.startIO(0),
	// 	.RD(Q)
	// );

	always @(*) begin
		if (x > 392 || y > 392) begin
			Temp = 0;
		end else begin
			Temp = Q;
		end
	end
	
	logic [7:0] temp2;

	//assign temp2 = Temp[x%4*8+7:x%4*8];

	always @(*) begin
		case(x[1:0])
			0: temp2 = Temp[7:0];
			1: temp2 = Temp[15:8];
			2: temp2 = Temp[23:16];
			3: temp2 = Temp[31:24];
		endcase
	end

	assign r = temp2;
	assign g = temp2;
	assign b = temp2;
endmodule