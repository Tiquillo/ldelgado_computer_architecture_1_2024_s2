`timescale 10ms/1ms
module testbench;
	

    // Parámetros del módulo VGA
    parameter HRES = 640;
    parameter VRES = 480;

    // Definición de señales de entrada
    logic clk = 0;
    logic rst = 0;

    // Definición de señales de salida
    logic vgaclk;
    logic hsync;
    logic vsync;
    logic sync_b; 
    logic blank_b;
    logic [7:0] red;
    logic [7:0] green;
    logic [7:0] blue;
	 
    // Instanciación del módulo VGA
    vga newvga(
        .clk(clk),
		  .rst(rst),
        .vgaclk(vgaclk),
        .hsync(hsync),
        .vsync(vsync),
        .sync_b(sync_b),
        .blank_b(blank_b),
        .r(red),
        .g(green),
        .b(blue)
    );
	 
	 
		/*
	chargenrom chargenrom(
		.clk(clk),
		.ch(y[8:3] + 8'd65),
		.xoff(x[2:0]),
		.yoff(y[2:0]),
		.posx(x),
		.posy(y),
		.pixel(pixel)
		);
		*/
		
    // Clock generation
    always #5 clk = ~clk;
	 //always #5 x = x + 1;

    // Testbench stimulus
    initial begin
        // Reset
        rst = 0;
        #1000;

        // Finish simulation
    end

endmodule