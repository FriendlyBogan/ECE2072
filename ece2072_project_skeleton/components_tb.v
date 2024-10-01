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

module test_register_n;
    reg [15:0] data_in;
    reg rst, r_in, clk;
    wire [15:0]Q;
    register_n #(.N(16)) test(.data_in(data_in), .r_in(r_in), .clk(clk), .rst(rst), .Q(Q));
    
    integer count, error;
    initial begin
        data_in = 16'b1111;
        rst = 1;
        clk = 0;
        r_in = 1;
        error = 0;
        count = 0;
        #2
        clk = 1;
        #1
        clk = 0;
        if (Q != 0) begin
            error = error + 1;
            $display("Q is %b, should be 0", Q);
        end
        #1
        rst = 0;
        r_in = 0;
        #2
        clk = 1;
        #1
        clk = 0;
        if (Q != 0) begin
            error = error + 1;
            $display("Q is %b, should be 0", Q);
        end
        #1
        r_in = 1;
        data_in = 0;
    end

    always #15 clk = ~clk;

    always begin
        for (count = 0; count < 1000; count = count + 1) begin
        #10
        data_in = data_in + 1;
        #20
        if (Q != data_in) begin
            error = error + 1;
            $display("Q is %b, should be %b", Q, data_in);
        end

        end
        $finish;
    end
endmodule


endmodule