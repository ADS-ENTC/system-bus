
module demo (
    input logic clk,        
    input logic [3:0] keysn,
    input logic [17:0] sws,
    output logic [6:0] hex0,
    output logic [6:0] hex1,
    output logic [6:0] hex2,
    output logic [6:0] hex3,
    output logic m1_start,
    output logic m2_start
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

wire [15:0] addr={sws[15:4],4'b0010};

enum logic[3:0] {READ=4'd10,WRITE=4'd11,DISABLE=4'd12} m1_state, m2_state;
 
seg m2_seg_state(.bcd(m2_state), .hex(hex0));
seg m2_seg_label(.bcd(4'b0010), .hex(hex1));
seg m1_seg_state(.bcd(m1_state), .hex(hex2));
seg m1_seg_label(.bcd(4'b0001), .hex(hex3));


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
  
endmodule
