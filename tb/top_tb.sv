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

        repeat (100) begin

            @(negedge clk);
            #1;
            m_wr_data   = $random;
            m_addr      = $random;
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

            while (!m_wr_en) begin
                @(negedge clk);
            end

            assert (m_wr_data == m_rd_data) 
                $display("Test passed! addr = %h, data = %h", m_addr, m_rd_data);
            else 
                $error("Test failed!. expected %h, got %h", m_wr_data, m_rd_data);
        end
        $finish;
    end


endmodule