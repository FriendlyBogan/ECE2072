/*
Monash University ECE2072: Assignment 
This file contains Verilog code to implement individual the CPU.

Please enter your student ID:

*/
module simple_proc(clk, rst, din, bus, R0, R1, R2, R3, R4, R5, R6, R7,IR_out);

    // Note: The skeleton you are provided with includes output ports to output the values of the internal registers R0 - R7, for the purpose of test benching. When instantiating the processor to program your DE10-lite, you can leave these ports unused.
    
    // TODO: Declare inputs and outputs:
    input clk;
    input rst;
    input din;
    output [15:0] bus; 
    output [15:0] R0, R1, R2, R3, R4, R5, R6, R7;
    
    

    // TODO: declare wires:
    wire [15:0] G_out, A_out, ALU_out;
    wire [3:0] tick;
    output wire [8:0] IR_out;
    reg IR_in, A_in, G_in;
    reg R0_in, R1_in, R2_in, R3_in, R4_in, R5_in, R6_in, R7_in;
    wire [15:0] SignExtDin;
    reg [3:0] BUS_control;
    reg [2:0] ALU_op;
	 

    // TODO: instantiate registers:
    register_n #(.N(9)) reg_IR(.r_in(IR_in), .clk(clk), .data_in(din), .rst(rst), .Q(IR_out));
    register_n  reg_A(.r_in(A_in), .clk(clk), .data_in(bus), .rst(rst), .Q(A_out));
    register_n  reg_G(.r_in(G_in), .clk(clk), .data_in(ALU_out), .rst(rst), .Q(G_out));
    register_n  reg_0(.r_in(R0_in), .clk(clk), .data_in(bus), .rst(rst), .Q(R0));
    register_n  reg_1(.r_in(R1_in), .clk(clk), .data_in(bus), .rst(rst), .Q(R1));
    register_n  reg_2(.r_in(R2_in), .clk(clk), .data_in(bus), .rst(rst), .Q(R2));
    register_n  reg_3(.r_in(R3_in), .clk(clk), .data_in(bus), .rst(rst), .Q(R3));
    register_n  reg_4(.r_in(R4_in), .clk(clk), .data_in(bus), .rst(rst), .Q(R4));
    register_n  reg_5(.r_in(R5_in), .clk(clk), .data_in(bus), .rst(rst), .Q(R5));
    register_n  reg_6(.r_in(R6_in), .clk(clk), .data_in(bus), .rst(rst), .Q(R6));
    register_n  reg_7(.r_in(R7_in), .clk(clk), .data_in(bus), .rst(rst), .Q(R7));
    


    // TODO: instantiate Multiplexer:
    sign_extend se (.in(din), .ext(SignExtDin));
    multiplexer mux(.SignExtDin(SignExtDin), .R0(R0), .R1(R1), .R2(R2), .R3(R3), .R4(R4), .R5(R5), .R6(R6), .R7(R7), .G(G_out), .sel(BUS_control), .Bus(bus));
    
    // TODO: instantiate ALU:
    ALU alu(.input_a(A_out), .input_b(bus), .result(ALU_out));
    
    // TODO: instantiate tick counter:
    tick_FSM tfsm(.clk(clk), .rst(rst), .enable(1'b1), .tick(tick));

    reg [0:0] movi, add, addi,sub;

    reg [8:0] ins; //could be the same IR_out


          
    
    // TODO: define control unit:
    initial begin 
        IR_in = 1;
        {A_in, G_in, R0_in, R1_in, R2_in, R3_in, R4_in, R5_in, R6_in, R7_in} = 1'b0;
    end 

    always @(tick) begin
        // TODO: Turn off all control signals:
        {movi, add, addi, sub} = 0;
        // TODO: Turn on specific control signals based on current tick:
        case (tick)
            4'b0001:
                begin
                    // TODO
                    IR_in = 1;
                    if (IR_out[8:6] == 1) begin 
                        add = 1;
                        
                    end 

                    if (IR_out[8:6] == 7) begin 
                        movi = 1;
                    end  
						  
						  if (IR_out[8:6] == 2) begin 
								addi = 1;
						  end 
                    
                end
            
            4'b0010:
                begin
                    // TODO
                    if (add) begin
                        
                        BUS_control = IR_out[5:3]; //Rx
                        
                        A_in = 1; 
                        
                    end
						  
						  if (addi) begin 
						  
								BUS_control = IR_out[5:3];//Rx
								
								A_in = 1;
								
						  end


                end
            
            4'b0100:
                begin
                    // TODO

                    if (add) begin
                        A_in = 0;
								
                        BUS_control = IR_out[2:0]; //Ry

                        G_in = 1;
								
								ALU_op = 3'b001;
                    end 
						  
						  if (addi) begin 
								
								A_in = 0;
								
								BUS_control = SignExtDin; //Immediate value
								
								G_in = 1;
								
								ALU_op = 3'b001;
							
						  end 


                end
            
            4'b1000:
                begin
                    // TODO
                    if (add) begin
                        BUS_control = 4'b1000;
                        G_in = 0;
                        case (IR_out[5:3])
                            3'b000: R0_in = 1;
                            3'b001: R1_in = 1;
                            3'b010: R2_in = 1;
                            3'b011: R3_in = 1;
                            3'b100: R4_in = 1;
                            3'b101: R5_in = 1;
                            3'b110: R6_in = 1;
                            3'b111: R7_in = 1;
                        endcase
                        
                    end
						  
						  if (addi) begin 
						  
								BUS_control = 4'b1000;
								
								G_in = 0;
								
								case (IR_out[5:3])
                            3'b000: R0_in = 1;
                            3'b001: R1_in = 1;
                            3'b010: R2_in = 1;
                            3'b011: R3_in = 1;
                            3'b100: R4_in = 1;
                            3'b101: R5_in = 1;
                            3'b110: R6_in = 1;
                            3'b111: R7_in = 1;
                        endcase
								
						  end 
						  
                    
                    IR_in = 1;
						  
						  
                end
            
            default:
                begin
                    IR_in = 1;
                end

        endcase

    end

endmodule