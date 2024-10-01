`timescale 1ns/1ns
/*
Monash University ECE2072: Assignment 
This file contains a Verilog test bench to test the correctness of the individual 
    components used in the processor.

Please enter your student ID: 33808481

*/
module components_tb.v;
    // TODO: Implement the logic of your testbench here
    module alu_test;

    reg [15:0] input_a;
    reg [15:0] input_b;
    reg [2:0] alu_op;
    wire [15:0] result;

    ALU test (
        .input_a(input_a),
        .input_b(input_b),
        .alu_op(alu_op),
        .result(result)
    );

    integer error, count;

    initial begin

        input_a = 16'b0;
        input_b = 16'b0;
        alu_op = 3'b000;
        error = 0;
        count = 0;

        
        while (count < 50) begin //truncated at 50 for a faster compile 

        for (alu_op = 3'b000; alu_op <= 3'b011; alu_op = alu_op + 1) begin
            #1;
            
            case (alu_op)
            3'b000: // multiplication
                if (result != input_a * input_b) begin 
                error = error + 1;
                $display("Error in multiplication at input_a = %0b, input_b = %0b, result = %0b", input_a, input_b, result);
                end
            3'b001: // addition
                if (result != input_a + input_b) begin 
                error = error + 1;
                $display("Error in addition at input_a = %0b, input_b = %0b, result = %0b", input_a, input_b, result);
                end
            3'b010: // subtraction
                if (result != input_a - input_b) begin 
                error = error + 1;
                $display("Error in subtraction at input_a = %0b, input_b = %0b, result = %0b", input_a, input_b, result);
                end
            3'b011: // left shift
                if (result != (input_b << input_a)) begin
                error = error + 1;
                $display("Error in left shift at input_a = %0b, input_b = %0b, result = %0b", input_a, input_b, result);
                end
            endcase
        end
        
        input_a = input_a + 1;
        input_b = input_b + 1;
        count = count + 1;
        end

        $display("Simulation completed with %0d errors", error);
    end

    endmodule

    module tickFSM_test;

        reg clk, rst, enable;
        wire [3:0] tick;

        tick_FSM fsm (
            .clk(clk),
            .rst(rst),
            .enable(enable),
            .tick(tick)
        );
        
        always #5 clk = ~clk;
        
        initial begin
            clk = 0;
            rst = 1; 
            enable = 0;
            
            #10 rst = 0;

            #10 enable = 1;
            
            #100 $finish;
        end

        initial begin
            $display("Tick: %b", tick);
        end

    endmodule

    module sign_extend_test;

	reg [8:0] data_in;
	wire [15:0] data_out;
	
	
	sign_extend test ( // Instance of the sign_extend module
		.in(data_in), 
		.ext(data_out)
	);
	
	integer error;

	initial begin
	  error = 0;
	  
    // Edge case: Most negative number
    data_in = 9'b100000000;
    #10;
		if (data_out[15] != data_in[8]) begin 
			error = error + 1;
		end 
    $display("Input = %b, Output = %b (expected: 1111111100000000)", data_in, data_out);
    
    // Edge case: Most positive number
    data_in = 9'b011111111;
    #10;
		if (data_out[15] != data_in[8]) begin 
			error = error + 1;
		end 
    $display("Input = %b, Output = %b (expected: 0000000011111111)", data_in, data_out);

    // Edge case: Zero
    data_in = 9'b000000000;
    #10;
		if (data_out[15] != data_in[8]) begin 
			error = error + 1;
		end 
    $display("Input = %b, Output = %b (expected: 0000000000000000)", data_in, data_out); //here the positive and negative 0 dont care
    
    // Small positive number
    data_in = 9'b000000001;
    #10;
		if (data_out[15] != data_in[8]) begin 
			error = error + 1;
		end 
    $display("Input = %b, Output = %b (expected: 0000000000000001)", data_in, data_out);

    // Small negative number
    data_in = 9'b111111111;
    #10;
		if (data_out[15] != data_in[8]) begin 
			error = error + 1;
		end 
    $display("Input = %b, Output = %b (expected: 1111111111111111)", data_in, data_out);

    // Mid-range positive number
    data_in = 9'b010101010;
    #10;
		if (data_out[15] != data_in[8]) begin 
			error = error + 1;
		end 
    $display("Input = %b, Output = %b (expected: 0000000010101010)", data_in, data_out);

    // Mid-range negative number
    data_in = 9'b101010101;
    #10;
		if (data_out[15] != data_in[8]) begin 
			error = error + 1;
		end 
    $display("Input = %b, Output = %b (expected: 11111111101010101)", data_in, data_out);
	 #5 $finish;
	end
	
    endmodule 
	
	


endmodule