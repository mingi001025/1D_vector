// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module fullchip (clk, mem_in, inst, out, reset);

parameter col = 8;
parameter bw = 8;
parameter bw_psum = 2*bw+4;
parameter pr = 8;

input  clk; 
input  [2*pr*bw-1:0] mem_in; 
input  [21:0] inst; 
input  reset;
output [2*col*bw_psum-1:0] out;

wire [bw_psum+3:0] sum0;
wire [bw_psum+3:0] sum1;
wire [col*bw_psum-1:0] out0;
wire [col*bw_psum-1:0] fifo_out0;
reg  [col*bw_psum-1:0] out0_q;
wire [col*bw_psum-1:0] out1;
wire [col*bw_psum-1:0] fifo_out1;
reg  [col*bw_psum-1:0] out1_q;

assign out = {fifo_out0, fifo_out1};


fifo_depth16 #(.bw(col*bw_psum)) fifo__out0_instance (
     .rd_clk(clk), 
     .wr_clk(clk), 
     .in(out0_q),
     .out(fifo_out0), 
     .rd(inst[20]), 
     .wr(inst[21]), 
     .reset(reset)
);

fifo_depth16 #(.bw(col*bw_psum)) fifo__out1_instance (
     .rd_clk(clk), 
     .wr_clk(clk), 
     .in(out1_q),
     .out(fifo_out1), 
     .rd(inst[20]), 
     .wr(inst[21]), 
     .reset(reset)
);

core #(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) core_instance (
      .reset(reset), 
      .clk(clk), 
      .mem_in(mem_in[pr*bw-1:0]), 
      .inst(inst[19:0]),
      .sum_in(sum1),
      .sum_out(sum0),
      .out(out0)
);

core #(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) core_instance1 (
      .reset(reset), 
      .clk(clk), 
      .mem_in(mem_in[2*pr*bw-1:pr*bw]), 
      .inst(inst[19:0]),
      .sum_in(sum0),
      .sum_out(sum1),
      .out(out1)
);

always@(posedge clk) begin
  out0_q <= out0;
  out1_q <= out1;
end


endmodule

