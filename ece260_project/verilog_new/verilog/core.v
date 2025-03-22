// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module core (clk, sum_in, sum_out, mem_in, out, inst, reset, valid);

parameter col = 8;
parameter bw = 8;
parameter bw_psum = 2*bw+3;
parameter pr = 8;

output [bw_psum+3:0] sum_out;
output [bw_psum*col-1:0] out;
wire   [bw_psum*col-1:0] pmem_out;
input  [bw_psum+3:0] sum_in;
input  [pr*bw-1:0] mem_in;
input  clk;
input  [19:0] inst; 
input  reset;
output valid ;

assign valid = out_rd;
wire [bw_psum*col-1:0] out_sync;

wire  [pr*bw-1:0] mac_in;
wire  [pr*bw-1:0] kmem_out;
wire  [pr*bw-1:0] qmem_out;
wire  [bw_psum*col-1:0] pmem_in;
wire  [bw_psum*col-1:0] fifo_out;
wire  [bw_psum*col-1:0] sfp_out;
wire  [bw_psum*col-1:0] sfp_in;

wire  [bw_psum*col-1:0] array_out;
wire  [col-1:0] fifo_wr;
wire  ofifo_rd;
wire [3:0] qkmem_add;
wire [3:0] pmem_add;
wire [bw_psum+3:0] core_sum;
wire get_sum;

wire  qmem_rd;
wire  qmem_wr; 
wire  kmem_rd;
wire  kmem_wr; 
wire  pmem_rd;
wire  pmem_wr; 

assign get_sum = inst[19];
assign div = inst[18];
assign acc = inst[17];
assign ofifo_rd = inst[16];
assign qkmem_add = inst[15:12];
assign pmem_add = inst[11:8];

assign qmem_rd = inst[5];
assign qmem_wr = inst[4];
assign kmem_rd = inst[3];
assign kmem_wr = inst[2];
assign pmem_rd = inst[1];
assign pmem_wr = inst[0];

assign mac_in  = inst[6] ? kmem_out : qmem_out;
assign pmem_in = (div||acc) ? sfp_out : fifo_out;
assign sfp_in  = pmem_out;
assign out = out_sync;
assign sum_out = core_sum;

mac_array #(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) mac_array_instance (
        .in(mac_in), 
        .clk(clk), 
        .reset(reset), 
        .inst(inst[7:6]),     
        .fifo_wr(fifo_wr),     
	.out(array_out)
);

ofifo #(.bw(bw_psum), .col(col))  ofifo_inst (
        .reset(reset),
        .clk(clk),
        .in(array_out),
        .wr(fifo_wr),
        .rd(ofifo_rd),
        .o_valid(fifo_valid),
        .out(fifo_out)
);

sram_w16 #(.sram_bit(pr*bw)) qmem_instance (
        .CLK(clk),
        .D(mem_in),
        .Q(qmem_out),
        .CEN(!(qmem_rd||qmem_wr)),
        .WEN(!qmem_wr), 
        .A(qkmem_add)
);

sram_w16 #(.sram_bit(pr*bw)) kmem_instance (
        .CLK(clk),
        .D(mem_in),
        .Q(kmem_out),
        .CEN(!(kmem_rd||kmem_wr)),
        .WEN(!kmem_wr), 
        .A(qkmem_add)
);

sram_w16 #(.sram_bit(col*bw_psum)) psum_mem_instance (
        .CLK(clk),
        .D(pmem_in),
        .Q(pmem_out),
        .CEN(!(pmem_rd||pmem_wr)),
        .WEN(!pmem_wr), 
        .A(pmem_add)
);

sfp_row #(.col(col), .bw(bw), .bw_psum(bw_psum)) sfp_instance (
	.clk(clk),
	.div(div),
	.acc(acc),
	.fifo_ext_rd(get_sum),
	.sum_in(sum_in),
	.sum_out(core_sum),
	.sfp_in(sfp_in),
	.sfp_out(sfp_out),
	.reset(reset),
	.fifo_out_wr(fifo_out_wr)
);

  wire out_fifo_empty;
  reg out_rd;
  reg pmem_rd_q;

  fifo_depth8 #(.bw(bw_psum*col)) fifo_out_inst (
     .rd_clk(clk), 
     .wr_clk(clk), 
     .in(pmem_out),
     .out(out_sync), 
     .rd(out_rd), 
     .wr(fifo_out_wr&&pmem_rd_q), 
     .reset(reset),
    
     .o_empty(out_fifo_empty)
  );

  always @(posedge clk) begin
	  if(reset) 
		  out_rd <= 0;
	  else begin
		  out_rd <= fifo_out_wr && pmem_rd_q;
		  pmem_rd_q <= pmem_rd;
	  end
  end


endmodule
