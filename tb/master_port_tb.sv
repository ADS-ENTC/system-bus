`timescale 1ps/1ps

module master_port_tb;
    logic       rstn;
    logic       clk;

    logic       mp_breq;
    logic       mp_bgnt;
    logic       mp_addr;
    logic       mp_wdata;
    logic       mp_ready;
    logic       mp_valid;

    logic[7:0]  m_data;
    logic[15:0] m_addr;
    logic       m_valid;
    logic       m_ready;

    master_port mp (.*);

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rstn        = 1;
        m_addr      = 0;
        m_data      = 0;
        m_valid     = 0;
        mp_ready    = 0;
        mp_bgnt     = 0;

        #10 rstn = 0;
        #10 rstn = 1;
        #10;

        m_valid = 1;
        m_addr  = 16'h1234;
        m_data  = 8'h75;
        mp_bgnt = 1;
        mp_ready = 1;

        #200;

        $finish;
    end
endmodule