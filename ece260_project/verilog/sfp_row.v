// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module sfp_row (clk, acc, div, fifo_ext_rd, sum_in, sum_out, sfp_in, sfp_out);

  parameter col = 8;
  parameter bw = 8;
  parameter bw_psum = 2*bw+4;

 
  input  clk, div, acc, fifo_ext_rd;
  input  [bw_psum+3:0] sum_in;
  input  [col*bw_psum-1:0] sfp_in;
  wire  [col*bw_psum-1:0] abs;
  reg    div_q;
  output [col*bw_psum-1:0] sfp_out;
  output [bw_psum+3:0] sum_out;
  wire [bw_psum+3:0] sum_this_core;
  wire signed [bw_psum-1:0] sum_2core;


  reg signed [bw_psum-1:0] sfp_out_0;
  reg signed [bw_psum-1:0] sfp_out_1;
  reg signed [bw_psum-1:0] sfp_out_2;
  reg signed [bw_psum-1:0] sfp_out_3;
  reg signed [bw_psum-1:0] sfp_out_4;
  reg signed [bw_psum-1:0] sfp_out_5;
  reg signed [bw_psum-1:0] sfp_out_6;
  reg signed [bw_psum-1:0] sfp_out_7;

  reg [bw_psum+3:0] sum_q;
  reg fifo_wr;



  assign sfp_out[bw_psum*1-1 : bw_psum*0] = sfp_out_0;
  assign sfp_out[bw_psum*2-1 : bw_psum*1] = sfp_out_1;
  assign sfp_out[bw_psum*3-1 : bw_psum*2] = sfp_out_2;
  assign sfp_out[bw_psum*4-1 : bw_psum*3] = sfp_out_3;
  assign sfp_out[bw_psum*5-1 : bw_psum*4] = sfp_out_4;
  assign sfp_out[bw_psum*6-1 : bw_psum*5] = sfp_out_5;
  assign sfp_out[bw_psum*7-1 : bw_psum*6] = sfp_out_6;
  assign sfp_out[bw_psum*8-1 : bw_psum*7] = sfp_out_7;


  assign sum_2core = sum_this_core[bw_psum+3:7] + sum_in[bw_psum+3:7];

  assign abs[bw_psum*1-1 : bw_psum*0] = (sfp_in[bw_psum*1-1]) ?  (~sfp_in[bw_psum*1-1 : bw_psum*0] + 1)  :  sfp_in[bw_psum*1-1 : bw_psum*0];
  assign abs[bw_psum*2-1 : bw_psum*1] = (sfp_in[bw_psum*2-1]) ?  (~sfp_in[bw_psum*2-1 : bw_psum*1] + 1)  :  sfp_in[bw_psum*2-1 : bw_psum*1];
  assign abs[bw_psum*3-1 : bw_psum*2] = (sfp_in[bw_psum*3-1]) ?  (~sfp_in[bw_psum*3-1 : bw_psum*2] + 1)  :  sfp_in[bw_psum*3-1 : bw_psum*2];
  assign abs[bw_psum*4-1 : bw_psum*3] = (sfp_in[bw_psum*4-1]) ?  (~sfp_in[bw_psum*4-1 : bw_psum*3] + 1)  :  sfp_in[bw_psum*4-1 : bw_psum*3];
  assign abs[bw_psum*5-1 : bw_psum*4] = (sfp_in[bw_psum*5-1]) ?  (~sfp_in[bw_psum*5-1 : bw_psum*4] + 1)  :  sfp_in[bw_psum*5-1 : bw_psum*4];
  assign abs[bw_psum*6-1 : bw_psum*5] = (sfp_in[bw_psum*6-1]) ?  (~sfp_in[bw_psum*6-1 : bw_psum*5] + 1)  :  sfp_in[bw_psum*6-1 : bw_psum*5];
  assign abs[bw_psum*7-1 : bw_psum*6] = (sfp_in[bw_psum*7-1]) ?  (~sfp_in[bw_psum*7-1 : bw_psum*6] + 1)  :  sfp_in[bw_psum*7-1 : bw_psum*6];
  assign abs[bw_psum*8-1 : bw_psum*7] = (sfp_in[bw_psum*8-1]) ?  (~sfp_in[bw_psum*8-1 : bw_psum*7] + 1)  :  sfp_in[bw_psum*8-1 : bw_psum*7];

  fifo_depth16 #(.bw(bw_psum+4)) fifo_inst_int (
     .rd_clk(clk), 
     .wr_clk(clk), 
     .in(sum_q),
     .out(sum_this_core), 
     .rd(div_q), 
     .wr(fifo_wr), 
     .reset(reset)
  );

  fifo_depth16 #(.bw(bw_psum+4)) fifo_inst_ext (
     .rd_clk(clk), 
     .wr_clk(clk), 
     .in(sum_q),
     .out(sum_out), 
     .rd(fifo_ext_rd), 
     .wr(fifo_wr), 
     .reset(reset)
  );

  always @ (posedge clk) begin

    if (reset) begin
      fifo_wr <= 0;
    end
    else begin
       div_q <= div ;
       if (acc) begin
      
         sum_q <= 
           {4'b0, abs[bw_psum*1-1 : bw_psum*0]} +
           {4'b0, abs[bw_psum*2-1 : bw_psum*1]} +
           {4'b0, abs[bw_psum*3-1 : bw_psum*2]} +
           {4'b0, abs[bw_psum*4-1 : bw_psum*3]} +
           {4'b0, abs[bw_psum*5-1 : bw_psum*4]} +
           {4'b0, abs[bw_psum*6-1 : bw_psum*5]} +
           {4'b0, abs[bw_psum*7-1 : bw_psum*6]} +
           {4'b0, abs[bw_psum*8-1 : bw_psum*7]} ;
         fifo_wr <= 1;
       end
       else begin
         fifo_wr <= 0;
   
         if (div) begin
           sfp_out_0 <= abs[bw_psum*1-1 : bw_psum*0] / sum_2core;
           sfp_out_1 <= abs[bw_psum*2-1 : bw_psum*1] / sum_2core;
           sfp_out_2 <= abs[bw_psum*3-1 : bw_psum*2] / sum_2core;
           sfp_out_3 <= abs[bw_psum*4-1 : bw_psum*3] / sum_2core;
           sfp_out_4 <= abs[bw_psum*5-1 : bw_psum*4] / sum_2core;
           sfp_out_5 <= abs[bw_psum*6-1 : bw_psum*5] / sum_2core;
           sfp_out_6 <= abs[bw_psum*7-1 : bw_psum*6] / sum_2core;
           sfp_out_7 <= abs[bw_psum*8-1 : bw_psum*7] / sum_2core;
           $display("%d %d %d %d %d %d %d %d, sum_2core %d",sfp_out_0,sfp_out_1,sfp_out_2,sfp_out_3,sfp_out_4,sfp_out_5, sfp_out_6, sfp_out_7, sum_2core);




         end
       end
   end
 end


endmodule
