`timescale 1ps/1ps

module bb_master_port_tb;
    logic       clk;
    logic       rstn;

    logic       mode;
    logic       rd_bus;
    logic       wr_bus;
    logic       ack;
    logic       master_valid;
    logic       slave_ready;
    logic       master_ready;
    logic       slave_valid;
    logic       breq;
    logic       bgrant;
    logic       split;

    logic[7:0]  m_wr_data;
    logic[7:0]  m_rd_data;
    logic[15:0] m_addr;
    logic       m_mode;
    logic       m_out_valid;
    logic       m_in_valid;

    bb_master_port mp (.*);

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
        m_addr      = 16'habcd;
        m_mode      = 1;
        m_in_valid     = 1;
        slave_ready = 0;
        ack         = 0;
        bgrant      = 1;
        split       = 1;

        @(negedge clk);
        m_in_valid     = 0;
        ack         = 1;

        #800;

        slave_ready = 1;
        #1000;

        @(negedge clk);
        m_mode      = 0;
        m_in_valid     = 1;
        slave_valid = 0;
        rd_bus      = 1;

        @(negedge clk);
        m_in_valid     = 0;
        rd_bus      = 0;

        #400;
        split       = 0;
        slave_valid = 1;

        @(negedge clk);
        rd_bus      = 1;

        @(negedge clk);
        rd_bus      = 1;

        @(negedge clk);
        rd_bus      = 0;

        @(negedge clk);
        rd_bus      = 1;

        #1000;

        $finish;
    end
endmodule