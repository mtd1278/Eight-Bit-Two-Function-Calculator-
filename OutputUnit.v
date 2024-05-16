// top level output unit

module OutputUnit
(
	input [7:0] INPUT,
	output [0:6] HEX0, HEX1, HEX2,
	output HEX3
);

	wire [7:0] SIGN;
	wire [3:0] ONES_sig;
	wire [3:0] TENS_sig;
	wire [1:0] HUNDREDS_sig;
	
	assign HEX3 = ~INPUT[7];
	
// two's complement to signed magnitude 

twoSIGN #(8) twoSIGN_inst
(
	.A(INPUT) ,	// input [N-1:0] A_sig
	.B(SIGN) 	// output [N-1:0] B_sig
);


// signed magnitude (binary) to BCD

binary2bcd binary2bcd_inst
(
	.A(SIGN) ,	// input [7:0] A_sig
	.ONES(ONES_sig) ,	// output [3:0] ONES_sig
	.TENS(TENS_sig) ,	// output [3:0] TENS_sig
	.HUNDREDS(HUNDREDS_sig) 	// output [1:0] HUNDREDS_sig
);

// BCD to 7-segment 



Fourto7 hundreds
(
	.W(HUNDREDS_sig),
	.Y(HEX2)
);

Fourto7 tens
(
	.W(TENS_sig),
	.Y(HEX1)
);

Fourto7 ones
(
	.W(ONES_sig),
	.Y(HEX0)
);

endmodule
