module data_memory_tb;
    localparam DATA_WIDTH = 32;
    localparam ADDRESS_WIDTH = 32;
    localparam MEM_SIZE = 1024;

    // Signal declaration
    reg clk = 0;
    reg rst = 1;
    reg [ADDRESS_WIDTH-1:0] A;
    reg [DATA_WIDTH-1:0] WD;
    reg WE;
	 reg BE;
    reg [DATA_WIDTH-1:0] RD;

    // Instantiate the data_memory module
    data_memory #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDRESS_WIDTH(ADDRESS_WIDTH),
        .MEM_SIZE(MEM_SIZE)
    ) dut (
        .clk(clk),
        .A(A),
        .RD(RD)
    );

    always #5 clk = ~clk;

    initial begin
        // Read first 10 data from memory
        for (int i = 0; i < 10; i++) begin
            WE = 1'b0;
            A = i * 4;
            #10;
            $display("Address: %h, Data: %h", A, RD);
        end

        // Write 
        A = 2;
        WD = 32'h11;
        WE = 1'b1;
		  BE = 1'b0;
        #20;

        // Read
        WE = 1'b0;
		  BE = 1'b0;
        A = 4;
        #10;
        $display("Address: %h, Data: %h", A, RD);

        // Write
        A = 9*4;
        WD = 32'h52;
        WE = 1'b1;
		  BE = 1'b0;
        #20;

        // Read
		  A = 9*4;
        WE = 1'b0;
		  BE = 1'b0;
        #10;
        $display("Address: %h, Data: %h", A, RD);
		  
		  // Read byte
		  A = 0;
        WE = 1'b0;
		  BE = 1'b1;
        #10;
        $display("Address: %h, Data: %h", A, RD);
		  
		  // Read byte
		  A = 1;
        WE = 1'b0;
		  BE = 1'b1;
        #10;
        $display("Address: %h, Data: %h", A, RD);
		  
		  // Read byte
		  A = 2;
        WE = 1'b0;
		  BE = 1'b1;
        #10;
        $display("Address: %h, Data: %h", A, RD);
		  
		  // Read byte
		  A = 3;
        WE = 1'b0;
		  BE = 1'b1;
        #10;
        $display("Address: %h, Data: %h", A, RD);
		  
		  // Write byte
        A = 0;
        WD = 32'hfe;
        WE = 1'b1;
		  BE = 1'b1;
        #20;
		  
		  // Write byte
        A = 2;
        WD = 32'h4b;
        WE = 1'b1;
		  BE = 1'b1;
        #20;
		  
		  // Read
        WE = 1'b0;
		  BE = 1'b0;
        A = 0;
        #10;
        $display("Address: %h, Data: %h", A, RD);

        $display("Testbench completed successfully");
        $finish;
    end

endmodule
