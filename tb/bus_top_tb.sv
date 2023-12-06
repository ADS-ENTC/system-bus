`timescale 1ps/1ps

module bus_top_tb;
    logic       clk;
    logic       rstn;
    logic       m1_mode_in;
    logic       m1_start;
    logic       m2_mode_in;
    logic       m2_start;
    logic[15:0] addr;
    logic       rstn_led;
    logic       m1_ack_led;
    logic       m1_master_ready_led;
    logic       m1_slave_valid_led;
    logic       m1_slave_ready_led;
    logic       m1_master_valid_led;
    logic       s1_master_ready_led;
    logic       s1_slave_valid_led;
    logic       s1_slave_ready_led;
    logic       s1_master_valid_led;
    logic       m1_mode_led;
    logic       m2_mode_led;

    top tp(.*);

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpvars(0, bus_top_tb);
        rstn        = 0;
        #20;
        rstn        = 1;
        #20;

        
        addr      = {4'b0001, 12'hA8};
        m1_mode_in      = 0;
        m1_start     = 0;
        m2_mode_in      = 0;
        m2_start     = 1;


        #5000;

        m1_start     = 1;

        $finish;






    end
endmodule