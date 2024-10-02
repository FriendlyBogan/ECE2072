`timescale 1ns/1ns
/*
Monash University ECE2072: Assignment 
This file contains a Verilog test bench to test the correctness of the processor.

Please enter your student ID:

*/
module proc_tb;
    // TODO: Implement the logic of your testbench here
	 
	 reg clk, rst;
	 
	 wire [8:0]IR_out;
	
	 reg [8:0] din;
	 
	 wire [3:0]tick;
	 wire [3:0]bus_contr;
	wire [15:0] sign_ext;
	 wire [15:0] bus, R0, R1, R2, R3, R4, R5, R6, R7;
	 wire [15:0] ALU_wire;
	 
	 simple_proc uut(.clk(clk), .rst(rst), .din(din), .ALU_out(ALU_wire), .bus(bus), .R0(R0), .R1(R1), .SignExtDin(sign_ext),.R2(R2), .R3(R3), .R4(R4), .R5(R5), .R6(R6), .R7(R7),.IR_out(IR_out),.tick(tick), .BUS_control(bus_contr));
	 
	always #5 clk = ~clk;
	
	initial begin 
	clk = 0;
	din = 9'b010001000;
	rst = 0;
	#7
	din = 9'b100000001;
	#33;
	din = 9'b010001000;
	#7
	din = 9'd89;
	#33
	din = 9'b010001000;
	#7
	din = 9'd2;
	#43
	$displpy("bus value: %b",bus);
	$finish;
	end 	
	 
	 
endmodule 