`timescale 1ns/1ns

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

    logic [11:0] slave_2_addr_hold, slave_3_addr_hold;
    logic [10:0] slave_1_addr_hold;
    logic [13:0] bus_bridge_addr_hold; 

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rstn        = 0;
        #20;
        rstn        = 1;
        #20;

        // testing Bus Bridge
        @(negedge clk);
        bus_bridge_addr_hold = $urandom_range(0, 2**14-1);
        m_wr_data   = $urandom_range(0, 2**8-1);
        m_addr      = {2'b11, bus_bridge_addr_hold};
        m_mode      = 1;
        m_start     = 1;

        // $display("%b",m_addr);

        @(negedge clk);
        m_start     = 0;

        #400;

        @(negedge clk);
        m_mode      = 0;
        m_start     = 1;

        while (!m_wr_en) begin
            @(negedge clk);
        end

        assert (m_wr_data == m_rd_data) 
            $display("Bus Bridge Test passed!");
        else 
            $error("Bus Bridge Test failed!. expected %h, got %h", m_wr_data, m_rd_data);

        @(negedge clk);
        m_start     = 0;

        #400;


       // testing Slave 2
        @(negedge clk);
        slave_2_addr_hold = $urandom_range(0, 2**12-1);
        m_wr_data   = $urandom_range(0, 2**8-1);
        m_addr      = {4'b0001, slave_2_addr_hold};
        m_mode      = 1;
        m_start     = 1;

        // $display("%b",m_addr);

        @(negedge clk);
        m_start     = 0;

        #400;

        @(negedge clk);
        m_mode      = 0;
        m_start     = 1;

        while (!m_wr_en) begin
            @(negedge clk);
        end

        assert (m_wr_data == m_rd_data) 
            $display("Slave 2 Test passed!");
        else 
            $error("Slave 2 Test failed!. expected %h, got %h", m_wr_data, m_rd_data);

        @(negedge clk);
        m_start     = 0;

        #400;


        // testing Slave 3
        @(negedge clk);
        slave_3_addr_hold = $urandom_range(0, 2**12-1);
        m_wr_data   = $urandom_range(0, 2**8-1);
        m_addr      = {4'b0010, slave_3_addr_hold};
        m_mode      = 1;
        m_start     = 1;

        // $display("%b",m_addr);

        @(negedge clk);
        m_start     = 0;

        #400;

        @(negedge clk);
        m_mode      = 0;
        m_start     = 1;

        while (!m_wr_en) begin
            @(negedge clk);
        end

        assert (m_wr_data == m_rd_data) 
            $display("Slave 3 Test passed!");
        else 
            $error("Slave 3 Test failed!. expected %h, got %h", m_wr_data, m_rd_data);

        @(negedge clk);
        m_start     = 0;

        #400;


        // testing Slave 1
        @(negedge clk);
        slave_1_addr_hold = $urandom_range(0, 2**11-1);
        m_wr_data   = $urandom_range(0, 2**8-1);
        m_addr      = {5'b00000, slave_1_addr_hold};
        m_mode      = 1;
        m_start     = 1;

        // $display("%b",m_addr);

        @(negedge clk);
        m_start     = 0;

        #400;

        @(negedge clk);
        m_mode      = 0;
        m_start     = 1;

        while (!m_wr_en) begin
            @(negedge clk);
        end

        assert (m_wr_data == m_rd_data) 
            $display("Slave 1 Test passed!");
        else 
            $error("Slave 1 Test failed!. expected %h, got %h", m_wr_data, m_rd_data);

        @(negedge clk);
        m_start     = 0;

        #400;

        $finish;
    end


endmodule