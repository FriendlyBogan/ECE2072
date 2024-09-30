/*
Monash University ECE2072: Assignment 
This file contains Verilog code to implement individual components to be used in 
    the CPU.

Please enter your name and student ID:

*/
module sign_extend(input [8:0]in, output [15:0]ext);
	/* 
	 * This module sign extends the 9-bit Din to a 16-bit output.
	 */

	assign ext = {{7{in[8]}}, in} // this is checking 9th bit of in, replicating it 7 times then concatenating it with in

endmodule

module tick_FSM (
    input wire clk,     
    input wire rst,      
    input wire enable,  
    output reg [3:0] tick  
);

    
    parameter A = 4'b0001,  
              B = 4'b0010,  
              C = 4'b0100,  
              D = 4'b1000;  
    
    reg [3:0] current_state, next_state;

    always @(current_state, enable) begin
        
        next_state = current_state;

        if (enable) begin
		  
            case (current_state)
                A: next_state = B;  
                B: next_state = C;  
                C: next_state = D;  
                D: next_state = A; 
                default: next_state = A;  
            endcase
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= A;  
        end else begin
            current_state <= next_state; 
        end
    end

    always @(current_state) begin
        tick = current_state;  // Output the current state as the tick value
    end

endmodule


module multiplexer(SignExtDin, R0, R1, R2, R3, R4, R5, R6, R7, G, sel, Bus);
	/* 
	 * This module takes 10 inputs and places the correct input onto the bus.
	 */
	// TODO: Declare inputs and outputs
	input [15:0] SignExtDin; //user defined input
	input [3:0] sel; //assuming sel coming from control unit 
	input [15:0] R0, R1, R2, R3, R4, R5, R6, R7; //diff registered that can be inst
	input [15:0] G; // outcome of ALU 
	output [15:0] Bus; 
 

	// TODO: implement logic
	always @(sel) begin 
		if (enable) begin 
			case (sel)   
				4'b0000: R0 = Bus; 
				4'b0001: R1 = Bus; 
				4'b0010: R2 = Bus; 
				4'b0011: R3 = Bus; 
				4'b0100: R4 = Bus; 
				4'b0101: R5 = Bus; 
				4'b0110: R6 = Bus; 
				4'b0111: R7 = Bus; 
				4'b1000: G = Bus; 
				4'b1001: SignExtDin = Bus;
				default: Bus = 16'b0; // Default case for unused states
			endcase
		end  
		else begin 
			Bus = 16'b0;
		end 
    end
endmodule

module ALU (input_a, input_b, alu_op, result);
	 // This module implements the arithmetic logic unit of the processor.
	// TODO: declare inputs and outputs
	input signed [15:0]input_a;
	input signed [15:0]input_b;
	input [2:0]alu_op;
	output reg [15:0]result;
	
	reg signed [31:0] result_calc; //maximum number of bits possible even with 16 bits


	// TODO: manage overflow
	
	
	parameter 
			mul = 3'b000, 
			add = 3'b001, 
			sub = 3'b010, 
			shift = 3'b011; //dont cares has been emitted 
	
	always  @(input_a,input_b,alu_op) begin
		case (alu_op)
			
			mul: result_calc = input_a * input_b;
			
			add: result_calc = input_a + input_b;
			
			sub: result_calc = input_a - input_b;
			 
			shift: 
				
				if (input_a >= 0) begin
				
                    result_calc = input_b <<< input_a[3:0]; // only ranging [3:0] so that it would only shift in range of 16 bits 
						  
                end else begin
					 
                    result_calc = input_b >>> -input_a[3:0]; // - to make it negative
						  
				end
			
			default: result_calc = 32'b0;
			
		endcase
		
		if (result_calc > 16'sb0111111111111111) begin
		
			 result = 16'sb0111111111111111;  // limit to the max positive 16-bit value
			 
		end else if (result_calc < 16'sb1000000000000000) begin
		
			 result = 16'sb1000000000000000;  // limit to the max negative 16-bit value
			 
		end else begin
		
			 result = result_calc[15:0]; 
			 
		end
		
		
	end
endmodule






module register_n(data_in, r_in, clk, Q, rst);


	// To set parameter N during instantiation, you can use:
	// register_n #(.N(num_bits)) reg_IR(.....), 
	// where num_bits is how many bits you want to set N to
	// and "..." is your usual input/output signals
	parameter N = 16;
	/* 
	 * This module implements registers that will be used in the processor.
	 */
	// TODO: Declare inputs, outputs, and parameter:
	input [16:0]data_in;
	input r_in;
	input clk;
	input rst;
	output reg [N:0]Q;

	// TODO: Implement register logic:
	always @(posedge clk) begin
		if (rst) Q <= 0;
		else if (r_in) Q <= data_in[N:0];
	end
endmodule

