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

	assign ext[8:0] = in[8:0];
	assign ext[15:9] = in[8] ? 255 : 0;
endmodule




module tick_FSM(rst, clk, enable, tick);
	/* 
	 * This module implements a tick FSM that will be used to
	 * control the actions of the control unit
	 */

	// TODO: Declare inputs and outputs
	input clk;
    input rst; 
    input enable; // assume enable signal is 4 bits
    output tick; //clock for reg

    // enable is a 1 bit wire 
    
    reg [3:0] current_state, next_state;
    
    parameter A= 4'b0000, B= 4'b0001, C = 4'b0010, D = 4'b0100, E = 4'b1000; //one hot
    
    always @(enable,currnet_state) begin
        if (enable == 1) begin
            case(next_state)
                A: 
                    next_state = B;
                B: 
                    next_state = C;
                C: 
                    next_state = D;
                D: 
                    next_state = A;
                default : next_state = 4'b0000;
            endcase
        else begin 
            current_state = 4'b0000;
        end
    end

	always @(posedge clk ) begin
		if (rst) begin
			current_state = 4'b0000;
		end 
	end

    always @(posedge clk) begin
        current_state <= next_state;
    end 
    // TODO: implement FSM
endmodule

module multiplexer(SignExtDin, R0, R1, R2, R3, R4, R5, R6, R7, G, sel, Bus);
	/* 
	 * This module takes 10 inputs and places the correct input onto the bus.
	 */
	// TODO: Declare inputs and outputs
	
	// TODO: implement logic


endmodule

module ALU (input_a, input_b, alu_op, result);
	 * This module implements the arithmetic logic unit of the processor.
	 */
	// TODO: declare inputs and outputs
	input input_a;
	input input_b;
	input alu_op;
	output result;


	// TODO: Implement ALU Logic:
	parameter: mul = 3'b000, add = 3'b001, sub = 3'b010, shift = 3'b011;
	
	always  @(input_a,input_b) begin
		case (alu_op):
		
			mul: result = input_a * input_b;
			
			add: result = input_a + input_b;
			
			sub: result = input_a - input_b;
			
			shift: result = input_b <<< input_a;
				
		endcase
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
	
	// TODO: Implement register logic:
endmodule

