module arbiter#(
    parameter  bus_priority = 0
)(
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
    input   logic       m1_breq,
    output  logic       m1_bgrant,

    // connections to master 2
    input   logic       m2_mode,
    output  logic       m2_rd_bus,
    input   logic       m2_wr_bus,
    output  logic       m2_ack,
    input   logic       m2_master_valid,
    output  logic       m2_slave_ready,
    input   logic       m2_master_ready,
    output  logic       m2_slave_valid,
    input   logic       m2_breq,
    output  logic       m2_bgrant,

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
    input   logic       bb_slave_valid,

    input   logic       slave_split,
    output  logic       m1_split,
    output  logic       m2_split  
);  

    enum logic[2:0] {IDLE, ADDR, CONNECTED, CLEAN, REQ1, REQ2, REQ12, SPLIT} state, next_state;
    enum logic[1:0] {S1, S2, S3, BB} slave;
    enum logic[1:0] {NONE, M1, M2} split_owner;

    logic[4:0]  t_addr;
    logic[4:0]  t_count;
    logic       t_slave_ready;
    logic       bus_owner;

    logic       mode;
    logic       rd_bus;
    logic       wr_bus;
    logic       ack;
    logic       master_valid;
    logic       slave_ready;
    logic       master_ready;
    logic       slave_valid;
    logic       breq;

    always_comb begin : NEXT_STATE_LOGIC
        case (state)
            IDLE:               begin
                                    if (split_owner == NONE)
                                        next_state = ( (m1_breq == 0) ? ( (m2_breq == 0) ? IDLE : REQ2 ) : ( (m2_breq == 0) ? REQ1 : REQ12 ) );
                                    else if (slave_split == 0)
                                        next_state = CONNECTED;
                                    else
                                        next_state = ( (m1_breq == 0 || split_owner == M1) ? ( (m2_breq == 0 || split_owner == M2) ? IDLE : REQ2 ) : ( (m2_breq == 0 || split_owner == M2) ? REQ1 : REQ12 ) );
                                end
            REQ1:               next_state = ( (m1_breq == 0) ? IDLE : (m1_master_valid) ? ADDR : REQ1 );
            REQ2:               next_state = ( (m2_breq == 0) ? IDLE : (m2_master_valid) ? ADDR : REQ2 );
            REQ12:              next_state = ( (m1_breq == 0 || m2_breq == 0) ? IDLE : (m1_master_valid) ? ADDR : REQ12 );
            ADDR:               next_state = (t_count == 5 && master_valid) ? (ack ? CONNECTED : CLEAN) : ADDR;
            CONNECTED:          next_state = (breq == 0) ? CLEAN : ((slave_split && (t_addr[4:1] == 4'b0001)) ? SPLIT : CONNECTED);
            SPLIT:              next_state = IDLE;
            CLEAN:              next_state = IDLE;
            default:            next_state = IDLE;
        endcase
    end

    always_ff @(posedge clk or negedge rstn) begin : STATE_SEQUENCER
        state <= !rstn ? IDLE : next_state;
    end

    assign slave_ready = ack ? t_slave_ready : state == ADDR;
    assign m1_bgrant = !bus_owner;
    assign m2_bgrant = bus_owner;
    assign m1_split = (split_owner == M1 ? slave_split : 0);
    assign m2_split = (split_owner == M2 ? slave_split : 0);

    always_comb begin
        if (bus_priority == 0) begin
            case (bus_owner)
                1'b1: begin
                    mode           = m2_mode;
                    m2_rd_bus      = rd_bus;
                    wr_bus         = m2_wr_bus;
                    m2_ack         = ack;
                    master_valid   = m2_master_valid;
                    m2_slave_ready = slave_ready;
                    master_ready   = m2_master_ready;
                    m2_slave_valid = slave_valid;
                    breq           = m2_breq;

                    m1_rd_bus      = 0;
                    m1_ack         = 0;
                    m1_slave_ready = 0;
                    m1_slave_valid = 0;
                end

                default: begin
                    mode           = m1_mode;
                    m1_rd_bus      = rd_bus;
                    wr_bus         = m1_wr_bus;
                    m1_ack         = ack;
                    master_valid   = m1_master_valid;
                    m1_slave_ready = slave_ready;
                    master_ready   = m1_master_ready;
                    m1_slave_valid = slave_valid;
                    breq           = m1_breq;

                    m2_rd_bus      = 0;
                    m2_ack         = 0;
                    m2_slave_ready = 0;
                    m2_slave_valid = 0;
                end
            endcase
        end else begin
            case (bus_owner)
                1'b0: begin
                    mode           = m1_mode;
                    m1_rd_bus      = rd_bus;
                    wr_bus         = m1_wr_bus;
                    m1_ack         = ack;
                    master_valid   = m1_master_valid;
                    m1_slave_ready = slave_ready;
                    master_ready   = m1_master_ready;
                    m1_slave_valid = slave_valid;
                    breq           = m1_breq;

                    m2_rd_bus      = 0;
                    m2_ack         = 0;
                    m2_slave_ready = 0;
                    m2_slave_valid = 0;
                end
                
                default: begin
                    mode           = m2_mode;
                    m2_rd_bus      = rd_bus;
                    wr_bus         = m2_wr_bus;
                    m2_ack         = ack;
                    master_valid   = m2_master_valid;
                    m2_slave_ready = slave_ready;
                    master_ready   = m2_master_ready;
                    m2_slave_valid = slave_valid;
                    breq           = m2_breq;

                    m1_rd_bus      = 0;
                    m1_ack         = 0;
                    m1_slave_ready = 0;
                    m1_slave_valid = 0;
                end
            endcase
        end
    end

    always_comb begin : OUTPUT_LOGIC
        case (t_addr[4:3])
            2'b11: begin
                slave = BB;
                ack = t_count > 1;
            end

            2'b00: begin
                case (t_addr[2:1])
                    2'b01: begin
                        slave = S2;
                        ack = t_count > 3;
                    end
                    2'b10: begin
                        slave = S3;
                        ack = t_count > 3;
                    end
                    2'b00: begin
                        case (t_addr[0])
                            1'b0: begin
                                slave = S1;
                                ack = t_count > 4;
                            end
                            1'b1: begin
                                slave = S1;
                                ack = 0;
                            end
                        endcase
                    end
                    default: begin
                        slave = S1;
                        ack = 0;
                    end
                endcase
            end
            default: begin
                slave = S1;
                ack = 0;
            end
        endcase

        case (slave)
            S1: begin
                s1_mode         = mode;
                s1_wr_bus       = wr_bus;
                s1_master_valid = master_valid && ack;
                s1_master_ready = master_ready;
                t_slave_ready   = s1_slave_ready;
                slave_valid     = s1_slave_valid;
                rd_bus          = s1_rd_bus;
                
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

                s2_mode         = mode;
                s2_wr_bus       = wr_bus;
                s2_master_valid = master_valid && ack;
                s2_master_ready = master_ready;
                t_slave_ready  = s2_slave_ready;
                slave_valid  = s2_slave_valid;
                rd_bus       = s2_rd_bus;

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

                s3_mode         = mode;
                s3_wr_bus       = wr_bus;
                s3_master_valid = master_valid && ack;
                s3_master_ready = master_ready;
                t_slave_ready  = s3_slave_ready;
                slave_valid  = s3_slave_valid;
                rd_bus       = s3_rd_bus;

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

                bb_mode         = mode;
                bb_wr_bus       = wr_bus;
                bb_master_valid = master_valid && ack;
                bb_master_ready = master_ready;
                t_slave_ready  = bb_slave_ready;
                slave_valid  = bb_slave_valid;
                rd_bus       = bb_rd_bus;
            end
        endcase
    end

    always_ff @(posedge clk) begin : REG_LOGIC
        if (!rstn) begin
            t_count     <= 0;
            t_addr      <= 0;
            bus_owner   <= 0;
            split_owner <= NONE;
        end else begin
            case (state)
                IDLE: begin
                    if (split_owner != NONE && slave_split == 0) begin
                        bus_owner <= (split_owner == M1 ? 0 : 1);
                        t_addr[4:1] <= 4'b0001;
                    end
                end
                
                REQ1: begin
                    bus_owner <= 0;
                end

                REQ2: begin
                    bus_owner <= 1;
                end

                REQ12: begin
                    bus_owner <= bus_priority;
                end

                ADDR: if (master_valid) begin
                    t_count <= t_count + 1;
                    t_addr[4 - t_count] <= wr_bus;
                end

                CONNECTED: begin
                    t_count <= t_count + 1;
                end

                SPLIT: begin
                    split_owner <= (bus_owner == 0) ? M1 : M2;
                end

                CLEAN: begin
                    t_count <= 0;
                    t_addr  <= 0;

                    if (bus_owner == 0 && split_owner == M1) split_owner <= NONE;
                    else if (bus_owner == 1 && split_owner == M2) split_owner <= NONE;
                end
            endcase
        end
    end
endmodule
