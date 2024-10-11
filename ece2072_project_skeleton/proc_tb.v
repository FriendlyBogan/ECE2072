`timescale 1ns/1ns
/*
Monash University ECE2072: Assignment 
This file contains a Verilog test bench to test the correctness of the processor.

Please enter your student ID:

*/
module proc_tb;
    // TODO: Implement the logic of your testbench here
	 
	reg clk, rst;
	reg [8:0] din;
	wire [3:0]tick;
	wire [15:0] bus, R0, R1, R2, R3, R4, R5, R6, R7;
	integer error;
	simple_proc uut(.clk(clk), .rst(rst), .din(din), .bus(bus), .R0(R0), .R1(R1), .R2(R2), .R3(R3), .R4(R4), .R5(R5), .R6(R6), .R7(R7),.tick(tick));
	 
	always #5 clk = ~clk;
	
	initial begin 
	clk = 0;
	error = 0;
	//TEST ADDI 
	#7
	din = 9'b010001000; //R1
	rst = 0;
	#10
	din = -9'sd255;
	#30

	if (R1!= -9'sd255) begin 
		
		error = error + 1;
	end
	
	din = 9'b010001000; //R1
	#10
	din = -9'sd340; 
	#30
	
	if (R1 != -9'sd595) begin 
	
		error = error + 1;
	end 
	

	// TEST MOVI

	din = 9'b111010000; //r2
	#10
	din = 9'sd600;
	#30
	
	if (R2 != 9'sd600) begin 
		
		error = error + 1;
	end 
	
	
	// TEST add;

	din = 9'b001001010; //R1 + R2
	#40
	
	if (R1 != 9'd5) begin 
		 
		error = error + 1;
	end 
	
	
	// TEST SUB
	din = 9'b011010001; //R2 - R1
	#40
	
	if (R2 != 9'd83) begin 
	
		error = error + 1;
	end 
	
	#10
	
	
	$display("TEST COMPLETE %d ERRORS",error);

	$finish;
	end 	
	 
	 
endmodule 