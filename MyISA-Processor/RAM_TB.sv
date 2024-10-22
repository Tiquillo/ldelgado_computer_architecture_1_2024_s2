`timescale 1 ps / 1 ps
module RAM_TB;

// Parameters
parameter ADDR_WIDTH = 16;
parameter DATA_WIDTH = 32;

// Signals
reg [ADDR_WIDTH-1:0] address;
reg clock;
reg [DATA_WIDTH-1:0] data;
reg wren;
wire [DATA_WIDTH-1:0] q;

// Instantiate the RAM module
IP_RAM uut (
    .address(address),
    .clock(clock),
    .data(data),
    .wren(wren),
    .q(q)
);

// Clock generation
initial begin
    clock = 0;
    forever #5 clock = ~clock; // 100MHz clock
end

// Test sequence
initial begin
    // Initialize signals
    address = 0;
    data = 0;
    wren = 0;

    // Wait for the clock to stabilize
    #10;

    // Write data to the RAM
    address = 16'h0002;
    data = 32'hDEADBEEF;
    wren = 1;
    #10;
    wren = 0;

    // Read data from the RAM
    address = 16'h0002;
    #10;

    address = 16'h0001;

    // Check the output
    if (q !== 32'hDEADBEEF) begin
        $display("Test failed: expected 0xDEADBEEF, got 0x%h", q);
    end else begin
        $display("Test passed: got 0x%h", q);
    end

    // Finish the simulation
    $stop;
end
endmodule