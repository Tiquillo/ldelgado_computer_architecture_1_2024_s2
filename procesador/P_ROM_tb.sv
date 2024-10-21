module P_ROM_tb;

    // Parámetros
    parameter CLK_PERIOD = 10; // Periodo de reloj en unidades de tiempo
    
    // Entradas
    logic [31:0] A;
    
    // Salidas
    logic [31:0] RD;
    
    // Instancia del módulo bajo prueba
    P_ROM dut (
        .A(A),
        .RD(RD)
    );
    
    // Generación de reloj
    logic clk = 0;
    
    always #((CLK_PERIOD)/2) clk = ~clk; // Genera un pulso de reloj cada CLK_PERIOD/2 unidades de tiempo
    
    // Proceso de prueba
    initial begin
        // Inicializar valores de entrada
        A = 32'h00000000; // Dirección de inicio
        
        // Esperar un ciclo para que el módulo procese la entrada
        #CLK_PERIOD;
        
        // Leer el resultado
        $display("RD en dirección %0d: %h", A, RD);
        
        // Cambiar la dirección de entrada
        A = 32'h00000004; // Dirección siguiente
        
        // Esperar un ciclo para que el módulo procese la nueva entrada
        #CLK_PERIOD;
        
        // Leer el nuevo resultado
        $display("RD en dirección %0d: %h", A, RD);
        
        // Puedes agregar más casos de prueba aquí
        
        // Finalizar la simulación
        $finish;
    end
    
endmodule