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

    enum logic[3:0] {IDLE, ADDR, CONNECTED, CLEAN} state, next_state;
    enum logic[1:0] {S1, S2, S3, BB} slave;

    logic[4:0]  t_addr;
    logic[4:0]  t_count;
    logic       t_m1_slave_ready;

    always_comb begin : NEXT_STATE_LOGIC
        unique case (state)
            IDLE:               next_state = m1_master_valid ? ADDR : IDLE;
            ADDR:               next_state = (t_count == 5 && m1_master_valid) ? (m1_ack ? CONNECTED : CLEAN) : ADDR;
            CONNECTED:          next_state = (t_count == 31) ? CLEAN : CONNECTED;
            CLEAN:              next_state = IDLE;
            default:            next_state = IDLE;
        endcase
    end

    always_ff @(posedge clk or negedge rstn) begin : STATE_SEQUENCER
        state <= !rstn ? IDLE : next_state;
    end

    assign m1_slave_ready = m1_ack ? t_m1_slave_ready : state == ADDR;

    always_comb begin : OUTPUT_LOGIC
        unique0 case (t_addr[4:3])
            2'b11: begin
                slave = BB;
                m1_ack = 1 && t_count > 1;
            end

            2'b00: begin
                unique0 case (t_addr[2:1])
                    2'b01: begin
                        slave = S2;
                        m1_ack = 1 && t_count > 3;
                    end
                    2'b10: begin
                        slave = S3;
                        m1_ack = 1 && t_count > 3;
                    end
                    2'b00: begin
                        unique0 case (t_addr[0])
                            1'b0: begin
                                slave = S1;
                                m1_ack = 1 && t_count > 4;
                            end
                            1'b1: begin
                                slave = S1;
                                m1_ack = 0 && t_count > 3;
                            end
                        endcase
                    end
                    default: begin
                        slave = S1;
                        m1_ack = 0;
                    end
                endcase
            end
            default: begin
                slave = S1;
                m1_ack = 0;
            end
        endcase

        unique case (slave)
            S1: begin
                s1_mode         = m1_mode;
                s1_wr_bus       = m1_wr_bus;
                s1_master_valid = m1_master_valid && m1_ack;
                s1_master_ready = m1_master_ready;
                t_m1_slave_ready  = s1_slave_ready;
                m1_slave_valid  = s1_slave_valid;
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
                s2_master_valid = m1_master_valid && m1_ack;
                s2_master_ready = m1_master_ready;
                t_m1_slave_ready  = s2_slave_ready;
                m1_slave_valid  = s2_slave_valid;
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
                s3_master_valid = m1_master_valid && m1_ack;
                s3_master_ready = m1_master_ready;
                t_m1_slave_ready  = s3_slave_ready;
                m1_slave_valid  = s3_slave_valid;
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
                bb_master_valid = m1_master_valid && m1_ack;
                bb_master_ready = m1_master_ready;
                t_m1_slave_ready  = bb_slave_ready;
                m1_slave_valid  = bb_slave_valid;
                m1_rd_bus       = bb_rd_bus;
            end
        endcase
    end

    always_ff @(posedge clk) begin : REG_LOGIC
        if (!rstn) begin
            t_count     <= 0;
            t_addr      <= 0;
        end else begin
            unique0 case (state)
                ADDR: if (m1_master_valid) begin
                    t_count <= t_count + 1;
                    t_addr[4 - t_count] <= m1_wr_bus;
                end

                CONNECTED: begin
                    t_count <= t_count + 1;
                end

                CLEAN: begin
                    t_count <= 0;
                    t_addr  <= 0;
                end
            endcase
        end
    end
endmodule
