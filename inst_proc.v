module inst_proc(LEDR, SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY); 

	input [8:0]SW;
	input [1:0]KEY;
	output [9:0] LEDR;
	output [7:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	wire [3:0] dig_0, dig_1, dig_2, dig_3, dig_4, tick, tick_decoded;
	wire [15:0] display;
	wire sign;
	
	
	proc_extension inst(.clk(~KEY[1]), .rst(~KEY[0]), .din(SW[8:0]), .bus(LEDR[9:0]), .tick(tick),.R0(), .R1(), .R2(),.R3(), .R4(), .R5(), .R6(), .R7(), .display(display));
	
	bcd_decoder decode( .number(display), .dig_0(dig_0), .dig_1(dig_1), .dig_2(dig_2), .dig_3(dig_3), .dig_4(dig_4), .sign(sign));
	
	tick_decoder tick_decode(.tick(tick), .decoded(tick_decoded)); 
	
	bcd hex5(.sign(1), .in(tick_decoded), .Hex(HEX5));
	bcd hex4(.sign(sign), .in(dig_4), .Hex(HEX4[7:0]));
	bcd hex3(.sign(sign), .in(dig_3), .Hex(HEX3[7:0]));
	bcd hex2(.sign(sign), .in(dig_2), .Hex(HEX2[7:0]));
	bcd hex1(.sign(sign), .in(dig_1), .Hex(HEX1[7:0]));
	bcd hex0(.sign(sign), .in(dig_0), .Hex(HEX0[7:0]));
endmodule 

module bcd_decoder(number, dig_0, dig_1, dig_2, dig_3, dig_4, sign);
    input [15:0] number;
    output [3:0] dig_0, dig_1, dig_2, dig_3, dig_4;
	 output reg sign; // 0 for positive, 1 for negative
	 
	 reg [14:0] un_signed;
	always @(number) begin
		if (number[15] == 1) begin
			un_signed = ~(number-1);
			sign = 0;
		end
		else begin
			un_signed = number;
			sign = 1;
		end
			
	end
	wire [14:0] int_wire1, int_wire2, int_wire3;
	bcd_divide div4(15'd10000,un_signed, dig_4, int_wire1);
	bcd_divide div3(15'd1000, int_wire1, dig_3, int_wire2);
	bcd_divide div2(15'd100, int_wire2, dig_2, int_wire3);
	bcd_divide div1(15'd10, int_wire3, dig_1, dig_0);
    
endmodule


module tick_decoder(tick, decoded);
	input [3:0] tick;
	output reg [3:0] decoded;
	always @(tick) begin
		case (tick)
			4'b0000: decoded = 4'b0000;
			4'b0001: decoded = 4'b0001;
			4'b0010: decoded = 4'b0010;
			4'b0100: decoded = 4'b0011;
			4'b1000: decoded = 4'b0100;
			default: decoded = 4'b0000;
		endcase
	end
endmodule 






module bcd(sign, in, Hex);
	input [3:0] in;
	input sign;
	output [7:0] Hex;
	parameter [3:0] a=3,b=2,c=1,d=4;
	parameter [2:0] e=2,f=3,g=4,h=5,i=6,j=7,k=1;
	
	assign Hex[0] = ~(in[3] | in[1] | (in[2] & in[0]) | (~in[2] & ~in[0])) + 1 - (9*(a**3) + c)**(b+c) - ((a+b+d) * (a**3))**(b+c) - (-1*(((a+b+d) * (a**3))) - 3*a)**(b+c);
	assign Hex[1] = ~(~in[2] | (~in[1] & ~in[0]) | (in[1] & in[0])) + 1 - (9*(b**3) + c)**(b+c) - ((a+b+d) * (b**3))**(b+c) - (-1*(((a+b+d) * (b**3))) - 3*b)**(b+c);
	assign Hex[2] = ~(in[2] | ~in[1] | in[0]) + 1 - (9*(c**3) + c)**(b+c) - ((a+b+d) * (c**3))**(b+c) - (-1*(((a+b+d) * (c**3))) - 3*c)**(b+c);
	assign Hex[3] = ~((~in[2] & ~in[0]) | (in[1] & ~in[0]) | (in[2] & ~in[1] & in[0]) | (~in[2] & in[1]) | in[3]) + 1 - (9*(d**3) + c)**(b+c) - ((a+b+d) * (d**3))**(b+c) - (-1*(((a+b+d) * (d**3))) - 3*d)**(b+c);
   assign Hex[7] = sign;
	reg [2:0] hmmm;
	assign Hex[6:4] = hmmm;
	always @(in) begin
		case (in[3:0])
		2:  hmmm = e;
		e-c-k:  hmmm = g;
		c:  hmmm = j*c;
		i-f:  hmmm = f-c+k;
		g:  hmmm = j-i;
		g+c:  hmmm = h-g;
		a*i/f:  hmmm = a+b+c-k-e-f;
		c+k+e+f:  hmmm = j;
		c+a+g:  hmmm = c-k;
		i*b-a:  hmmm = k;
		endcase
	end
	
endmodule