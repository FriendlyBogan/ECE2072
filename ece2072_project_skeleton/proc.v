/*
Monash University ECE2072: Assignment 
This file contains Verilog code to implement individual the CPU.

Please enter your student ID:

*/
module simple_proc(clk, rst, din, bus, R0, R1, R2, R3, R4, R5, R6, R7, tick);

    // Note: The skeleton you are provided with includes output ports to output the values of the internal registers R0 - R7, for the purpose of test benching. When instantiating the processor to program your DE10-lite, you can leave these ports unused.
    
    // TODO: Declare inputs and outputs:
    input clk;
    input rst;
    input [8:0]din;
    output [15:0] bus; 
    output [15:0] R0, R1, R2, R3, R4, R5, R6, R7;
    output wire [3:0] tick;
    

    // TODO: declare wires:
    wire [15:0] G_out, A_out;
	wire [15:0] ALU_out;
    
    wire [8:0] IR_out;
    reg IR_in, A_in, G_in;
    reg R0_in, R1_in, R2_in, R3_in, R4_in, R5_in, R6_in, R7_in;
    wire [15:0] SignExtDin;
    reg [3:0] BUS_control;
    reg [2:0] ALU_op;
	 

    // TODO: instantiate registers:
    register_n  #(.N(9))reg_IR(.r_in(IR_in), .clk(clk), .data_in(din), .rst(rst), .Q(IR_out));
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
    ALU alu(.input_a(A_out), .input_b(bus), .alu_op(ALU_op),.result(ALU_out));
    
    // TODO: instantiate tick counter:
    tick_FSM tfsm(.clk(clk), .rst(rst), .enable(1'b1), .tick(tick));

    reg [0:0] movi, add, addi, sub;

          
    
    // TODO: define control unit:
    initial begin 
        IR_in = 1;
        {A_in, G_in, R0_in, R1_in, R2_in, R3_in, R4_in, R5_in, R6_in, R7_in} = 1'b0;
        BUS_control = 0;
         
    end 

	
    always @(tick,IR_out) begin
        {movi, add, addi, sub} = 0;
        {A_in, G_in, R0_in, R1_in, R2_in, R3_in, R4_in, R5_in, R6_in, R7_in,IR_in} = 1'b0;
        BUS_control = 3'd0;
        ALU_op = 3'd0;
						 
        // TODO: Turn off all control signals:
        // TODO: Turn on specific control signals based on current tick:
        case (tick)
            4'b0001:
                begin
                    // TODO
                    
                   
                    
                end
            
            4'b0010:
                begin
                    case (IR_out[8:6])
                            3'b001: add = 1;
                            3'b010: addi = 1;
                            3'b011: sub = 1;
                            3'b111: movi = 1;
									 default: 
										{add,addi,sub,movi} = 0;
                    endcase
							
                    // TODO
                    if (add | sub | addi) begin
                        
                        BUS_control = IR_out[5:3]; //Rx
                        
                        A_in = 1; 
                        
                    end
					
                    else if (movi) begin
                        BUS_control = 4'b1001; //Immediate Value
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
				end
            
            4'b0100:
                begin
                    // TODO
                    case (IR_out[8:6])
                        3'b001: add = 1;
                        3'b010: addi = 1;
                        3'b011: sub = 1;
                        3'b111: movi = 1;
								default: 
									{add,addi,sub,movi} = 0;
                    endcase

                    if (add) begin
                        A_in = 0;
								
                        BUS_control = IR_out[2:0]; //Ry

                        G_in = 1;
								
						ALU_op = 3'b001;
                    end 
						  
                    else if (addi) begin 
                        
                        A_in = 0;
                        
                        BUS_control = 4'b1001; //Immediate value
                        
                        G_in = 1;
                        
                        ALU_op = 3'b001;
                    
                    end

                    else if (sub) begin
                        A_in = 0;
								
                        BUS_control = IR_out[2:0]; //Ry

                        G_in = 1;
								
								ALU_op = 3'b010;
                    
						  end

						  
                    else if (movi) begin
                        {A_in, G_in, R0_in, R1_in, R2_in, R3_in, R4_in, R5_in, R6_in, R7_in} = 1'b0;
                    end

                end
            
            4'b1000:
                begin
                    case (IR_out[8:6])
                        3'b001: add = 1;
                        3'b010: addi = 1;
                        3'b011: sub = 1;
                        3'b111: movi = 1;
								default: 
								{add,addi,sub,movi} = 0;
                    endcase
                    // TODO
                    if (add | sub | addi) begin

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