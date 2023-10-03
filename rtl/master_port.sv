module master_port (
    input   logic       clk,
    input   logic       rstn,
    // connections to bus
    output  logic       mp_breq,
    input   logic       mp_bgnt,
    output  logic       mp_addr,
    output  logic       mp_wdata,
    input   logic       mp_ready,
    output  logic       mp_valid,
    // connections to master
    input   logic[7:0]  m_data,
    input   logic[15:0] m_addr,
    input   logic       m_valid,
    output  logic       m_ready
);
    enum logic[3:0] {IDLE, REQ, TX_ADDR_P1, TX_ADDR_P2, TX_DATA} state, next_state;
    logic[3:0]  count;
    logic[7:0]  data;
    logic[15:0] addr;

    always_comb begin : NEXT_STATE_LOGIC
        unique case (state)
            IDLE:       next_state = m_valid ? REQ : IDLE;
            REQ:        next_state = mp_bgnt ? TX_ADDR_P1 : REQ;
            TX_ADDR_P1: next_state = count == 3 ? TX_ADDR_P2 : TX_ADDR_P1;
            TX_ADDR_P2: next_state = count == 7 ? TX_DATA : TX_ADDR_P2;
            TX_DATA:    next_state = count == 15 ? IDLE : TX_DATA;
            default:    next_state = IDLE;
        endcase
    end

    always_ff @(posedge clk or negedge rstn) begin : STATE_SEQUENCER
        state <= !rstn ? IDLE : next_state;
    end

    always_comb begin : OUTPUT_LOGIC
        mp_wdata = data[7];
        mp_addr  = addr[15];
        mp_breq  = state == REQ;
        mp_valid = state == TX_ADDR_P1 | state == TX_ADDR_P2 | state == TX_DATA;
    end

    always_ff @(posedge clk or negedge rstn) begin : REG_LOGIC
        if (!rstn) begin
            count   <= 0;
            data    <= 0;
            addr    <= 0;
        end else begin
            unique case (state)
                IDLE: begin
                    data    <= m_data;
                    addr    <= m_addr;
                end
                REQ: begin
                    count   <= 0;
                end
                TX_ADDR_P1: begin
                    count   <= count + 1;
                    addr    <= addr << 1;
                end
                TX_ADDR_P2: if (mp_ready) begin
                    count   <= count + 1;
                    addr    <= addr << 1;
                end
                TX_DATA: if (mp_ready) begin
                    count   <= count + 1;
                    addr    <= addr << 1;
                    data    <= data << 1;
                end
            endcase
        end
    end
endmodule