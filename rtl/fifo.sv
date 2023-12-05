module FIFO #(parameter WIDTH = 32, parameter DEPTH = 16) (

    input logic clk, 
    input logic rstn, 
    input logic [WIDTH-1:0] data_in, 
    input logic enq, 
    input logic deq, 

    output logic [WIDTH-1:0] data_out, 
    output logic full, 
    output logic empty, 
    output logic almost_full,
    output logic almost_empty,
    output logic valid

);

    logic [0:DEPTH-1][WIDTH-1:0] memory; //packed array
    logic [$clog2(DEPTH):0] head;
    logic [$clog2(DEPTH):0] tail;
    logic [$clog2(DEPTH):0] count;

    localparam ALMOST_FULL_THRESHOLD = DEPTH - 4;
    localparam ALMOST_EMPTY_THRESHOLD = 4;


    always_ff @(posedge clk or negedge rstn) begin

        if(!rstn) begin
            head <= 5'b0; // need to be changed based on the depth of FIFO
            tail <= 5'b0;
            full <= 1'b0;
            empty <= 1'b1;
            almost_full <= 1'b0;
            almost_empty <= 1'b1;
            valid <= 1'b0;
            count <= 1'b0;  
        end

        else begin
            if(enq && !deq && !full) begin
                memory[head] <= data_in;
                head <= (head == DEPTH-1) ? 5'b0 : head + 1;
                valid <= 1'b1;
                count <= count + 1;
                empty <= 1'b0;

                if (count == DEPTH-1)
                    full <= 1'b1;
                else
                    full <= 1'b0;
                if (count == ALMOST_FULL_THRESHOLD)
                    almost_full <= 1'b1;
                else
                    almost_full <= 1'b0;
            end
            else
                valid <= 1'b0;


            if (deq &&  !enq && !empty) begin
                data_out <= memory[tail];
                tail <= (tail == DEPTH-1) ? 5'b0 : tail + 1;
                valid <= 1'b1;
                count <= count - 1;
                if (count == 5'b0)
                    empty <= 1'b1;
                else
                    empty <= 1'b0;
                if (count == ALMOST_EMPTY_THRESHOLD)
                    almost_empty <= 1'b1;
                else
                    almost_empty <= 1'b0;
            end
            else
                valid <= 1'b0;

            end

    end

endmodule