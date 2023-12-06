module top(
    input   logic       clk,
    input   logic[3:0]  keysn,
    input   logic[15:0] addr,
    output  logic       rstn_led,
    output  logic       m1_ack_led,
    output  logic       m1_master_ready_led,
    output  logic       m1_slave_valid_led,
    output  logic       m1_slave_ready_led,
    output  logic       m1_master_valid_led,
    output  logic       s1_master_ready_led,
    output  logic       s1_slave_valid_led,
    output  logic       s1_slave_ready_led,
    output  logic       s1_master_valid_led,
    output  logic       m1_mode_led,
    output  logic       m2_mode_led,
    output  logic[6:0]  hex0,
    output  logic[6:0]  hex1,
    output  logic[6:0]  hex2,
    output  logic[6:0]  hex3
);  

    // wires
    logic       rstn;

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
    logic       m1_start;
    logic       m1_mode_in;

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
    logic       m2_start;
    logic       m2_mode_in;

    // slave 1;
    logic       s1_mode;
    logic       s1_wr_bus;
    logic       s1_master_valid;
    logic       s1_master_ready;
    logic       s1_rd_bus;
    logic       s1_slave_ready;
    logic       s1_slave_valid;

    logic[7:0]  s1_ram_in;
    logic[7:0]  s1_ram_out;
    logic[10:0] s1_ram_addr_out;
    logic       s1_ram_wr_en;

    // slave 2;
    logic       s2_mode;
    logic       s2_wr_bus;
    logic       s2_master_valid;
    logic       s2_master_ready;
    logic       s2_rd_bus;
    logic       s2_slave_ready;
    logic       s2_slave_valid;
    logic       slave_split;

    logic[7:0]  s2_ram_in;
    logic[7:0]  s2_ram_out;
    logic[11:0] s2_ram_addr_out;
    logic       s2_ram_wr_en;

    // slave 3;
    logic       s3_mode;
    logic       s3_wr_bus;
    logic       s3_master_valid;
    logic       s3_master_ready;
    logic       s3_rd_bus;
    logic       s3_slave_ready;
    logic       s3_slave_valid;

    logic[7:0]  s3_ram_in;
    logic[7:0]  s3_ram_out;
    logic[11:0] s3_ram_addr_out;
    logic       s3_ram_wr_en;

    // bus bridge
    logic       bb_mode;
    logic       bb_wr_bus;
    logic       bb_master_valid;
    logic       bb_master_ready;
    logic       bb_rd_bus;
    logic       bb_slave_ready;
    logic       bb_slave_valid;

    assign rstn_led = rstn;
    assign m1_ack_led = m1_ack;
    assign m1_master_ready_led = m1_master_ready;
    assign m1_slave_valid_led = m1_slave_valid;
    assign m1_slave_ready_led = m1_slave_ready;
    assign m1_master_valid_led = m1_master_valid;
    assign s1_master_ready_led = s2_master_ready;
    assign s1_slave_valid_led = s2_slave_valid;
    assign s1_slave_ready_led = s2_slave_ready;
    assign s1_master_valid_led = s2_master_valid;
    assign m1_mode_led = m1_mode_in;
    assign m2_mode_led = m2_mode_in;

    assign rstn = keysn[3];

    demo intf (.*);

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
        .m_addr(addr),
        .m_mode(m1_mode_in),
        .m_wr_en(m1_wr_en),
        .m_start(m1_start)
    );

    master_port mp_2 (
        .clk(clk),
        .rstn(rstn),
        .mode(m2_mode),
        .rd_bus(m2_rd_bus),
        .wr_bus(m2_wr_bus),
        .ack(m2_ack),
        .master_valid(m2_master_valid),
        .slave_ready(m2_slave_ready),
        .master_ready(m2_master_ready),
        .slave_valid(m2_slave_valid),
        .breq(m2_breq),
        .bgrant(m2_bgrant),
        .split(m2_split),
        .m_wr_data(m2_wr_data),
        .m_rd_data(m2_rd_data),
        .m_addr(addr),
        .m_mode(m2_mode_in),
        .m_wr_en(m2_wr_en),
        .m_start(m2_start)
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
        .ram_in(s1_ram_in),
        .ram_out(s1_ram_out),
        .ram_addr_out(s1_ram_addr_out),
        .ram_wr_en(s1_ram_wr_en)
    );

    slave_port_v2 #(
        .ADDR_WIDTH(12),
        .DATA_WIDTH(8),
        .SPLIT_EN(1)
    ) sp_2 (
        .clk(clk),
        .rstn(rstn),
        .mode(s2_mode),
        .wr_bus(s2_wr_bus),
        .master_valid(s2_master_valid),
        .master_ready(s2_master_ready),
        .rd_bus(s2_rd_bus),
        .slave_ready(s2_slave_ready),
        .slave_valid(s2_slave_valid),
        .split(slave_split),
        .ram_in(s2_ram_in),
        .ram_out(s2_ram_out),
        .ram_addr_out(s2_ram_addr_out),
        .ram_wr_en(s2_ram_wr_en)
    );

    slave_port_v2 #(
        .ADDR_WIDTH(12),
        .DATA_WIDTH(8)
    ) sp_3 (
        .clk(clk),
        .rstn(rstn),
        .mode(s3_mode),
        .wr_bus(s3_wr_bus),
        .master_valid(s3_master_valid),
        .master_ready(s3_master_ready),
        .rd_bus(s3_rd_bus),
        .slave_ready(s3_slave_ready),
        .slave_valid(s3_slave_valid),
        .ram_in(s3_ram_in),
        .ram_out(s3_ram_out),
        .ram_addr_out(s3_ram_addr_out),
        .ram_wr_en(s3_ram_wr_en)
    );

    master_1_ram m1_ram (
        .address(addr[4:0]),
        .clock(clk),
        .data(m1_rd_data),
        .wren(m1_wr_en),
        .q(m1_wr_data)
    );

    master_2_ram m2_ram (
        .address(addr[4:0]),
        .clock(clk),
        .data(m2_rd_data),
        .wren(m2_wr_en),
        .q(m2_wr_data)
    );

    slave_1_ram s1_ram (
        .address(s1_ram_addr_out),
        .clock(clk),
        .data(s1_ram_out),
        .wren(s1_ram_wr_en),
	    .q(s1_ram_in)
    );

    slave_2_ram s2_ram (
        .address(s2_ram_addr_out),
        .clock(clk),
        .data(s2_ram_out),
        .wren(s2_ram_wr_en),
        .q(s2_ram_in)
    );

    slave_3_ram s3_ram (
        .address(s3_ram_addr_out),
        .clock(clk),
        .data(s3_ram_out),
        .wren(s3_ram_wr_en),
        .q(s3_ram_in)
    );

    arbiter arb(.*);


endmodule