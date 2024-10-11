`timescale 1ns/1ns
/*
Monash University ECE2072: Assignment 
This file contains a Verilog test bench to test the correctness of the individual 
    components used in the processor.

Please enter your student ID: 33808481

*/
module components_tb; 
    // Declare the testbench signals
    reg signed [15:0] input_a;
    reg signed [15:0] input_b;
    reg [2:0] alu_op;
    wire signed [15:0] result;	

    // Instantiate the ALU module under test
    ALU uut (
        .input_a(input_a),
        .input_b(input_b),
        .alu_op(alu_op),
        .result(result)
    );

    integer error;

    // Test sequence
    initial begin
        // Initialize inputs and variables
        error = 0;
        input_a = 16'b0;
        input_b = 16'b0;
        alu_op = 0;
        
        //TEST ADD
        
        input_a = 16'd255;
        input_b = 16'd255;
        alu_op = 3'b001;
        #3
        if (result != 510) begin 
            error = error + 1;
        end 
        #10
        
        //TEST OVERFLOW
        
        input_a = 16'd7000;
        input_b = 16'd8000;
        #3
        
        if (result != 15000) begin 
            error = error + 1;
        end 
        
        #10 
        //TEST SUB
        
        input_a = -16'sd255;
        input_b = 16'd255;
        alu_op = 3'b010;
        #3
        if (result != -510) begin 
            error = error + 1; 
        end 
        #10
        
        input_a = -16'sd547;
        input_b = 16'sd99100;
        #3 
        
        if (result != -16'sd99647) begin
                error = error + 1;
        end 
        #10 
        
        //TEST MUL
        input_a = 16'sd34;
        input_b = -16'sd25;
        alu_op = 3'b000;
        #3
        if (result != -16'sd850) begin 
            error = error + 1;
        end 
        #10
        
        input_a = 16'sd57;
        input_b = 16'sd90;
        #3 
        
        if (result != 57*90) begin 
            error = error + 1;
        end
        #10 
        
        
        //TEST SSI
        input_a = 16'd3;
        input_b= -16'sd10;
        alu_op = 3'b011;
        #3
        if (result != -16'sd10 <<< 16'd3) begin 
            
            error = error + 1;
        end
        
        //TEST SSI 
        #10
        input_a = -16'sd2;
        input_b = -16'sd10;
        #3
        if (result != 16'b1111111111111101) begin
        
            error = error + 1;
        end 
        #10
        
        input_a = 16'sd30;
        input_b = 16'sd10;
        #3 
        
        if (result != 0) begin 
            
            error = error + 1;
        end 
            
        #10
        
        $display("ALU COMPLETE %d ERRORS",error);
    end  





        reg clk, rst_1, enable;
        wire [3:0] tick;

        tick_FSM fsm (
            .clk(clk),
            .rst(rst_1),
            .enable(enable),
            .tick(tick)
        );
        
        always #15 clk = ~clk;
        
        initial begin
            clk = 0;
            rst_1 = 1; 
            enable = 0;
				if (tick != 4'b0001) begin 
					
					error = error + 1;
				end 
            
            #30 rst_1 = 0;
				
				if (tick != 4'b0001) begin 
					
					error = error + 1;
				end 

            #30 enable = 1;
					
				if (tick != 4'b0001) begin 
					
					error = error + 1;
				end 
				#30 
				
				if (tick != 4'b0010) begin 
					
					error = error + 1;
				end 
				#30 
				
				if (tick != 4'b0100) begin 
					
					error = error + 1;
				end 
				#30
				
				if (tick != 4'b1000) begin 
					
					error = error + 1;	
				end 
            #200 
				$display("TICK FSM COMPLETE %d ERROR",error);
				$display("ALL COMPONENTS TEST FINISH, %d ERROR", error);
				$finish;
				
        end		  

	reg [8:0] data_in1;
	wire [15:0] data_out;
	
	
	sign_extend test(
		.in(data_in1), 
		.ext(data_out)
	);


	
	initial begin 
    // Edge case: Most negative number
    data_in1 = 9'b100000000;
    #10;
		if (data_out[15] != data_in1[8]) begin 
			error = error + 1;
			$display("Input = %b, Output = %b (expected: 1111111100000000)", data_in1, data_out);
		end 
    
    
    // Edge case: Most positive number
    data_in1 = 9'b011111111;
    #10;
		if (data_out[15] != data_in1[8]) begin 
			error = error + 1;
			$display("Input = %b, Output = %b (expected: 0000000011111111)", data_in1, data_out);
		end 
    // Edge case: Zero
    data_in1 = 9'b000000000;
    #10;
		if (data_out[15] != data_in1[8]) begin 
			error = error + 1;
			$display("Input = %b, Output = %b (expected: 0000000000000000)", data_in1, data_out);
		end 
     //here the positive and negative 0 dont care
    
    // Small positive number
    data_in1 = 9'b000000001;
    #10;
		if (data_out[15] != data_in1[8]) begin 
			error = error + 1;
			$display("Input = %b, Output = %b (expected: 0000000000000001)", data_in1, data_out);
		end 
    
    // Small negative number
    data_in1 = 9'b111111111;
    #10;
		if (data_out[15] != data_in1[8]) begin 
			error = error + 1;
			$display("Input = %b, Output = %b (expected: 1111111111111111)", data_in1, data_out);
		end 
   

    // Mid-range positive number
    data_in1 = 9'b010101010;
    #10;
		if (data_out[15] != data_in1[8]) begin 
			error = error + 1;
			$display("Input = %b, Output = %b (expected: 0000000010101010)", data_in1, data_out);
		end 
    

    // Mid-range negative number
    data_in1 = 9'b101010101;
    #10;
		if (data_out[15] != data_in1[8]) begin 
			error = error + 1;
			$display("Input = %b, Output = %b (expected: 11111111101010101)", data_in1, data_out);
		end 
    
	 $display("SIGN EXT TEST COMPLETE, %d errors",error);
	end
	

	
	

    reg [15:0] data_in;
    reg rst, r_in;
    wire [15:0]Q;
    wire [8:0]R;
    register_n #(.N(16)) test3(.data_in(data_in), .r_in(r_in), .clk(clk), .rst(rst), .Q(Q));
    register_n #(.N(9)) test1(.data_in(data_in), .r_in(r_in), .clk(clk), .rst(rst), .Q(R));
    integer count;
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
        if (R != 0) begin
            error = error + 1;
            $display("R is %b, should be 0", R);
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
		  
        if (R != 0) begin
            error = error + 1;
            $display("R is %b, should be 0", R);
        end
        #1
        r_in = 1;
        data_in = 0;
		  $display("REGISTER OOMPLETE, %d ERROR",error);
    end


    always begin
        for (count = 0; count < 1000; count = count + 1) begin
        #10
        data_in = data_in + 1;
        #20
        if (Q != data_in) begin
            error = error + 1;
            $display("Q is %b, should be %b", Q, data_in);
        end
        if (R != data_in[8:0]) begin
            error = error + 1;
            $display("R is %b, should be %b", R, data_in[8:0]);
        end
		
        end
		 
    end
	 
endmodule

	 
