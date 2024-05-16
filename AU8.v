//Verilog Model of an 8-bit registered 2-function AU
module AU8 (
	input [7:0] X, //declare data inputs
	input InA, InB, Out, Clear, Add_Subtract, //declare control inputs
	output [7:0] Rout, //declare result output
	output [3:0] Ccout, //declare condition code output
	output [0:6] HEX2, HEX1, HEX0); //declare seven-segment outputs
	
	//Declare internal nodes
	wire [7:0] Aout, Bout, R; //declare register outputs
	wire Cout, OV, ZERO, NEG, C7; //declare condition codes

//Make internal node assignments
	assign ZERO = ~(R[7]|R[6]|R[5]|R[4]|R[3]|R[2]|R[1]|R[0]);
	assign OV = Cout ^ C7;
	assign NEG = R[7]; 
	

//Instantiate registers
NBitRegister #(4'd8) regA (
	.D(X), // input
	.CLK(InA), // load
	.CLR(Clear), // clear
	.Q(Aout) //output 
);

NBitRegister #(4'd8) regB (
	.D(X), 
	.CLK(InB), 
	.CLR(Clear),
	.Q(Bout)
);

NBitRegister #(3'd4) regCC (
	.D({OV,NEG,Cout,ZERO}), 
	.CLK(Out),
	.CLR(Clear), 
	.Q(Ccout) 
);

NBitRegister #(4'd8) regR(
	.D(R), 
	.CLK(Out), 
	.CLR(Clear),
	.Q(Rout)
);

//Instantiate full adders
RCAStructural RCA ( //name the module
	.A(Aout),
	.B(Bout),
	.add_subtract(Add_Subtract), //declare input ports
	.S(R), //declare output ports for sum
	.Cout(Cout),
	.C7(C7)
); 

//Instantiate bin2sev decoders
Fourto7 binary2seven_seconds_high_display
(
	.W(Rout[7:4]),
	.Y(HEX1)
);
Fourto7 binary2seven_seconds_low_display
(
	.W(Rout[3:0]),
	.Y(HEX0)
);
Fourto7 lala(
	.W(Ccout),
	.Y(HEX2)
);

endmodule
