
module demo (
    input logic clk,       
    input logic [3:0] keysn,
    input logic [17:0] sws,
    output logic [6:0] hex0,
    output logic [6:0] hex1,
    output logic [6:0] hex2,
    output logic m1,
    output logic m2
);
  // Module implementation goes here
logic [3:0] tmp;
logic [3:0] keys;
assign keys = ~keysn;
seg seg0(.bcd(keys), .hex(hex0));
seg seg1(.bcd(keys), .hex(hex1));
seg seg2(.bcd(tmp), .hex(hex2));

always @(sws)
begin
    tmp=sws%10;    
end
  
endmodule
