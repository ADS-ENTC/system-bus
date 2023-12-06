
module demo (
    input logic clk,        
    input logic [3:0] keysn,
    output logic [6:0] hex0,
    output logic [6:0] hex1,
    output logic [6:0] hex2,
    output logic [6:0] hex3,
    output logic m1_start,
    output logic m1_mode_in,
    output logic m2_start,
    output logic m2_mode_in
);
  // Module implementation goes here
logic [3:0] tmp;

logic [3:0] m2_seg_state_bcd;
logic [3:0] m2_seg_label_bcd;
logic [3:0] m1_seg_state_bcd;
logic [3:0] m1_seg_label_bcd;

wire rstn = keysn[3];

wire [3:0] keys = ~keysn;
wire start=keys[2];
wire m1_key = keys[1];
wire m2_key = keys[0];

enum logic[3:0] {READ=4'd10,WRITE=4'd11,DISABLE=4'd12} m1_state, m2_state;
 
seg m2_seg_state(.bcd(m2_state), .hex(hex0));
seg m2_seg_label(.bcd(4'b0010), .hex(hex1));
seg m1_seg_state(.bcd(m1_state), .hex(hex2));
seg m1_seg_label(.bcd(4'b0001), .hex(hex3));

always_comb begin : OUTPUT_LOGIC
    m1_mode_in = (m1_state == WRITE) ? 1'b1 : 1'b0;
    m2_mode_in = (m2_state == WRITE) ? 1'b1 : 1'b0;
end

always_ff @(posedge m1_key or negedge rstn) begin
    if (~rstn) begin
        m1_state <= DISABLE;
    end
    else begin
        case (m1_state)
            DISABLE:m1_state <= READ;
            READ:m1_state <= WRITE;
            WRITE: m1_state <= DISABLE;
            default: m1_state <= DISABLE;
        endcase
    end    
end

always_ff @(posedge m2_key or negedge rstn) begin
    if (~rstn) begin
        m2_state <= DISABLE;
    end
    else begin
        case (m2_state)
            DISABLE:m2_state <= READ;
            READ:m2_state <= WRITE;
            WRITE: m2_state <= DISABLE;
            default: m2_state <= DISABLE;
        endcase
    end    
end

logic one_clk_flag=1'b1;

always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        m1_start <= 1'b0;
        m2_start <= 1'b0;
        one_clk_flag <= 1'b1;
    end
    else begin
        if (start & one_clk_flag) begin          
            if (m1_state != DISABLE) begin
                m1_start <= 1'b1;
            end
            if (m2_state != DISABLE) begin
                m2_start <= 1'b1;
            end
            one_clk_flag <= 1'b0;
        end
        else begin
            m1_start <= 1'b0;
            m2_start <= 1'b0;
        end

        if (~start) begin
            one_clk_flag <= 1'b1;
        end
    end
end
  
endmodule
