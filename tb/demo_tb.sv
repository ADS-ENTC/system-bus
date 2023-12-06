`timescale 1ns / 1ps
module tb_demo;
    // Declare reg and wire variables
    reg clk;
    reg [3:0] keysn;
    reg [17:0] sws;
    wire [6:0] hex0, hex1, hex2, hex3;
    wire m1_start, m2_start;

    // Instantiate the demo module
    demo uut (
        .clk(clk),
        .keysn(keysn),
        .sws(sws),
        .hex0(hex0),
        .hex1(hex1),
        .hex2(hex2),
        .hex3(hex3),
        .m1_start(m1_start),
        .m2_start(m2_start)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    // Test stimulus
    initial begin
        // Initialize inputs
        clk = 0;
        keysn = 4'b0000;
        sws = 18'b000000000000000000;

        // Apply some random inputs
        #10 keysn = 4'b1010; sws = 18'b101010101010101010;
        #10 keysn = 4'b0101; sws = 18'b010101010101010101;
        #10 keysn = 4'b1111; sws = 18'b111111111111111111;

        // Finish the simulation
        #10 $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("At time %t, hex0 = %b, hex1 = %b, hex2 = %b, hex3 = %b, m1_start = %b, m2_start = %b",
                 $time, hex0, hex1, hex2, hex3, m1_start, m2_start);
    end
endmodule