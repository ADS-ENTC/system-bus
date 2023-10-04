module master_port (
    input   logic       clk,
    input   logic       rstn,
    // connections to bus
    output  logic       mp_bus_req,
    input   logic       mp_bus_grant,
    output  logic       mp_addr,
    output  logic       mp_wr_data,
    input   logic       mp_rd_data,
    output  logic       mp_wr_en,
    input   logic       mp_slave_ready,
    input  logic        mp_slave_valid,
    output  logic       mp_master_port_ready,
    output  logic       mp_master_port_valid,
    // connections to master
    input   logic[7:0]  m_wr_data,
    input   logic[15:0] m_addr,
    input   logic       m_wr_en,
    input   logic       m_master_valid,
    input   logic       m_master_ready,
    output  logic       m_master_port_valid,
    output  logic       m_master_port_ready
);
    enum logic[3:0] {IDLE, REQ, TX_ADDR_P1, TX_ADDR_P2, TX_WRITE, TX_READ} state, next_state;
    logic[3:0]  count;
    logic[7:0]  data;
    logic[15:0] addr;
    logic       write;

    always_comb begin : NEXT_STATE_LOGIC
        unique case (state)
            IDLE:       next_state = m_master_valid ? REQ : IDLE;
            REQ:        next_state = mp_bus_grant ? TX_ADDR_P1 : REQ;
            TX_ADDR_P1: next_state = count == 3 ? TX_ADDR_P2 : TX_ADDR_P1;
            TX_ADDR_P2: next_state = count == 7 ? (write ? TX_WRITE: TX_READ) : TX_ADDR_P2;
            TX_WRITE:   next_state = count == 15 ? IDLE : TX_WRITE;
            TX_READ:    next_state = count == 15 ? IDLE : TX_READ;
            default:    next_state = IDLE;
        endcase
    end

    always_ff @(posedge clk or negedge rstn) begin : STATE_SEQUENCER
        state <= !rstn ? IDLE : next_state;
    end

    always_comb begin : OUTPUT_LOGIC
        mp_wr_data              = data[7];
        mp_addr                 = addr[15];
        mp_bus_req              = state == REQ;
        mp_master_port_valid    = state == TX_ADDR_P1 | state == TX_ADDR_P2 | state == TX_WRITE;
        m_master_port_ready     = state == IDLE;
        mp_wr_en                = state == TX_WRITE;
    end

    always_ff @(posedge clk or negedge rstn) begin : REG_LOGIC
        if (!rstn) begin
            count   <= 0;
            data    <= 0;
            addr    <= 0;
        end else begin
            unique case (state)
                IDLE: if(m_master_valid) begin
                    data    <= m_wr_data;
                    addr    <= m_addr;
                    write   <= m_wr_en;
                end
                REQ: begin
                    count   <= 0;
                end
                TX_ADDR_P1: begin
                    count   <= count + 1;
                    addr    <= addr << 1;
                end
                TX_ADDR_P2: if (mp_slave_ready) begin
                    count   <= count + 1;
                    addr    <= addr << 1;
                end
                TX_WRITE: if (mp_slave_ready) begin
                    count   <= count + 1;
                    addr    <= addr << 1;
                    data    <= data << 1;
                end
                TX_READ: if (mp_slave_ready) begin
                    count   <= count + 1;
                    addr    <= addr << 1;
                end
            endcase
        end
    end
endmodule