//Metodo de dibujado
module videoGen(input logic [9:0] x, y, input logic clk, output logic [7:0] r, g, b);

logic [7:0] Q;
logic [7:0] Temp;
Ram Ram_inst(
	.address(x + 256*y), //Avanza en memoria por pixel, el 256 viene de ser una imagen 256x256
	.clock(clk),
	.data(0),
	.wren(0),
	.q(Q));

	always @(*) begin
		if (x > 256 || y > 256) begin // Solo dibujar una vez
			Temp = 0;
		end else begin
			Temp = Q;
		end
	end
assign r = Temp;
assign g = Temp;
assign b = Temp;

endmodule