// Modulo para cambiar la letra a dibujar
module chargenrom(input logic clk, input logic [7:0] ch,
input logic [2:0] xoff, yoff, input logic [9:0] posx, posy,
output logic pixel, output logic [7:0] RD, Alpha);
logic [5:0] charrom[224:0]; // Generador del almacenador de Caracter ROM
logic [7:0] line; // Una linea leida por la ROM

	// Lee la informacion en el adrress
	data_memory data_memory_inst (
        .clk(clk),
        .A(posx/8 + 80*(posy/8)),
        .RD(RD),
		  .Alpha(Alpha)
    );

// Inicializa el ROM, lo guarda en charrom
initial begin 
$readmemb("charrom.txt", charrom); end

// Quita 65 porque A es 1 en el charrom
	always @* begin
	//Impide dibujar a partir de la segunda linea
	//Esto por temas de pruebas
	if (posy < 16 ) begin
		$display("Ejecutando"); 
		if ((RD == 8'h41) || (RD == 8'h61)) begin					//A
			 line = charrom[yoff + {ch-65, 3'b000 + 8 }];
			 $display("Dibujando A");
		end else if ((RD == 8'h42) || (RD == 8'h62)) begin		//B
			 line = charrom[yoff + {ch-65, 3'b000 + 16}];
			 $display("Dibujando B");
		end else if ((RD == 8'h43) || (RD == 8'h63)) begin  	//C
			 line = charrom[yoff + {ch-65, 3'b000 + 24}];
			 $display("Dibujando C");
		end else if ((RD == 8'h44) || (RD == 8'h64)) begin		//D
			 line = charrom[yoff + {ch-65, 3'b000 + 32}];
			 $display("Dibujando D");
		end else if ((RD == 8'h45) || (RD == 8'h65)) begin		//E
			 line = charrom[yoff + {ch-65, 3'b000 + 40}];
			 $display("Dibujando E");
		end else if ((RD == 8'h46) || (RD == 8'h66)) begin		//F
			 line = charrom[yoff + {ch-65, 3'b000 + 48}];
			 $display("Dibujando F");
		end else if ((RD == 8'h47) || (RD == 8'h67)) begin		//G
			 line = charrom[yoff + {ch-65, 3'b000 + 56}];
			 $display("Dibujando G");
		end else if ((RD == 8'h48) || (RD == 8'h68)) begin		//H
			 line = charrom[yoff + {ch-65, 3'b000 + 64}];
			 $display("Dibujando H");
		end else if ((RD == 8'h49) || (RD == 8'h69)) begin		//I
			 line = charrom[yoff + {ch-65, 3'b000 + 72}];
			 $display("Dibujando I");
		end else if ((RD == 8'h4A) || (RD == 8'h6A)) begin		//J
			 line = charrom[yoff + {ch-65, 3'b000 + 80}];
			 $display("Dibujando J");
		end else if ((RD == 8'h4B) || (RD == 8'h6B)) begin		//K
			 line = charrom[yoff + {ch-65, 3'b000 + 88}];
			 $display("Dibujando K");
		end else if ((RD == 8'h4C) || (RD == 8'h6C)) begin		//L
			 line = charrom[yoff + {ch-65, 3'b000 + 96}];
			 $display("Dibujando L");
		end else if ((RD == 8'h4D) || (RD == 8'h6D)) begin		//M
			 line = charrom[yoff + {ch-65, 3'b000 + 104}];
			 $display("Dibujando M");
		end else if ((RD == 8'h4E) || (RD == 8'h6E)) begin		//N
			 line = charrom[yoff + {ch-65, 3'b000 + 112}];
			 $display("Dibujando N");
		end else if ((RD == 8'h4F) || (RD == 8'h6F)) begin		//O
			 line = charrom[yoff + {ch-65, 3'b000 + 120}];
			 $display("Dibujando 0");
		end else if ((RD == 8'h50) || (RD == 8'h70)) begin		//P
			 line = charrom[yoff + {ch-65, 3'b000 + 128}];
			 $display("Dibujando P");
		end else if ((RD == 8'h51) || (RD == 8'h71)) begin		//Q
			 line = charrom[yoff + {ch-65, 3'b000 + 136}];
			 $display("Dibujando Q");
		end else if ((RD == 8'h52) || (RD == 8'h72)) begin		//R
			 line = charrom[yoff + {ch-65, 3'b000 + 144}];
			 $display("Dibujando R");
		end else if ((RD == 8'h53) || (RD == 8'h73)) begin		//S
			 line = charrom[yoff + {ch-65, 3'b000 + 152}];
			 $display("Dibujando S");
		end else if ((RD == 8'h54) || (RD == 8'h74)) begin		//T
			 line = charrom[yoff + {ch-65, 3'b000 + 160}];
			 $display("Dibujando T");
		end else if ((RD == 8'h55) || (RD == 8'h75)) begin		//U
			 line = charrom[yoff + {ch-65, 3'b000 + 168}];
			 $display("Dibujando U");
		end else if ((RD == 8'h56) || (RD == 8'h76)) begin		//V
			 line = charrom[yoff + {ch-65, 3'b000 + 176}];
			 $display("Dibujando V");
		end else if ((RD == 8'h57) || (RD == 8'h77)) begin		//W
			 line = charrom[yoff + {ch-65, 3'b000 + 184}];
			 $display("Dibujando W");
		end else if ((RD == 8'h58) || (RD == 8'h78)) begin		//X
			 line = charrom[yoff + {ch-65, 3'b000 + 192}];
			 $display("Dibujando X");
		end else if ((RD == 8'h59) || (RD == 8'h79)) begin		//Y
			 line = charrom[yoff + {ch-65, 3'b000 + 200}];
			 $display("Dibujando Y");
		end else if ((RD == 8'h5A) || (RD == 8'h7A)) begin		//Z
			 line = charrom[yoff + {ch-65, 3'b000 + 208}];
			 $display("Dibujando Z");
		end else if (RD == 8'h23) begin								//SIMBOL
			 line = charrom[yoff + {ch-65, 3'b000 + 216}];
			 $display("Dibujando simbolo");
		end else begin
			 line = charrom[yoff + {ch-65, 3'b000 + 0 }];   	//ESPACIO
			 $display("Dibujando espacio");
		end
	end else begin
		line = charrom[yoff + {ch-65, 3'b000 + 0}]; //ESPACIO por defecto
	end
	end
	
// Le damos vuelta al orden de bits
	assign pixel = line[3'd7-xoff];
endmodule