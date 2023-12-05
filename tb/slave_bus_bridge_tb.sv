`timescale 1ns/1ns

module slave_bus_bridge_tb;
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
    logic       m1_breq;
    logic       m1_bgrant;
    logic       m1_split;

    // connections to master 2;
    logic       m2_mode;
    logic       m2_rd_bus;
    logic       m2_wr_bus;
    logic       m2_ack;
    logic       m2_master_valid;
    logic       m2_slave_ready;
    logic       m2_master_ready;
    logic       m2_slave_valid;
    logic       m2_breq;
    logic       m2_bgrant;
    logic       m2_split;

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
    logic       slave_split;

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
    logic       [8-1:0]uart_register_in;
    logic       [25-1:0]uart_register_out;
    logic       uart_valid_in;
    logic       uart_valid_out;


    logic[7:0]  m1_wr_data;
    logic[7:0]  m1_rd_data;
    logic[15:0] m1_addr;
    logic       m1_mode_in; 
    logic       m1_wr_en;
    logic       m1_start;

    logic[7:0]  m2_wr_data;
    logic[7:0]  m2_rd_data;
    logic[15:0] m2_addr;
    logic       m2_mode_in; 
    logic       m2_wr_en;
    logic       m2_start;

    arbiter arb (.*);
    master_port mp_1 (
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
        .m_wr_data(m1_wr_data),
        .m_rd_data(m1_rd_data),
        .m_addr(m1_addr),
        .m_mode(m1_mode_in),
        .m_wr_en(m1_wr_en),
        .m_start(m1_start),
        .breq(m1_breq),
        .bgrant(m1_bgrant),
        .split(m1_split)
    );

    master_port mp_2 (
        .clk(clk),
        .rstn(rstn),
        .mode(m2_mode),
        .rd_bus(m2_rd_bus),
        .wr_bus(m2_wr_bus),
        .ack(m2_ack),
        .master_valid(m2_master_valid),
        .slave_ready(m2_slave_ready),
        .master_ready(m2_master_ready),
        .slave_valid(m2_slave_valid),
        .m_wr_data(m2_wr_data),
        .m_rd_data(m2_rd_data),
        .m_addr(m2_addr),
        .m_mode(m2_mode_in),
        .m_wr_en(m2_wr_en),
        .m_start(m2_start),
        .breq(m2_breq),
        .bgrant(m2_bgrant),
        .split(m2_split)
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
        .DATA_WIDTH(8),
        .SPLIT_EN(1)
    )sp2(
        .clk(clk),
        .rstn(rstn),
        .mode(s2_mode),
        .rd_bus(s2_rd_bus),
        .wr_bus(s2_wr_bus),
        .master_valid(s2_master_valid),
        .slave_ready(s2_slave_ready),
        .master_ready(s2_master_ready),
        .slave_valid(s2_slave_valid),
        .split(slave_split)
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

    slave_bus_bridge  #(
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
        .slave_valid(bb_slave_valid),
        .valid_in(uart_valid_in),
        .valid_out(uart_valid_out),
        .uart_register_in(uart_register_in),
        .uart_register_out(uart_register_out)
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

        
        // Write Transaction
        @(negedge clk);
        #1;
        m1_start     = 0;

        bus_bridge_addr_hold = $urandom_range(0, 2**14-1);
        m2_wr_data   = $urandom_range(0, 2**8-1);
        m2_addr      = {2'b11, bus_bridge_addr_hold};
        m2_mode_in   = 1;
        m2_start     = 1;

        @(negedge clk);
        #1;
        m2_start = 0;

        while(uart_valid_out == 0)
            @(negedge clk);
        
        assert (uart_register_out == {1'b1, 2'b00, bus_bridge_addr_hold, m2_wr_data}) 
            $display("Bus Bridge Write Test passed!");
        else 
            $error("Bus Bridge Write Test failed!. expected %h, got %h", {1'b1, 2'b00, bus_bridge_addr_hold, m2_wr_data}, uart_register_in);


        #400

        // Read Transaction
        @(negedge clk);
        #1;
        m1_start     = 0;

        bus_bridge_addr_hold = $urandom_range(0, 2**14-1);
        m2_wr_data   = $urandom_range(0, 2**8-1);
        m2_addr      = {2'b11, bus_bridge_addr_hold};
        m2_mode_in   = 0;
        m2_start     = 1;
        uart_valid_in = 0;
        #2;

        @(negedge clk);
        #1;
        m2_start = 0;

        while(uart_valid_out == 0)
            @(negedge clk);
        
        assert (uart_register_out== {1'b0, 2'b00, bus_bridge_addr_hold, 8'd0})
            $display("Bus Bridge Read Phase 1 Test passed!");
        else    
            $error("Bus Bridge Read Phase 1 Test failed!. expected %h, got %h", {1'b0, 2'b00, bus_bridge_addr_hold, 8'd0}, uart_register_out);

        @(negedge clk);
        #1;
        uart_valid_in = 1;
        uart_register_in = $urandom_range(0, 2**8-1);

        while (!m2_wr_en) begin
            @(negedge clk);
        end

        assert (uart_register_in == m2_rd_data) 
            $display("Bus Bridge Read Phase 2 Test passed!");
        else 
            $error("Bus Bridge Read Phase 2 Test failed!. expected %h, got %h", uart_register_in, m2_rd_data);

        $finish;
    end

endmodule