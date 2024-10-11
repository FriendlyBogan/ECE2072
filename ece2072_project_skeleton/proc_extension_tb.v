`timescale 1ns/1ns
/*
Monash University ECE2072: Assignment 
This file contains a Verilog test bench to test the correctness of the processor.

Please enter your student ID:

*/
module proc_extension_tb;
    // TODO: Implement the logic of your testbench here
	 
	 reg clk, rst;
	 

	
	 reg [8:0] din;
	 wire [15:0] display;
     wire [3:0]tick;
	 wire [15:0] bus, R0, R1, R2, R3, R4, R5, R6, R7;
	 integer error;
	 proc_extension uut(.clk(clk), .rst(rst), .din(din), .bus(bus), .R0(R0), .R1(R1),.R2(R2), .R3(R3), .R4(R4), .R5(R5), .R6(R6), .R7(R7),.tick(tick) ,.display(display));
	 
	always #5 clk = ~clk;
	
	initial begin 
	clk = 0;
	error = 0;
	//test for addi 
	#7
	din = 9'b010001000; //R1
	rst = 0;
	#10
	din = 9'd255;
	#30

	if (R1!= 255) begin 
		
		error = error + 1;
	end
	din = 9'b010001000; //R1
	#10
	din = 9'd89;
	#30
	
	if (R1 != 344) begin 
	
		error = error + 1;
	end 
	

	din = 9'b010001000; //R1
	#10
	din = 9'd2;
	#30
	
	if (R1 != 346) begin 
		error = error + 1;
	end 

	// TEST MOVI

	din = 9'b111010000; //r2
	#10
	din = 9'd34;
	#30
	
	if (R2 != 34) begin 
		
		error = error + 1;
	end 
	
	
	// TEST add;

	din = 9'b001001010; //R1 + R2
	#40
	
	if (R1 != 380) begin 
		 
		error = error + 1;
	end 
	
	
	// TEST SUB
	din = 9'b011010001; //R2 - R1
	#40
	
	if (R2 != -9'sd346) begin 
	
		error = error + 1;
	end 
	
	// TEST MUL
	din = 9'b100010001; //R2 * R1
	#40
	
	if (R2 != 16'b1111111001101000) begin 
		
		error = error + 1;
	end
	
	// TEST MOVI
	
	din = 9'b111110000; // R6
	#10
	din = 9'd10; 
	#30
	
	if (R6 != 10) begin 
		error = error + 1;
	end 
	
	// TEST MOVI
	
	din = 9'b111111000; //R7
	#10
	din = 9'd45; 
	#30
	if (R7 != 45) begin 
		error = error + 1;
	end 
	
	// TEST MUL
	
	din = 9'b100111110; //R7*R6 
	#40
	if (R7 != 16'b0000000111000010) begin 
		error = error + 1;
	end
	
	

    	// MOVI FOR SSI
	din = 9'b111101000; //R7
	#10
	din = 9'sd30; 
	#30

	if (R5 != 30) begin 
		error = error + 1;
	end 
	
	// TEST SSI

	din = 9'b101101000;
	
	#10 
	din = 9'sd10;
	#30 
	
	if (R5 != 30720) begin 
		
		error = error + 1;
	end 
	// TEST SSI

	din = 9'b101101000;
	
	#10 
	din = 9'sd10;
	#30 
	
	if (R5 != 0) begin 
		
		error = error + 1;
	end 
	#33
	$display("TASK 3 TEST COMPLETE, %d ERRORS",error);

	$finish;
	end 	
	 
	 
endmodule 