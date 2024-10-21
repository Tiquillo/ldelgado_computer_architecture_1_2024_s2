module TB_P_RAM;

// Parameters
parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 32;

// Signals
reg clk;
reg WE;
reg [ADDR_WIDTH-1:0] addr;
reg [DATA_WIDTH-1:0] data_in;
reg we;
reg startIO;
wire [DATA_WIDTH-1:0] data_out;

// Instantiate the P_RAM module
P_RAM uut (
    .clk(clk),
    .WE(we),
    .A(addr),
    .WD(data_in),
    .startIO(startIO),
    .RD(data_out)
);

// Clock generation
always begin
    #5 clk = ~clk;
end

// Testbench
initial begin
    clk = 0;
    WE = 0;
    addr = 0;
    data_in = 0;
    we = 0;
    startIO = 0;

    // Write data to the memory
    we = 1;
    data_in = 32'h12345678;
    addr = 0;
    startIO = 1;
    #10;
    startIO = 0;
    we = 0;

    //// Read data from the memory
    //addr = 0;
    //startIO = 1;
    //#10;
    //startIO = 0;
    //// Wait for the memory to output the data
    //#10;

    // read addres 1
    addr = 1;
    startIO = 1;
    #10;
    startIO = 0;

    // Wait for the memory to output the data
    #10;

    // Finish the simulation
    $finish;
end

endmodule