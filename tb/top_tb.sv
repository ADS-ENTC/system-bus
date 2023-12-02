module top_tb;
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
    slave_port_v2 sp(.*);

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
        #1;
        m_wr_data   = 8'h5A;
        m_addr      = 16'hF234;
        m_mode      = 1;
        m_start     = 1;

        @(negedge clk);
        #1;
        m_start     = 0;

        #400;


        @(negedge clk);
        #1;
        m_mode      = 0;
        m_start     = 1;

        @(negedge clk);
        #1;
        m_start     = 0;


        #400;

        $finish;
    end


endmodule