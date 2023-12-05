module top(
    input   logic       clk,
    input   logic       rstn,
    input   logic       m1_mode_in,
    input   logic       m1_start,
    input   logic[15:0] m1_addr,
    output  logic       rstn_led,
    output  logic       m1_ack_led,
    output  logic       m1_master_ready_led,
    output  logic       m1_slave_valid_led,
    output  logic       m1_slave_ready_led,
    output  logic       m1_master_valid_led,
    output  logic       s1_master_ready_led,
    output  logic       s1_slave_valid_led,
    output  logic       s1_slave_ready_led,
    output  logic       s1_master_valid_led
);  

    assign rstn_led = rstn;
    assign m1_ack_led = m1_ack;
    assign m1_master_ready_led = m1_master_ready;
    assign m1_slave_valid_led = m1_slave_valid;
    assign m1_slave_ready_led = m1_slave_ready;
    assign m1_master_valid_led = m1_master_valid;
    assign s1_master_ready_led = s1_master_ready;
    assign s1_slave_valid_led = s1_slave_valid;
    assign s1_slave_ready_led = s1_slave_ready;
    assign s1_master_valid_led = s1_master_valid;

    // master 1;
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

    logic[7:0]  m1_wr_data;
    logic[7:0]  m1_rd_data;
    logic       m1_wr_en;

    //master 2;
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

    logic[7:0]  m2_wr_data;
    logic[7:0]  m2_rd_data;
    logic       m2_wr_en;

    // slave 1;
    logic       s1_mode;
    logic       s1_wr_bus;
    logic       s1_master_valid;
    logic       s1_master_ready;
    logic       s1_rd_bus;
    logic       s1_slave_ready;
    logic       s1_slave_valid;

    // slave 2;
    logic       s2_mode;
    logic       s2_wr_bus;
    logic       s2_master_valid;
    logic       s2_master_ready;
    logic       s2_rd_bus;
    logic       s2_slave_ready;
    logic       s2_slave_valid;
    logic       slave_split;

    // slave 3;
    logic       s3_mode;
    logic       s3_wr_bus;
    logic       s3_master_valid;
    logic       s3_master_ready;
    logic       s3_rd_bus;
    logic       s3_slave_ready;
    logic       s3_slave_valid;

    // bus bridge
    logic       bb_mode;
    logic       bb_wr_bus;
    logic       bb_master_valid;
    logic       bb_master_ready;
    logic       bb_rd_bus;
    logic       bb_slave_ready;
    logic       bb_slave_valid;

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
        .breq(m1_breq),
        .bgrant(m1_bgrant),
        .split(m1_split),
        .m_wr_data(m1_wr_data),
        .m_rd_data(m1_rd_data),
        .m_addr(m1_addr),
        .m_mode(m1_mode_in),
        .m_wr_en(m1_wr_en),
        .m_start(~m1_start)
    );

    slave_port_v2 #(
        .ADDR_WIDTH(11),
        .DATA_WIDTH(8)
    ) sp_1 (
        .clk(clk),
        .rstn(rstn),
        .mode(s1_mode),
        .wr_bus(s1_wr_bus),
        .master_valid(s1_master_valid),
        .master_ready(s1_master_ready),
        .rd_bus(s1_rd_bus),
        .slave_ready(s1_slave_ready),
        .slave_valid(s1_slave_valid),
    );

    master_1_ram m1_ram (
        .address(m1_addr[4:0]),
        .clock(clk),
        .data(m1_rd_data),
        .wren(m1_wr_en),
        .q(m1_wr_data)
    );

    arbiter arb(.*);


endmodule