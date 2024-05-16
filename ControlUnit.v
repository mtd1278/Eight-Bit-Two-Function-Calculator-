// Lab 12 Control Unit
module ControlUnit
(
	input trig, clock, clrEn, clrAll,
	input [3:0]value,
	output [2:0]led,
	output reg reset, IUAU,
	output reg loadA,loadB, AddSub,loadR
	
	
);
	reg[2:0] state, nextstate;
	parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100;
	//assign led = state;
//wire slowClk;
/*divideXn #(2500000,32) clock_div_inst
	(
	.CLOCK(clock), 
	.CLEAR(clrEn & clrAll),// COUNT is defined as a M-bit register
	.OUT(slowClk)
	);
	
EdgeDetect Edge
(
	.in(trig),
	.clock(slowClk),
	.out(next)
);*/

// out = ~in & in_delay

	always @ (negedge clock, negedge clrAll)
		if (clrAll == 0) state <= S0;
			else
				state <= nextstate;
	//always @ (negedge clrEn)
		//if (clrEn == 0) 
	always @ (state, value) 
		case (state)
		S0: 
		begin
			nextstate <= S1;
			reset <= 0;
			loadA <= 1;
			loadB <= 1;
			loadR <= 1;
			IUAU <= 0;
			AddSub <= 0;
		end
		S1: begin
		reset <= 1;
			loadA <= 1;
			loadB <= 1;
			loadR <= 1;
			IUAU <= 0;
			if (value == 4'hA) begin AddSub = 0; nextstate <= S2;end 
			else if(value == 4'hB) begin AddSub = 1; nextstate <= S2;end
			else nextstate <= S1;
			
			end
		S2: 
		begin
			if (value == 4'hF) nextstate <= S3; else nextstate <= S2;
			
			reset <= 1;
			loadA <= 0;
			loadB <= 1;
			loadR <= 1;
			IUAU <= 0;
		end
		S3: begin
			nextstate <= S4;
			reset <= 1;
			loadA <= 1;
			loadB <= 0;
			loadR <= 1;
			IUAU <= 0;
			end
		S4: 
		begin
			nextstate <= S4;
			reset <= 1;
			loadA <= 1;
			loadB <= 1;
			loadR <= 0;
			IUAU <= 1;
		end
		endcase
endmodule
			