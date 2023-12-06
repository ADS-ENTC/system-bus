module FIFO #(parameter WIDTH = 32, parameter DEPTH = 16) (
    input logic clk, 
    input logic rstn, 
    input logic [WIDTH-1:0] data_in, 
    input logic enq, 
    input logic deq, 
    output logic [WIDTH-1:0] data_out,
    output logic empty,
    output logic full
);

logic [DEPTH-1:0][WIDTH-1:0] memory; //packed array
logic [$clog2(DEPTH):0] rd_ptr, wr_ptr;

assign data_out = memory[rd_ptr];
assign empty = (rd_ptr == wr_ptr);
assign full = (rd_ptr == wr_ptr + 1);

always_ff @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        rd_ptr <= 0;
        wr_ptr <= 0;
    end

    else begin
        if (enq && !full) begin
            memory[wr_ptr] <= data_in;
            wr_ptr <= wr_ptr + 1;
        end

        if (deq && !empty) begin
            rd_ptr <= rd_ptr + 1;
        end
    end
end

endmodule