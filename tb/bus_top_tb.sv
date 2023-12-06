`timescale 1ps/1ps

module bus_top_tb;

    logic       clk;
    logic[3:0]  keysn;
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
    logic[6:0]  hex0;
    logic[6:0]  hex1;
    logic[6:0]  hex2;
    logic[6:0]  hex3;
    logic       sig_tx;
    logic       ready_tx;
    logic       sig_rx;
    logic       ready_rx;

    top tp(.*);

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        keysn = 4'b1111;

        #100;

        keysn[3] = 0;
        #20;
        keysn[3]        = 1;
        #40;



        
        addr        = {4'b0001, 12'hA8};
        keysn[1] = 0;
        #50;
        keysn[1] = 1;
        #50;

        // keysn[1] = 0;
        // #50;
        // keysn[1] = 1;
        // #50;

        keysn[0] = 0;
        #50;
        keysn[0] = 1;
        #50;

        // keysn[0] = 0;
        // #50;
        // keysn[0] = 1;
        // #50;


        keysn[2] = 0;
        #50;
        keysn[2] = 1;
        #50;



        #5000;

        $finish;






    end
endmodule