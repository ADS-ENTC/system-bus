
module demo (
    input logic clk,
    input logic rstn,      
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

logic [3:0] seg0_bcd;
logic [3:0] seg1_bcd;
logic [3:0] seg2_bcd;

wire m1_select=sws[0];
wire m1_mode=sws[1];
wire m2_select=sws[2];
wire m2_mode=sws[3];
wire keys = ~keysn;
wire [15:0] addr={sws[16:4],4'b0000};

// logic m1_select=sws[0];
// logic m1_mode=sws[1];
// logic m2_select=sws[2];
// logic m2_mode=sws[3];
// logic keys = ~keysn;
// logic [15:0] addr={sws[16:4],4'b0000};

seg seg0(.bcd(seg0_bcd), .hex(hex0));
seg seg1(.bcd(seg1_bcd), .hex(hex1));
seg seg2(.bcd(seg2_bcd), .hex(hex2));

always_comb
begin    
    if(m1_select) begin
        seg0_bcd=4'b0001;
    end else begin
        seg0_bcd=4'b0010;
    end
    if(m2_select) begin
        seg1_bcd=4'b0010;
    end else begin
        seg1_bcd=4'b0001;
    end
    seg2_bcd=addr[15];
end


  
endmodule
