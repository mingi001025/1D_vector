// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac_8add (product, out);

parameter bw = 8;
parameter bw_psum = 2*bw+4;
parameter pr = 8; // parallel factor: number of inputs = 64

output [bw_psum-1:0] out;
input [pr*bw*2-1:0] product;

wire		[2*bw-1:0]	product0	;
wire		[2*bw-1:0]	product1	;
wire		[2*bw-1:0]	product2	;
wire		[2*bw-1:0]	product3	;
wire		[2*bw-1:0]	product4	;
wire		[2*bw-1:0]	product5	;
wire		[2*bw-1:0]	product6	;
wire		[2*bw-1:0]	product7	;

assign product0 = product[bw*1*2-1:0];
assign product1 = product[bw*2*2-1:bw*1*2];
assign product2 = product[bw*3*2-1:bw*2*2];
assign product3 = product[bw*4*2-1:bw*3*2];
assign product4 = product[bw*5*2-1:bw*4*2];
assign product5 = product[bw*6*2-1:bw*5*2]; 
assign product6 = product[bw*7*2-1:bw*6*2]; 
assign product7 = product[bw*8*2-1:bw*7*2]; 

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

