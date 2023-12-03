module arbiter_master_select (
    input logic BREQ1, BREQ2, rstn, clk,
    output logic BGRANT1, BGRANT2
);

// local parameters
localparam NUM_STATES = 4;
localparam STATE_N_BITS = $clog2(NUM_STATES);

// internal signals
logic [2:0] bus_owner;
localparam bus_priority = 0;

// states
enum logic [STATE_N_BITS-1:0] {IDLE, REQ1, REQ2, REQ12} state, next_state;

// next state decoder
always_comb begin : NEXT_STATE_DECODER
    unique0 case (state)
        IDLE: next_state = ( (BREQ1 == 0) ? ( (BREQ2 == 0) ? IDLE : REQ2 ) : ( (BREQ2 == 0) ? REQ1 : REQ12 ) );
        REQ1: next_state = ( (BREQ1 == 0) ? IDLE : REQ1 );
        REQ2: next_state = ( (BREQ2 == 0) ? IDLE : REQ2 );
        REQ12: next_state = ( (BREQ1 == 0 || BREQ2 == 0) ? IDLE : REQ12 );
        default: next_state = IDLE;
    endcase
end

// state sequencer
always_ff@(posedge clk) begin : STATE_SEQUENCER
    if (!rstn) state <= IDLE;
    else state <= next_state;
end

// output decoder
assign BGRANT1 =  bus_owner[0];
assign BGRANT2 = bus_owner[1];

always_ff@(posedge clk) begin : OUTPUT_DECODER
    unique0 case (state)
        IDLE: begin
            bus_owner <= 0;
        end

        REQ1: begin
            bus_owner <= 1;
        end

        REQ2: begin
            bus_owner <= 2;
        end

        REQ12: begin
            bus_owner <= ( (bus_priority == 0) ? 1 : 2 );
        end
    endcase
end

endmodule