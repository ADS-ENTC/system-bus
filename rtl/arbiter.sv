`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.10.2023 09:01:46
// Design Name: 
// Module Name: arbiter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module arbiter #(
    parameter MASTER_COUNT_W=1,
    parameter SLAVE_COUNT_W=4
)(
    // bus connections
    input logic clk, reset_n,

    // master connections
    input logic 
    m_addr[MASTER_COUNT_W-1:0],
    [1:0] m_trans[MASTER_COUNT_W-1:0], 
    m_wdata[MASTER_COUNT_W-1:0], 
    m_write[MASTER_COUNT_W-1:0],
    m_breq[MASTER_COUNT_W-1:0],

    output logic
    m_rdata[MASTER_COUNT_W-1:0],
    [1:0] m_resp[MASTER_COUNT_W-1:0],
    m_ready[MASTER_COUNT_W-1:0],
    m_grant[MASTER_COUNT_W-1:0],

    //slave connections
    input logic
    s_addr[SLAVE_COUNT_W-1:0],
    s_rdata[SLAVE_COUNT_W-1:0],
    s_resp[SLAVE_COUNT_W-1:0],
    s_ready[SLAVE_COUNT_W-1:0],

    output logic
    [1:0] s_trans[SLAVE_COUNT_W-1:0],// not sure
    s_wdata[SLAVE_COUNT_W-1:0],
    s_write[SLAVE_COUNT_W-1:0],
    s_select[SLAVE_COUNT_W-1:0]

    );

    localparam MASTER_COUNT=1<<MASTER_COUNT_W;

    enum logic [1:0] {IDLE,TRNS_ADDR,TRNS_DATA} state;
    logic curr_master,curr_slave;
    logic [SLAVE_COUNT_W-1:0] slave_addr;
    logic [$clog2(SLAVE_COUNT_W)-1:0] slave_addr_bit;

    always_ff @( posedge clk or negedge reset_n ) begin : STATE_CHANGIN
        if(!reset_n) begin
            state <=IDLE;
        end else begin
            unique case (state)
                IDLE: begin
                    for ( int i=0 ;i<MASTER_COUNT;i++ ) begin
                        if (m_breq[i]) begin
                            curr_master <= i;
                            state <= TRNS_ADDR;
                            m_grant[i] <= 1;                             
                            slave_addr_bit <= SLAVE_COUNT_W-1;
                            break;
                        end
                    end
                end
                TRNS_ADDR: begin
                    slave_addr[slave_addr_bit] <= m_addr[curr_master];
                    if(slave_addr_bit==0) begin
                        state<=TRNS_DATA;
                    end
                    slave_addr_bit <= slave_addr_bit -1;
                end                
                default: 
            endcase 
        end
    end

    
    always_comb begin
        if (state==TRNS_DATA) begin
            s_wdata[slave_addr] = m_wdata[curr_master];
            s_rdata[slave_addr] = m_rdata[curr_master];
        end
    end    
endmodule
