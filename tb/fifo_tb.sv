`timescale 1ns/1ns

module fifo_tb;

localparam WIDTH = 32;
localparam DEPTH = 16;



logic clk;
logic rstn;
logic [WIDTH-1:0] data_in;
logic enq;
logic deq;

logic [WIDTH-1:0] data_out;
logic full;
logic empty;
logic almost_full;
logic almost_empty;
logic valid;


FIFO dut(.*);

initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end

initial begin
    integer count = 0;
    rstn = 1'b0;
    enq = 1'b0;
    deq = 1'b0;
    data_in = 0;
    #20
    rstn = 1'b1;
    #20
    
    repeat (17) begin
        @(negedge clk);
        data_in = count;
        count = count + 1;
        enq = 1'b1;
    end
    
    enq = 1'b0;
    
    repeat (17) begin
        deq = 1'b1;
    end
    
    deq = 1'b1;
    
    
    #2500;
    $finish;
end

endmodule

