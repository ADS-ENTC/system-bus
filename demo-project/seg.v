module seg(bcd,hex);
input [3:0] bcd;
output [6:0] hex;
reg [6:0] hex;

always @ (bcd)
begin
	case (bcd)
	0:hex=7'B1000000;
	1:hex=7'B1111001;
	2:hex=7'B0100100;
	3:hex=7'B0110000;
	4:hex=7'B0011001;
	5:hex=7'B0010010;
	6:hex=7'B0000010;
	7:hex=7'B1111000;
	8:hex=7'B0000000;
	9:hex=7'B0010000;
	10:hex=7'B0111101;
	11:hex=7'B0111011;
	12:hex=7'B0111111;
	default:hex=7'B1000000;
	endcase
end
endmodule