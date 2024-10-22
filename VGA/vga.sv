module vga(input logic clk,
input logic rst,
output logic vgaclk, // 25.175 MHz VGA clock
output logic hsync, vsync,
output logic sync_b, blank_b, // Para el monitor & DAC
output logic [7:0] r, g, b
); // Para el video DAC
logic [9:0] x = 0;
logic [9:0] y = 0;

// Usar un PLL para crear el 25.175 MHz VGA pixel clock
// 25.175 MHz periodo de relog = 39.772 ns
// La pantalla es de 800 clocks de largo por 525 de alto, pero solo 640 x 480 es usado
// HSync = 1/(39.772 ns *800) = 31.470 kHz
// Vsync = 31.474 kHz / 525 = 59.94 Hz (~60 Hz tasa de refresco)
pll vgapll(.refclk(clk), .rst(rst), .outclk_0(vgaclk), .locked());

// Generar las senales de timing del monitor
vgaController vgaCont(vgaclk, hsync, vsync, sync_b, blank_b, x, y);

// Modulo para determinar que letra se dibuja
videoGen videoGen(x, y, clk, r, g, b);
endmodule

