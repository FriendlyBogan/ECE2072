/*
Monash University ECE2072: Assignment 
This file contains Verilog code to implement individual the CPU.

Please enter your student ID:

*/
module simple_proc(clk, rst, din, bus, R0, R1, R2, R3, R4, R5, R6, R7);

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
    wire [8:0] IR_out;
    wire IR_in, A_in, G_in;
    wire R0_in, R1_in, R2_in, R3_in, R4_in, R5_in, R6_in, R7_in;
    wire [15:0] SignExtDin;
    wire [3:0] BUS_control;
    wire [2:0] ALU_op;
    wire CLK;


    // TODO: instantiate registers:
    register_n #(.N(9)) reg_IR(.r_in(IR_in), .clk(CLK), .data_in(din), .rst(rst), .Q(IR_out));
    register_n  reg_A(.r_in(A_in), .clk(CLK), .data_in(bus), .rst(rst), .Q(A_out));
    register_n  reg_G(.r_in(G_in), .clk(CLK), .data_in(ALU_out), .rst(rst), .Q(G_out));
    register_n  reg_0(.r_in(R0_in), .clk(CLK), .data_in(bus), .rst(rst), .Q(R0));
    register_n  reg_1(.r_in(R1_in), .clk(CLK), .data_in(bus), .rst(rst), .Q(R1));
    register_n  reg_2(.r_in(R2_in), .clk(CLK), .data_in(bus), .rst(rst), .Q(R2));
    register_n  reg_3(.r_in(R3_in), .clk(CLK), .data_in(bus), .rst(rst), .Q(R3));
    register_n  reg_4(.r_in(R4_in), .clk(CLK), .data_in(bus), .rst(rst), .Q(R4));
    register_n  reg_5(.r_in(R5_in), .clk(CLK), .data_in(bus), .rst(rst), .Q(R5));
    register_n  reg_6(.r_in(R6_in), .clk(CLK), .data_in(bus), .rst(rst), .Q(R6));
    register_n  reg_7(.r_in(R7_in), .clk(CLK), .data_in(bus), .rst(rst), .Q(R7));
    


    // TODO: instantiate Multiplexer:
    sign_extend se (.in(din), .ext(SignExtDin));
    multiplexer mux(.SignExtDin(SignExtDin), .R0(R0), .R1(R1), .R2(R2), .R3(R3), .R4(R4), .R5(R5), .R6(R6), .R7(R7), .G(G_out), .sel(BUS_control), .Bus(bus));
    
    // TODO: instantiate ALU:
    ALU alu(.input_A(A_out), input_B(bus), .result(ALU_out));
    
    // TODO: instantiate tick counter:
    tick_FSM tfsm(.clk(clk), .rst(rst), .enable(1'b1), .tick(tick));
    
    // TODO: define control unit:
    always @(/* List signals that can change the control unit's output */) begin
        // TODO: Turn off all control signals:


        // TODO: Turn on specific control signals based on current tick:
        case (/* your counter value goes here */)
            /* Tick 1 */:
                begin
                    // TODO
                end
            
            /* Tick 2 */:
                begin
                    // TODO
                end
            
            /* Tick 3 */:
                begin
                    // TODO
                end
            
            /* Tick 4 */:
                begin
                    // TODO
                end
            
            default:
                begin
                    // TODO
                end

        endcase

    end

endmodule