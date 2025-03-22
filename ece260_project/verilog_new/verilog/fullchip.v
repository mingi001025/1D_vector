// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module fullchip (clk, mem_in, inst, out, reset);

parameter col = 8;
parameter bw = 8;
parameter bw_psum = 2*bw+3;
parameter pr = 16;

input  clk; 
input  [2*pr*bw-1:0] mem_in; 
input  [19:0] inst; 
input  reset;
output [2*col*bw_psum-1:0] out;
input out_wr;

wire [bw_psum+3:0] sum0;
wire [bw_psum+3:0] sum1;
wire [col*bw_psum-1:0] out0;
wire [col*bw_psum-1:0] out1;

assign out = (valid0 & valid1) ? {out0, out1} : 0;


core #(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) core_instance (
      .reset(reset), 
      .clk(clk), 
      .mem_in(mem_in[pr*bw-1:0]), 
      .inst(inst),
      .sum_in(sum1),
      .sum_out(sum0),
      .out(out0),
      .valid(valid0)
);

core #(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) core_instance1 (
      .reset(reset), 
      .clk(clk), 
      .mem_in(mem_in[2*pr*bw-1:pr*bw]), 
      .inst(inst),
      .sum_in(sum0),
      .sum_out(sum1),
      .out(out1),
      .valid(valid1)
      
);




endmodule
