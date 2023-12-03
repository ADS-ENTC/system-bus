`timescale 1ns/1ns

module arbiter_master_select_tb;
    logic BREQ1, BREQ2, rstn, clk;
    logic BGRANT1, BGRANT2;

    arbiter_master_select dut (.*);

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rstn = 1;

        @(posedge clk);
        #1;
        BREQ1 = 1;
        BREQ2 = 0;
        #50;
        assert (BGRANT1 == 1 && BGRANT2 == 0) 
            $display("Test passed!");
        else    
            $error("(BREQ1 = %d, BREQ2 = %d) Test failed!", BREQ1, BREQ2);

        @(posedge clk);
        #1;
        BREQ1 = 0;
        BREQ2 = 1;
        #50;
        assert (BGRANT1 == 0 && BGRANT2 == 1) 
            $display("Test passed!");
        else    
            $error("(BREQ1 = %d, BREQ2 = %d) Test failed!", BREQ1, BREQ2);

        
        @(posedge clk);
        #1;
        BREQ1 = 1;
        BREQ2 = 1;
        #50;
        assert (BGRANT1 == 0 && BGRANT2 == 1) 
            $display("Test passed!");
        else    
            $error("(BREQ1 = %d, BREQ2 = %d) Test failed!", BREQ1, BREQ2);
        
        @(posedge clk);
        #1;
        BREQ1 = 0;
        BREQ2 = 0;
        #50;
        assert (BGRANT1 == 0 && BGRANT2 == 0) 
            $display("Test passed!");
        else    
            $error("(BREQ1 = %d, BREQ2 = %d) Test failed!", BREQ1, BREQ2);
    
        @(posedge clk);
        #1;
        BREQ1 = 1;
        BREQ2 = 1;
        #50;
        assert (BGRANT1 == 1 && BGRANT2 == 0) 
            $display("Test passed!");
        else    
            $error("(BREQ1 = %d, BREQ2 = %d) Test failed!", BREQ1, BREQ2);
    end

endmodule