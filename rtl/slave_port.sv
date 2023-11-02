module slave_port #(
  parameter ADDR_W = 12,
  parameter DATA_W = 8
)(
  // inputs from the interconnect
  input logic in_clk, reset_n, burst_en, ser_in_valid_ready, ss, in_write, in_addr, ser_wdata,

  // inputs from the target (slave)
  input logic par_in_valid_ready, in_split_en,
  input logic [DATA_W-1:0] par_rdata,

  // outputs to the interconnect
  output logic ser_out_valid_ready, out_split_en, ser_rdata,

  // outputs to the target (slave)
  output logic par_out_valid_ready, out_write, out_clk,
  output logic [ADDR_W-1:0] out_addr,
  output logic [DATA_W-1:0] par_wdata
);

// definition of states
localparam NUM_STATES = 6;
localparam STATE_N_BITS = $clog2(NUM_STATES);

// RX_ADDR_P1: receive address part 1 (first 4 bits), RX_ADDR_P2: receive address part 2 (last 8 bits), RS: receiveing from slave, WS: writing to slave, TX: transmitting serial data, RX_DATA: receiving serial data
enum logic [STATE_N_BITS-1:0] {RX_ADDR_P1, RX_ADDR_P2, RS, TX, RX_DATA, WS} state, next_state;

// counter to keep track of the number of bits received/transmitted
localparam N_BITS = $clog2(ADDR_W);
logic [N_BITS-1:0] count;

// internal registers to hold the address and the data
logic [ADDR_W-1:0] internal_addr;
logic [DATA_W-1:0] internal_data;

always_comb begin : NEXT_STATE_DECODER
  unique case (state)
    RX_ADDR_P1: next_state = count == (ADDR_W - DATA_W) ? (in_write == 1 ? RX_DATA : RX_ADDR_P2) : RX_ADDR_P1;
    RX_ADDR_P2: next_state = count == ADDR_W ? RS : RX_ADDR_P2;
    RS: next_state = par_in_valid_ready == 1 ? TX : RS;
    TX: next_state = (count == DATA_W - 1 && ser_in_valid_ready == 1) ? RX_ADDR_P1 : TX;
    RX_DATA: next_state = count == DATA_W ? WS : RX_DATA;
    WS: next_state = par_in_valid_ready == 1 ? RX_ADDR_P1 : WS;
  endcase
end

// state sequencer with active low reset
always_ff@(posedge in_clk or negedge reset_n) begin : STATE_SEQUENCER
  state = reset_n == 0 ? RX_ADDR_P1 : next_state;
end

assign out_clk = in_clk;
assign ser_rdata = internal_data[0];
assign out_split_en = in_split_en; // TODO: think about this when implementing split transactions

always_ff@(posedge in_clk or negedge reset_n) begin : OUTPUT_DECODER
  if (reset_n == 0) count <= 0;
  else unique case (state)
    RX_ADDR_P1: begin
                  par_out_valid_ready <= 1'd0;
                  ser_out_valid_ready <= 1'd1;

                  if (ss == 1 && ser_in_valid_ready == 1) begin
                    internal_addr <= internal_addr >> 1;
                    internal_addr[ADDR_W-1] <= in_addr;
                    count <= count + 1;
                  end
                end
    RX_DATA:    begin
                  par_out_valid_ready <= 1'd0;
                  ser_out_valid_ready <= 1'd1;

                  if (ss == 1 && ser_in_valid_ready == 1) begin
                    internal_addr <= internal_addr >> 1;
                    internal_addr[ADDR_W-1] <= in_addr;

                    internal_data <= internal_data >> 1;
                    internal_data[DATA_W-1] <= ser_wdata;
                    count <= count + 1;
                  end
                end
    RX_ADDR_P2: begin
                  par_out_valid_ready <= 1'd0;
                  ser_out_valid_ready <= 1'd1;

                  if (ss == 1 && ser_in_valid_ready == 1) begin
                    internal_addr <= internal_addr >> 1;
                    internal_addr[ADDR_W-1] <= in_addr;
                    count <= count + 1;
                  end
                end
    TX:         begin
                  par_out_valid_ready <= 1'd0;
                  ser_out_valid_ready <= 1'd1;

                  if (ss == 1 && ser_in_valid_ready == 1) begin
                    internal_data <= internal_data >> 1;
                    count <= count + 1;
                  end
                end
    WS:         begin
                  ser_out_valid_ready <= 1'd0;
                  par_out_valid_ready <= 1'd1;
                  out_write <= 1'd1;

                  par_wdata <= internal_data;
                  out_addr <= internal_addr;
                end
    RS:         begin
                  ser_out_valid_ready <= 1'd0;
                  par_out_valid_ready <= 1'd1;
                  out_write <= 1'd0;

                  out_addr <= internal_addr;
                  internal_data <= par_rdata;

                  count <= 0;
                end
  endcase
end

endmodule