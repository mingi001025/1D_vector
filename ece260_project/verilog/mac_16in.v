// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission
module mac_16in (clk, reset, out, a, b);

parameter bw = 8;
parameter bw_psum = 2*bw+6;
parameter pr = 64; // parallel factor: number of inputs = 64

output [bw_psum-1:0] out;
input clk;
input reset;
input  [pr*bw-1:0] a;
input  [pr*bw-1:0] b;


reg [2*bw-1:0] product0_q ;
reg [2*bw-1:0] product1_q ;
reg [2*bw-1:0] product2_q ;
reg [2*bw-1:0] product3_q ;
reg [2*bw-1:0] product4_q ;
reg [2*bw-1:0] product5_q ;
reg [2*bw-1:0] product6_q ;
reg [2*bw-1:0] product7_q ;
reg [bw_psum-1:0] out_q;

wire [2*bw-1:0] product0 ;
wire [2*bw-1:0] product1 ;
wire [2*bw-1:0] product2 ;
wire [2*bw-1:0] product3 ;
wire [2*bw-1:0] product4 ;
wire [2*bw-1:0] product5 ;
wire [2*bw-1:0] product6 ;
wire [2*bw-1:0] product7 ;

// wire en0, en1, en2, en3, en4, en5, en6, en7;
// wire gclk0, gclk1, gclk2, gclk3, gclk4, gclk5, gclk6, gclk7;


// clkgate clkgate_instance0(en0, clk, gclk0);
// clkgate clkgate_instance1(en1, clk, gclk1);
// clkgate clkgate_instance2(en2, clk, gclk2);
// clkgate clkgate_instance3(en3, clk, gclk3);
// clkgate clkgate_instance4(en4, clk, gclk4);
// clkgate clkgate_instance5(en5, clk, gclk5);
// clkgate clkgate_instance6(en6, clk, gclk6);
// clkgate clkgate_instance7(en7, clk, gclk7);

// assign en0 = ((a[bw*1-1:bw*0]!=0)&&(b[bw*1-1:bw*0]!=0))?1:0;
// assign en1 = ((a[bw*2-1:bw*1]!=0)&&(b[bw*2-1:bw*1]!=0))?1:0;
// assign en2 = ((a[bw*3-1:bw*2]!=0)&&(b[bw*3-1:bw*2]!=0))?1:0;
// assign en3 = ((a[bw*4-1:bw*3]!=0)&&(b[bw*4-1:bw*3]!=0))?1:0;
// assign en4 = ((a[bw*5-1:bw*4]!=0)&&(b[bw*5-1:bw*4]!=0))?1:0;
// assign en5 = ((a[bw*6-1:bw*5]!=0)&&(b[bw*6-1:bw*5]!=0))?1:0;
// assign en6 = ((a[bw*7-1:bw*6]!=0)&&(b[bw*7-1:bw*6]!=0))?1:0;
// assign en7 = ((a[bw*8-1:bw*7]!=0)&&(b[bw*8-1:bw*7]!=0))?1:0;

assign product0 = ((a[bw*1-1:bw*0]!=0)&&(b[bw*1-1:bw*0]!=0))?{{(bw){a[bw*1-1]}}, a[bw*1-1:bw*0]} * {{(bw){b[bw*1-1]}}, b[bw*1-1:bw*0]}:0;
assign product1 = ((a[bw*2-1:bw*1]!=0)&&(b[bw*2-1:bw*1]!=0))?{{(bw){a[bw*2-1]}}, a[bw*2-1:bw*1]} * {{(bw){b[bw*2-1]}}, b[bw*2-1:bw*1]}:0;
assign product2 = ((a[bw*3-1:bw*2]!=0)&&(b[bw*3-1:bw*2]!=0))?{{(bw){a[bw*3-1]}}, a[bw*3-1:bw*2]} * {{(bw){b[bw*3-1]}}, b[bw*3-1:bw*2]}:0;
assign product3 = ((a[bw*4-1:bw*3]!=0)&&(b[bw*4-1:bw*3]!=0))?{{(bw){a[bw*4-1]}}, a[bw*4-1:bw*3]} * {{(bw){b[bw*4-1]}}, b[bw*4-1:bw*3]}:0;
assign product4 = ((a[bw*5-1:bw*4]!=0)&&(b[bw*5-1:bw*4]!=0))?{{(bw){a[bw*5-1]}}, a[bw*5-1:bw*4]} * {{(bw){b[bw*5-1]}}, b[bw*5-1:bw*4]}:0;
assign product5 = ((a[bw*6-1:bw*5]!=0)&&(b[bw*6-1:bw*5]!=0))?{{(bw){a[bw*6-1]}}, a[bw*6-1:bw*5]} * {{(bw){b[bw*6-1]}}, b[bw*6-1:bw*5]}:0;
assign product6 = ((a[bw*7-1:bw*6]!=0)&&(b[bw*7-1:bw*6]!=0))?{{(bw){a[bw*7-1]}}, a[bw*7-1:bw*6]} * {{(bw){b[bw*7-1]}}, b[bw*7-1:bw*6]}:0;
assign product7 = ((a[bw*8-1:bw*7]!=0)&&(b[bw*8-1:bw*7]!=0))?{{(bw){a[bw*8-1]}}, a[bw*8-1:bw*7]} * {{(bw){b[bw*8-1]}}, b[bw*8-1:bw*7]}:0;

assign out =
        {{(4){product0_q[2*bw-1]}},product0_q }
+ {{(4){product1_q[2*bw-1]}},product1_q }
+ {{(4){product2_q[2*bw-1]}},product2_q }
+ {{(4){product3_q[2*bw-1]}},product3_q }
+ {{(4){product4_q[2*bw-1]}},product4_q }
+ {{(4){product5_q[2*bw-1]}},product5_q }
+ {{(4){product6_q[2*bw-1]}},product6_q }
+ {{(4){product7_q[2*bw-1]}},product7_q };

always @(posedge clk) begin
if (reset) begin
product0_q <= 0;
product1_q <= 0;
product2_q <= 0;
product3_q <= 0;
product4_q <= 0;
product5_q <= 0;
product6_q <= 0;
product7_q <= 0;
end
else begin
product0_q <= product0;
product1_q <= product1;
product2_q <= product2;
product3_q <= product3;
product4_q <= product4;
product5_q <= product5;
product6_q <= product6;
product7_q <= product7;
end
end


endmodule
