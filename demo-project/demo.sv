
module demo (
    input logic clk,       
    input logic [3:0] keys,
    input logic [17:0] sws,
    output logic [6:0] hex0,
    output logic [6:0] hex1,
    output logic [6:0] hex2,
    output logic m1,
    output logic m2
);
  // Module implementation goes here
seg seg0(.bcd(keys), .hex(hex0));


  
endmodule
