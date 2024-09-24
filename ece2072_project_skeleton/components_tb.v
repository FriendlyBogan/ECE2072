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


endmodule