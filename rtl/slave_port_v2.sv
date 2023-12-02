module slave_port_v2#(
    parameter ADDR_WIDTH = 16,
    parameter DATA_WIDTH = 8
)(
    input logic mode, wr_bus, master_valid, master_ready, rstn, clk,
    output logic rd_bus, slave_ready, slave_valid
);

// local parameters
localparam COUNTER_LENGTH = $clog2(ADDR_WIDTH+DATA_WIDTH);
localparam NUM_STATES = 6;
localparam STATE_N_BITS = $clog2(NUM_STATES);

// internal signals
logic [COUNTER_LENGTH-1:0]counter;
logic [ADDR_WIDTH-1:0]addr_in;
logic [DATA_WIDTH-1:0]data_in;
logic port_ready, port_valid;

// dummy memory
logic [DATA_WIDTH-1:0]ram[63:0];

// definition of states
enum logic[STATE_N_BITS-1:0] {IDLE, ADDR_IN, DATA_IN, WRITE, READ, SEND} state, next_state;

assign slave_ready = port_ready;
assign slave_valid = port_valid;

always_comb begin : NEXT_STATE_DECODER
    unique case (state)
        IDLE: next_state = ( ( master_valid == 1 ) ? ADDR_IN : IDLE );
        ADDR_IN: next_state = ( (counter < ADDR_WIDTH) ? ( (port_ready == 1 && master_valid == 1 ) ? ADDR_IN : IDLE ) : ( (mode == 1) ? DATA_IN : READ ) );
        DATA_IN: next_state = ( (counter < ADDR_WIDTH+DATA_WIDTH) ? ( ( port_ready == 1 && master_valid == 1 ) ? DATA_IN : IDLE ) : WRITE );
        WRITE: next_state = IDLE;
        READ: next_state = SEND;
        SEND: next_state = ( (counter < DATA_WIDTH) ? SEND : IDLE );
    endcase
end

always_ff@(posedge clk) begin : STATE_SEQUENCER
    if (!rstn) state <= IDLE;
    else state <= next_state;
end


// OUTPUT DECODER
assign port_ready = (state == ADDR_IN) | (state == DATA_IN);
assign port_valid = (state == SEND);

always_ff@(posedge clk) begin : OUTPUT_DECODER
    unique0 case (state)
        IDLE: begin
            counter <= 0;
            addr_in <= 0;
            data_in <= 0;
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
            ram[addr_in[5:0]] <= data_in;
        end

        READ: begin
            counter <= 0;
            rd_bus <= ram[addr_in[5:0]][DATA_WIDTH-1-counter];
        end

        SEND: begin
            rd_bus <= ram[addr_in[5:0]][DATA_WIDTH-1-counter];
            if (master_ready == 1) counter <= counter + 1;
        end
    endcase
end
endmodule