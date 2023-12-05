module slave_bus_bridge#(
    parameter ADDR_WIDTH = 16,
    parameter DATA_WIDTH = 8,
    parameter SPLIT_EN = 0
)(
    input logic mode, wr_bus, master_valid, master_ready, rstn, clk, valid_in,
    input logic [DATA_WIDTH-1:0]uart_register_in,
    output logic [1+ADDR_WIDTH+16-1:0]uart_register_out,
    output logic rd_bus, slave_ready, slave_valid, split, valid_out
);

// local parameters
localparam COUNTER_LENGTH = $clog2(ADDR_WIDTH+DATA_WIDTH);
localparam NUM_STATES = 7;
localparam STATE_N_BITS = $clog2(NUM_STATES);

// internal signals
logic [COUNTER_LENGTH-1:0]counter;
logic [ADDR_WIDTH-1:0]addr_in;
logic [DATA_WIDTH-1:0]data_in;
logic port_ready, port_valid;

// definition of states
enum logic[STATE_N_BITS-1:0] {IDLE, ADDR_IN, DATA_IN, WRITE, READ, SEND, SPLIT} state, next_state;

assign slave_ready = port_ready;
assign slave_valid = port_valid;

always_comb begin : NEXT_STATE_DECODER
    unique0 case (state)
        IDLE: next_state = ( ( master_valid == 1 ) ? ADDR_IN : IDLE );
        ADDR_IN: next_state = ( (counter < ADDR_WIDTH-1) ? ( (port_ready == 1 && master_valid == 1 ) ? ADDR_IN : IDLE ) : ( (mode == 1) ? DATA_IN : SEND_RD_ADDR ) );
        DATA_IN: next_state = ( (counter < ADDR_WIDTH+DATA_WIDTH) ? ( ( port_ready == 1 && master_valid == 1 ) ? DATA_IN : IDLE ) : WRITE );
        WRITE: next_state = IDLE;
        SEND_RD_ADDR: next_state = READ;
        READ: next_state = ( (valid_in) ? SEND : ( (SPLIT_EN ? SPLIT : READ) ) );
        SPLIT: next_state = ( (valid_in) ? SEND : SPLIT);
        SEND: next_state = ( (counter < DATA_WIDTH) ? SEND : IDLE );
        default: next_state = IDLE;
    endcase
end

always_ff@(posedge clk) begin : STATE_SEQUENCER
    if (!rstn) state <= IDLE;
    else state <= next_state;
end


// OUTPUT DECODER
assign port_ready = (state == ADDR_IN) | (state == DATA_IN);
assign port_valid = (state == SEND);
assign split = (state == SPLIT);
assign rd_bus = uart_register_in[DATA_WIDTH-1-counter];

always_ff@(posedge clk) begin : OUTPUT_DECODER
    unique0 case (state)
        IDLE: begin
            counter <= 0;
            addr_in <= 0;
            data_in <= 0;
            valid_out <= 0;
        end

        ADDR_IN: begin
            addr_in[ADDR_WIDTH-1-counter] <= wr_bus;
            counter <= counter + 1;
        end

        DATA_IN: begin  
            data_in[DATA_WIDTH-1+ADDR_WIDTH-counter] <= wr_bus;
            counter <= counter + 1;
        end

        WRITE: begin
            uart_register_out <= {mode, addr_in, data_in};
            valid_out <= 1;
        end

        SEND_RD_ADDR: begin
            uart_register_out <= {mode, addr_in, 0};
            valid_out <= 1;
        end

        READ: begin
            valid_out <= 0;
            counter <= 0;
        end

        SEND: begin
            if (master_ready == 1) counter <= counter + 1;
        end
    endcase
end
endmodule