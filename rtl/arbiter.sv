module arbiter(
    input   logic       clk,
    input   logic       rstn,

    // connections to master 1
    input   logic       m1_mode,
    output  logic       m1_rd_bus,
    input   logic       m1_wr_bus,
    output  logic       m1_ack,
    input   logic       m1_master_valid,
    output  logic       m1_slave_ready,
    input   logic       m1_master_ready,
    output  logic       m1_slave_valid,

    // connections to slave 1
    output  logic       s1_mode,
    output  logic       s1_wr_bus,
    output  logic       s1_master_valid,
    output  logic       s1_master_ready,
    input   logic       s1_rd_bus,
    input   logic       s1_slave_ready,
    input   logic       s1_slave_valid,

    // connections to slave 2
    output  logic       s2_mode,
    output  logic       s2_wr_bus,
    output  logic       s2_master_valid,
    output  logic       s2_master_ready,
    input   logic       s2_rd_bus,
    input   logic       s2_slave_ready,
    input   logic       s2_slave_valid,

    // connections to slave 3
    output  logic       s3_mode,
    output  logic       s3_wr_bus,
    output  logic       s3_master_valid,
    output  logic       s3_master_ready,
    input   logic       s3_rd_bus,
    input   logic       s3_slave_ready,
    input   logic       s3_slave_valid,

    // connections to bus bridge
    output  logic       bb_mode,
    output  logic       bb_wr_bus,
    output  logic       bb_master_valid,
    output  logic       bb_master_ready,
    input   logic       bb_rd_bus,
    input   logic       bb_slave_ready,
    input   logic       bb_slave_valid
);  

    enum logic[3:0] {IDLE, ADDR_P1, ADDR_P2, ADDR_P3, CONNECTED, ACK_PRE, ACK, CLEAN} state, next_state;
    enum logic[1:0] {S1, S2, S3, BB} slave;

    logic[4:0]  t_addr;
    logic[4:0]  t_count;
    logic       t_m1_slave_ready;
    logic       t_m1_slave_valid;

    always_comb begin : NEXT_STATE_LOGIC
        unique case (state)
            IDLE:               next_state = m1_master_valid ? ADDR_P1 : IDLE;
            ADDR_P1:            next_state = (t_count == 1 && m1_master_valid) ? ADDR_P2 : ADDR_P1;
            ADDR_P2:            next_state = (t_count == 3 && m1_master_valid) ? ADDR_P3 : ADDR_P2;
            ADDR_P3:            next_state = (t_count == 4 && m1_master_valid) ? ACK_PRE : ADDR_P3;
            ACK_PRE:            next_state = ACK;
            ACK:                next_state = m1_master_ready ? (m1_ack ? CONNECTED : CLEAN) : ACK;
            CONNECTED:          next_state = (t_count == 31) ? CLEAN : CONNECTED;
            CLEAN:              next_state = IDLE;
            default:            next_state = IDLE;
        endcase
    end

    always_ff @(posedge clk or negedge rstn) begin : STATE_SEQUENCER
        state <= !rstn ? IDLE : next_state;
    end

    assign m1_slave_ready = ((state == ADDR_P1) || (state == ADDR_P2) || (state == ADDR_P3)) ? 1 : t_m1_slave_ready;
    assign m1_slave_valid = state == ACK ? 1 : t_m1_slave_valid;

    always_comb begin : OUTPUT_LOGIC
        unique case (slave)
            S1: begin
                s1_mode         = m1_mode;
                s1_wr_bus       = m1_wr_bus;
                s1_master_valid = m1_master_valid;
                s1_master_ready = m1_master_ready;
                t_m1_slave_ready  = s1_slave_ready;
                t_m1_slave_valid  = s1_slave_valid;
                m1_rd_bus       = s1_rd_bus;
                
                s2_mode         = 0;
                s2_wr_bus       = 0;
                s2_master_valid = 0;
                s2_master_ready = 0;

                s3_mode         = 0;
                s3_wr_bus       = 0;
                s3_master_valid = 0;
                s3_master_ready = 0;

                bb_mode         = 0;
                bb_wr_bus       = 0;
                bb_master_valid = 0;
                bb_master_ready = 0;
            end
            S2: begin
                s1_mode         = 0;
                s1_wr_bus       = 0;
                s1_master_valid = 0;
                s1_master_ready = 0;

                s2_mode         = m1_mode;
                s2_wr_bus       = m1_wr_bus;
                s2_master_valid = m1_master_valid;
                s2_master_ready = m1_master_ready;
                t_m1_slave_ready  = s2_slave_ready;
                t_m1_slave_valid  = s2_slave_valid;
                m1_rd_bus       = s2_rd_bus;

                s3_mode         = 0;
                s3_wr_bus       = 0;
                s3_master_valid = 0;
                s3_master_ready = 0;

                bb_mode         = 0;
                bb_wr_bus       = 0;
                bb_master_valid = 0;
                bb_master_ready = 0;
            end
            S3: begin
                s1_mode         = 0;
                s1_wr_bus       = 0;
                s1_master_valid = 0;
                s1_master_ready = 0;

                s2_mode         = 0;
                s2_wr_bus       = 0;
                s2_master_valid = 0;
                s2_master_ready = 0;

                s3_mode         = m1_mode;
                s3_wr_bus       = m1_wr_bus;
                s3_master_valid = m1_master_valid;
                s3_master_ready = m1_master_ready;
                t_m1_slave_ready  = s3_slave_ready;
                t_m1_slave_valid  = s3_slave_valid;
                m1_rd_bus       = s3_rd_bus;

                bb_mode         = 0;
                bb_wr_bus       = 0;
                bb_master_valid = 0;
                bb_master_ready = 0;
            end
            BB: begin
                s1_mode         = 0;
                s1_wr_bus       = 0;
                s1_master_valid = 0;
                s1_master_ready = 0;

                s2_mode         = 0;
                s2_wr_bus       = 0;
                s2_master_valid = 0;
                s2_master_ready = 0;

                s3_mode         = 0;
                s3_wr_bus       = 0;
                s3_master_valid = 0;
                s3_master_ready = 0;

                bb_mode         = m1_mode;
                bb_wr_bus       = m1_wr_bus;
                bb_master_valid = m1_master_valid;
                bb_master_ready = m1_master_ready;
                t_m1_slave_ready  = bb_slave_ready;
                t_m1_slave_valid  = bb_slave_valid;
                m1_rd_bus       = bb_rd_bus;
            end
        endcase
    end

    always_ff @(posedge clk) begin : REG_LOGIC
        if (!rstn) begin
            t_count   <= 0;
            t_addr    <= 0;
            slave     <= S1;
            m1_ack    <= 0;
        end else begin
            unique0 case (state)
                IDLE: begin
                    slave   <= S1;
                    m1_ack <= 0;
                end
                ADDR_P1: if (m1_master_valid) begin
                    t_count <= t_count + 1;
                    t_addr  <= {t_addr[3:0], m1_wr_bus};
                end

                ADDR_P2: if (m1_master_valid) begin
                    if (t_count == 2) begin
                        unique0 case (t_addr[1:0])
                            2'b11: begin
                                slave   <= BB;
                                m1_ack  <= 1;
                            end
                        endcase
                    end
                    t_count <= t_count + 1;
                    t_addr  <= {t_addr[2:0], m1_wr_bus};
                end

                ADDR_P3: if (m1_master_valid) begin
                    if (t_count == 4) begin
                        unique0 case (t_addr[3:0])
                            4'b0001: begin
                                slave <= S2;
                                m1_ack <= 1;
                            end
                            4'b0010: begin
                                slave <= S3;
                                m1_ack <= 1;
                            end
                        endcase
                    end
                    t_count <= t_count + 1;
                    t_addr  <= {t_addr[3:0], m1_wr_bus};
                end

                ACK_PRE: if (m1_master_valid) begin
                    if (t_addr == 5'b00000) begin
                        slave <= S1;
                        m1_ack <= 1;
                    end
                end

                CLEAN: begin
                    t_count <= 0;
                    t_addr  <= 0;
                    slave   <= S1;
                end
            endcase
        end
    end
endmodule
