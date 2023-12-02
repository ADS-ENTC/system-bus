`timescale 1ps/1ps

module master_port_tb;
    logic       clk;
    logic       rstn;

    logic       mode;
    logic       rd_bus;
    logic       wr_bus;
    logic       master_valid;
    logic       slave_ready;
    logic       master_ready;
    logic       slave_valid;

    logic[7:0]  m_wr_data;
    logic[7:0]  m_rd_data;
    logic[15:0] m_addr;
    logic       m_mode;
    logic       m_wr_en;
    logic       m_start;

    master_port mp (.*);



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
        m_start     = 1;
        slave_ready = 1;

        @(negedge clk);
        m_start     = 0;

        #400;


        @(negedge clk);
        m_mode      = 0;
        m_start     = 1;
        slave_valid = 1;
        rd_bus      = 1;

        @(negedge clk);
        m_start     = 0;
        rd_bus      = 0;


        
        #200;

        @(negedge clk);
        rd_bus      = 1;

        @(negedge clk);
        rd_bus      = 1;

        @(negedge clk);
        rd_bus      = 0;

        @(negedge clk);
        rd_bus      = 1;

        #400;

        $finish;
    end
endmodule