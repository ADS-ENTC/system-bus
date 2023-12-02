module master_port (
    input   logic       clk,
    input   logic       rstn,
    // connections to bus
    output  logic       mode,
    input   logic       rd_bus,
    output  logic       wr_bus,
    input   logic       ack,
    output  logic       master_valid,
    input   logic       slave_ready,
    output  logic       master_ready,
    input   logic       slave_valid,
    // connections to master
    input   logic[7:0]  m_wr_data,
    output  logic[7:0]  m_rd_data,
    input   logic[15:0] m_addr,
    input   logic       m_mode,
    output  logic       m_wr_en,
    input   logic       m_start
);
    enum logic[3:0] {IDLE, FETCH, ADDR_1, ACK, ADDR_2, WR_DATA, RD_DATA, CLEAN} state, next_state;
    
    logic[3:0]  t_count;
    logic[7:0]  t_wr_data;
    logic[7:0]  t_rd_data;
    logic[15:0] t_addr;
    logic       t_mode;

    always_comb begin : NEXT_STATE_LOGIC
        unique case (state)
            IDLE:               next_state = m_start ? FETCH : IDLE;
            FETCH:              next_state = ADDR_1;
            ADDR_1:             next_state = (t_count == 4 & slave_ready) ? ACK : ADDR_1;
            ACK:                next_state = slave_valid ? (ack ? ADDR_2 : CLEAN) : ACK;
            ADDR_2:             next_state = (t_count == 15 & slave_ready) ? (t_mode ? WR_DATA : RD_DATA) : ADDR_2;
            WR_DATA:            next_state = (t_count == 7  & slave_ready) ? IDLE : WR_DATA;
            RD_DATA:            next_state = (t_count == 7 & slave_valid) ? CLEAN : RD_DATA;
            CLEAN:              next_state = IDLE;
            default:            next_state = IDLE;
        endcase
    end

    always_ff @(posedge clk or negedge rstn) begin : STATE_SEQUENCER
        state <= !rstn ? IDLE : next_state;
    end

    always_comb begin : OUTPUT_LOGIC
        wr_bus  = state == WR_DATA ? t_wr_data[7] : t_addr[15];
        mode    = t_mode;
        master_valid = state == ADDR_2 || state == ADDR_1 || state == WR_DATA;
        master_ready = state == RD_DATA || state == ACK;
        m_rd_data = t_rd_data;
        m_wr_en = state == CLEAN & t_count == 8;
    end

    always_ff @(posedge clk) begin : REG_LOGIC
        if (!rstn) begin
            t_count   <= 0;
            t_wr_data <= 0;
            t_rd_data <= 0;
            t_addr    <= 0;
            t_mode    <= 0;
        end else begin
            unique0 case (state)
                FETCH: begin
                    t_wr_data <= m_wr_data;
                    t_rd_data <= m_rd_data;
                    t_addr    <= m_addr;
                    t_mode    <= m_mode;
                    t_count   <= 0;
                end

                ADDR_1: if(slave_ready) begin
                    t_addr <= t_addr << 1;
                    t_count <= t_count + 1;
                end

                ADDR_2: if(slave_ready) begin
                    t_addr <= t_addr << 1;
                    t_count <= t_count + 1;
                end

                WR_DATA: if(slave_ready) begin
                    t_wr_data <= t_wr_data << 1;
                    t_count <= t_count + 1;
                end

                RD_DATA: if(slave_valid) begin
                    t_rd_data <= {t_rd_data[6:0], rd_bus};
                    t_count <= t_count + 1;
                end

                CLEAN: begin
                    t_count <= 0;
                    t_wr_data <= 0;
                    t_rd_data <= 0;
                    t_addr    <= 0;
                    t_mode    <= 0;
                end
            endcase
        end
    end
endmodule