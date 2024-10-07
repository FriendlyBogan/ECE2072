module inst_proc(LEDR, SW, HEX5, KEY); 

	input [8:0]SW;
	input [1:0]KEY;
	output [9:0] LEDR;
	output [6:0]HEX5;
	
	
	simple_proc inst(.clk(~KEY[1]), .rst(~KEY[0]), .din(SW[8:0]), .bus(LEDR[9:0]), .R0(), .R1(), .R2(),.R3(), .R4(), .R5(), .R6(), .R7(),.IR_out());
	
endmodule 



