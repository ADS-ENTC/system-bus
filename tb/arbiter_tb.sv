module arbiter_tb;
    logic       clk;
    logic       rstn;

    // connections to master 1;
    logic       m1_mode;
    logic       m1_rd_bus;
    logic       m1_wr_bus;
    logic       m1_ack;
    logic       m1_master_valid;
    logic       m1_slave_ready;
    logic       m1_master_ready;
    logic       m1_slave_valid;

    // connections to slave 1;
    logic       s1_mode;
    logic       s1_wr_bus;
    logic       s1_master_valid;
    logic       s1_master_ready;
    logic       s1_rd_bus;
    logic       s1_slave_ready;
    logic       s1_slave_valid;

    // connections to slave 2;
    logic       s2_mode;
    logic       s2_wr_bus;
    logic       s2_master_valid;
    logic       s2_master_ready;
    logic       s2_rd_bus;
    logic       s2_slave_ready;
    logic       s2_slave_valid;

    // connections to slave 3;
    logic       s3_mode;
    logic       s3_wr_bus;
    logic       s3_master_valid;
    logic       s3_master_ready;
    logic       s3_rd_bus;
    logic       s3_slave_ready;
    logic       s3_slave_valid;

    // connections to bus bridge;
    logic       bb_mode;
    logic       bb_wr_bus;
    logic       bb_master_valid;
    logic       bb_master_ready;
    logic       bb_rd_bus;
    logic       bb_slave_ready;
    logic       bb_slave_valid;


    logic[7:0]  m_wr_data;
    logic[7:0]  m_rd_data;
    logic[15:0] m_addr;
    logic       m_mode;
    logic       m_wr_en;
    logic       m_start;

    arbiter arb (.*);
    master_port mp (
        .clk(clk),
        .rstn(rstn),
        .mode(m1_mode),
        .rd_bus(m1_rd_bus),
        .wr_bus(m1_wr_bus),
        .ack(m1_ack),
        .master_valid(m1_master_valid),
        .slave_ready(m1_slave_ready),
        .master_ready(m1_master_ready),
        .slave_valid(m1_slave_valid),
        .m_wr_data(m_wr_data),
        .m_rd_data(m_rd_data),
        .m_addr(m_addr),
        .m_mode(m_mode),
        .m_wr_en(m_wr_en),
        .m_start(m_start)
    );

    slave_port_v2  #(
        .ADDR_WIDTH(11),
        .DATA_WIDTH(8)
    )sp1(
        .clk(clk),
        .rstn(rstn),
        .mode(s1_mode),
        .rd_bus(s1_rd_bus),
        .wr_bus(s1_wr_bus),
        .master_valid(s1_master_valid),
        .slave_ready(s1_slave_ready),
        .master_ready(s1_master_ready),
        .slave_valid(s1_slave_valid)
    );

    slave_port_v2  #(
        .ADDR_WIDTH(12),
        .DATA_WIDTH(8)
    )sp2(
        .clk(clk),
        .rstn(rstn),
        .mode(s2_mode),
        .rd_bus(s2_rd_bus),
        .wr_bus(s2_wr_bus),
        .master_valid(s2_master_valid),
        .slave_ready(s2_slave_ready),
        .master_ready(s2_master_ready),
        .slave_valid(s2_slave_valid)
    );

    slave_port_v2  #(
        .ADDR_WIDTH(12),
        .DATA_WIDTH(8)
    )sp3(
        .clk(clk),
        .rstn(rstn),
        .mode(s3_mode),
        .rd_bus(s3_rd_bus),
        .wr_bus(s3_wr_bus),
        .master_valid(s3_master_valid),
        .slave_ready(s3_slave_ready),
        .master_ready(s3_master_ready),
        .slave_valid(s3_slave_valid)
    );

    slave_port_v2  #(
        .ADDR_WIDTH(14),
        .DATA_WIDTH(8)
    )bb(
        .clk(clk),
        .rstn(rstn),
        .mode(bb_mode),
        .rd_bus(bb_rd_bus),
        .wr_bus(bb_wr_bus),
        .master_valid(bb_master_valid),
        .slave_ready(bb_slave_ready),
        .master_ready(bb_master_ready),
        .slave_valid(bb_slave_valid)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rstn        = 0;
        #20;
        rstn        = 1;
        #20;

        @(negedge clk);
        m_wr_data   = 8'hd3;
        m_addr      = 16'hcbcd;
        m_mode      = 1;
        m_start     = 1;

        @(negedge clk);
        m_start     = 0;

        // #80;
        // $display("m1_slave_ready = %b, bb_slave_ready = %b, t_m1_slave_ready = %b", m1_slave_ready, bb_slave_ready, arb.t_m1_slave_ready);
        // $display("condition = %b", ((arb.state == arb.ADDR_P1) || (arb.state == arb.ADDR_P2) || (arb.state == arb.ADDR_P3)) ? 1 : arb.t_m1_slave_ready);

        #400;

        @(negedge clk);
        m_mode      = 0;
        m_start     = 1;

        @(negedge clk);
        m_start     = 0;

        #400;

        $finish;
    end


endmodule