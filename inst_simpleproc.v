module inst_simpleproc(LEDR, SW, HEX5, KEY); 

	input [8:0]SW;
	input [1:0]KEY;
	output [9:0] LEDR;
	output [6:0]HEX5;
	
	
	simple_proc inst(.clk(~KEY[1]), .rst(~KEY[0]), .din(SW[8:0]), .bus(LEDR[9:0]), .R0(), .R1(), .R2(),.R3(), .R4(), .R5(), .R6(), .R7(),.IR_out());
	
	bcd hex5(.sign(1), .in(tick_decoded), .Hex(HEX5));

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



