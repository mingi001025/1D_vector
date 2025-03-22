// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac_16in (out, a, b);

parameter bw = 8;
parameter bw_psum = 2*bw+6;
parameter pr = 64; // parallel factor: number of inputs = 64

output [bw_psum-1:0] out;
input  [pr*bw-1:0] a;
input  [pr*bw-1:0] b;


wire		[2*bw-1:0]	product0	;
wire		[2*bw-1:0]	product1	;
wire		[2*bw-1:0]	product2	;
wire		[2*bw-1:0]	product3	;
wire		[2*bw-1:0]	product4	;
wire		[2*bw-1:0]	product5	;
wire		[2*bw-1:0]	product6	;
wire		[2*bw-1:0]	product7	;

genvar i;


assign product0 = ((a[bw*1-1:bw*0]!=0)&&(b[bw*1-1:bw*0]!=0))?{{(bw){a[bw*1-1]}}, a[bw*1-1:bw*0]} * {{(bw){b[bw*1-1]}}, b[bw*1-1:bw*0]}:0;
assign product1 = ((a[bw*2-1:bw*1]!=0)&&(b[bw*2-1:bw*1]!=0))?{{(bw){a[bw*2-1]}}, a[bw*2-1:bw*1]} * {{(bw){b[bw*2-1]}}, b[bw*2-1:bw*1]}:0;
assign product2 = ((a[bw*3-1:bw*2]!=0)&&(b[bw*3-1:bw*2]!=0))?{{(bw){a[bw*3-1]}}, a[bw*3-1:bw*2]} * {{(bw){b[bw*3-1]}}, b[bw*3-1:bw*2]}:0;
assign product3 = ((a[bw*4-1:bw*3]!=0)&&(b[bw*4-1:bw*3]!=0))?{{(bw){a[bw*4-1]}}, a[bw*4-1:bw*3]} * {{(bw){b[bw*4-1]}}, b[bw*4-1:bw*3]}:0;
assign product4 = ((a[bw*5-1:bw*4]!=0)&&(b[bw*5-1:bw*4]!=0))?{{(bw){a[bw*5-1]}}, a[bw*5-1:bw*4]} * {{(bw){b[bw*5-1]}}, b[bw*5-1:bw*4]}:0;
assign product5 = ((a[bw*6-1:bw*5]!=0)&&(b[bw*6-1:bw*5]!=0))?{{(bw){a[bw*6-1]}}, a[bw*6-1:bw*5]} * {{(bw){b[bw*6-1]}}, b[bw*6-1:bw*5]}:0;
assign product6 = ((a[bw*7-1:bw*6]!=0)&&(b[bw*7-1:bw*6]!=0))?{{(bw){a[bw*7-1]}}, a[bw*7-1:bw*6]} * {{(bw){b[bw*7-1]}}, b[bw*7-1:bw*6]}:0;
assign product7 = ((a[bw*8-1:bw*7]!=0)&&(b[bw*8-1:bw*7]!=0))?{{(bw){a[bw*8-1]}}, a[bw*8-1:bw*7]} * {{(bw){b[bw*8-1]}}, b[bw*8-1:bw*7]}:0;

assign out = 
                {{(4){product0[2*bw-1]}},product0	}
	+	{{(4){product1[2*bw-1]}},product1	}
	+	{{(4){product2[2*bw-1]}},product2	}
	+	{{(4){product3[2*bw-1]}},product3	}
	+	{{(4){product4[2*bw-1]}},product4	}
	+	{{(4){product5[2*bw-1]}},product5	}
	+	{{(4){product6[2*bw-1]}},product6	}
	+	{{(4){product7[2*bw-1]}},product7	};



endmodule
