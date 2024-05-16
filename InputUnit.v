module InputUnit (
	input CLK, RESET, 
	input [3:0]ROW, 
	output [3:0]COL,
	output [3:0]value,
	output trig,
	output reg [7:0] OUT
);
	wire [15:0]out;
	wire [7:0]SMout;
	
	

keypad_input keypad_input_inst
(
	.clk(CLK) ,	// input  clk_sig
	.reset(RESET) ,	// input  reset_sig
	.row(ROW) ,	// input [3:0] row_sig
	.col(COL) ,	// output [3:0] col_sig
	.out(out) ,	// output [DIGITS*4-1:0] out_sig
	.value(value),
	.trig(trig)
);

BCD2BinarySM BCD2BinarySM_inst
(
	.BCD(out) ,	// input [15:0] BCD_sig
	.binarySM(SMout) 	// output [N-1:0] binarySM_sig
);

wire [7:0] lastOut;
twoSIGN #(8) twosign
(
	.A(SMout),
	.B(lastOut)
);

always @(*)
	begin
		if(SMout[7] == 1) 
			OUT = ~{1'b0, SMout[6:0]} + 1;
		else
			OUT = lastOut;
	end

endmodule
