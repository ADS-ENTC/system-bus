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

    enum logic[3:0] {IDLE, ADDR_1, ACK, CLEAN, ADDR_2} state, next_state;

    logic[4:0]  t_addr;
    logic[3:0]  t_count;
    logic[1:0]  t_ss, t_ss_reg;

    always_comb begin : NEXT_STATE_LOGIC
        unique case (state)
            IDLE:               next_state = m1_master_valid ? ADDR_1 : IDLE;
            ADDR_1:             next_state = (t_count == 4 & m1_master_valid) ? ACK : ADDR_1;
            ACK:                next_state = m1_master_ready ? (m1_ack ? ADDR_2 : CLEAN) : ACK;
            CLEAN:              next_state = IDLE;
            default:            next_state = IDLE;
        endcase
    end

    always_ff @(posedge clk or negedge rstn) begin : STATE_SEQUENCER
        state <= !rstn ? IDLE : next_state;
    end

    always_comb begin : OUTPUT_LOGIC
        m1_slave_ready = state == ADDR_1;
        m1_slave_valid = state == ACK;

        unique0 case (t_addr[4:3])
            2'b00: begin
                unique0 case (t_addr[2:1])
                    2'b00: begin
                        if (t_addr[0] == 0) begin
                            m1_ack = 1;
                            t_ss = 0;
                        end else begin
                            m1_ack = 0;
                            t_ss = 0;
                        end
                    end
                    2'b01: begin
                        m1_ack = 1;
                        t_ss = 1;
                    end
                    2'b10: begin
                        m1_ack = 1;
                        t_ss = 2;
                    end
                    default: begin
                        m1_ack = 0;
                        t_ss = 0;
                    end
                endcase
            end
            2'b11: begin
                m1_ack = 1;
                t_ss = 3;
            end
            default: begin
                m1_ack = 0;
                t_ss = 0;
            end
        endcase
    end

    always_ff @(posedge clk or negedge rstn) begin : REG_LOGIC
        if (!rstn) begin
            t_count   <= 0;
            t_addr    <= 0;
            t_ss_reg  <= 0;
        end else begin
            unique0 case (state)
                ADDR_1: begin
                    t_count <= t_count + 1;
                    t_addr  <= {t_addr[3:0], m1_wr_bus};
                end

                ACK: begin
                    t_ss_reg <= t_ss;
                end

                CLEAN: begin
                    t_count <= 0;
                    t_addr  <= 0;
                    t_ss_reg <= 0;
                end
            endcase
        end
    end
endmodule
