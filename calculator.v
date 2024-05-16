module calculator(
	// I/O declare
	input CLK, clrEn, clrAll,
	// clrAll =  Key0
	// clrEn = Key 1 
	
	input [3:0]ROW, 
	output [3:0]COL,
	output [0:6]HEX2,
	output [0:6]HEX1,
	output [0:6]HEX0,
	output [3:0]Ccout,
	
	
	output HEX3 // HEX3[6]
	//output [0:6]HEX4, HEX5

);

	// wire and reg
	wire trig,  iuau, loadA, loadB, AddSub, loadR, reset;
	wire [3:0]value;
	wire [7:0]x;
	reg [2:0] state;
	
	
	// input 
	wire clk;
	wire [7:0]blueOut;
	
	// AU 
	//wire [3:0]Ccout;
	wire [7:0]Rout;
	// Zero and overflow // Zero = LEDR[8] A11 , OVR = LEDR[9] B11 
	
	assign x = iuau?Rout:blueOut;
	
	

// control unit 

ControlUnit ControlUnit_inst
(
	.trig(trig) ,	// input  trig_sig
	.clock(CLK) ,	// input  clock_sig
	.clrAll(clrAll) ,	// input  clrAll_sig
	.value(value) ,	// input [3:0] value_sig
	.reset(reset) ,	// output  reset_sig
	.IUAU(iuau) ,	// output  IUAU_sig
	.loadA(loadA) ,	// output  loadA_sig
	.loadB(loadB) ,	// output  loadB_sig
	.AddSub(AddSub) ,	// output  AddSub_sig
	.loadR(loadR) ,	// output  loadR_sig
	//.led(led)
);

defparam ControlUnit_inst.S0 = 'b000;
defparam ControlUnit_inst.S1 = 'b001;
defparam ControlUnit_inst.S2 = 'b010;
defparam ControlUnit_inst.S3 = 'b011;
defparam ControlUnit_inst.S4 = 'b100;

// input 

InputUnit InputUnit_inst
(
	.CLK(CLK) ,	// input  CLK_sig
	.RESET(reset && clrEn) ,	// input  RESET_sig
	.ROW(ROW) ,	// input [3:0] ROW_sig
	.COL(COL) ,	// output [3:0] COL_sig
	.OUT(blueOut),	// output [7:0] OUT_sig
	.value(value),
	.trig(trig)
);

// AU

AU8 AU8_inst
(
	.X(blueOut) ,	// input [7:0] X_sig
	.InA(~loadA) ,	// input  InA_sig
	.InB(~loadB) ,	// input  InB_sig
	.Out(~loadR) ,	// input  Out_sig
	.Clear(reset) ,	// input  Clear_sig
	.Add_Subtract(AddSub) ,	// input  Add_Subtract_sig
	.Rout(Rout) ,	// output [7:0] Rout_sig
	.Ccout(Ccout) ,	// output [3:0] Ccout_sig
	//.HEX1(HEX4),
	//.HEX2(HEX5)

);

// OU 

OutputUnit OutputUnit_inst
(
	.INPUT(x) ,	// input [7:0] INPUT_sig
	.HEX0(HEX0) ,	// output [0:6] HEX0_sig
	.HEX1(HEX1) ,	// output [0:6] HEX1_sig
	.HEX2(HEX2) ,	// output [0:6] HEX2_sig
	.HEX3(HEX3) 	// output  HEX3_sig
);

endmodule
