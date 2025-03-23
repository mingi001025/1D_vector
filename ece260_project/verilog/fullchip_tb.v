// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission

`timescale 1ns/1ps

`include "./verilog/defines.v"

module fullchip_tb;

parameter total_cycle = 8;   // how many streamed Q vectors will be processed
parameter bw = 8;            // Q & K vector bit precision
parameter bw_psum = 2*bw+3;  // partial sum bit precision
parameter pr = 8;           // how many products added in each dot product
parameter col = 8;           // how many dot product units are equipped

integer qk_file ; // file handler
integer qk_scan_file ; // file handler
// integer counter = 0; // to track elapsed clock cycles


integer  captured_data;
integer  weight [col*pr-1:0];
`define NULL 0




integer  K[col-1:0][2*pr-1:0];
integer  Q[total_cycle-1:0][pr-1:0];
integer  result[total_cycle-1:0][2*col-1:0];
integer  rtlResult[total_cycle-1:0][col-1:0];
integer  sum[total_cycle-1:0];

integer i,j,k,t,p,q,s,u, m;
reg signed [bw_psum-1:0] mask = 0;
integer temp = 0;

reg [7:0] tempHex = 0;





reg reset = 1;
reg clk = 0;
reg [2*pr*bw-1:0] mem_in;
reg ofifo_rd = 0;
wire [21:0] inst;
reg qmem_rd = 0;
reg qmem_wr = 0;
reg kmem_rd = 0;
reg kmem_wr = 0;
reg pmem_rd = 0;
reg pmem_wr = 0;
reg execute = 0;
reg load = 0;
reg [3:0] qkmem_add = 0;
reg [3:0] pmem_add = 0;
reg acc;
reg div;
reg fifo_ext_rd;
reg fifo_out_rd;
reg fifo_out_wr;

assign inst[21] = fifo_out_wr;
assign inst[20] = fifo_out_rd;
assign inst[19] = fifo_ext_rd;
assign inst[18] = div;
assign inst[17] = acc;
assign inst[16] = ofifo_rd;
assign inst[15:12] = qkmem_add;
assign inst[11:8]  = pmem_add;
assign inst[7] = execute;
assign inst[6] = load;
assign inst[5] = qmem_rd;
assign inst[4] = qmem_wr;
assign inst[3] = kmem_rd;
assign inst[2] = kmem_wr;
assign inst[1] = pmem_rd;
assign inst[0] = pmem_wr;



reg [27-1:0] sum_temp0;
reg [27-1:0] sum_temp1;
reg [bw_psum-1:0] temp5h;
reg [bw_psum+3:0] temp_sum;
reg [bw_psum*col-1:0] temp40h;
reg [bw_psum-1:0] abs_temp5h;
reg [bw_psum+7:0] est_out0;
reg [bw_psum+7:0] est_out1;
reg [bw_psum+7:0] est_out2;
reg [bw_psum+7:0] est_out3;
reg [bw_psum+7:0] est_out4;
reg [bw_psum+7:0] est_out5;
reg [bw_psum+7:0] est_out6;
reg [bw_psum+7:0] est_out7;
reg [bw_psum+7:0] est_out8;
reg [bw_psum+7:0] est_out9;
reg [bw_psum+7:0] est_out10;
reg [bw_psum+7:0] est_out11;
reg [bw_psum+7:0] est_out12;
reg [bw_psum+7:0] est_out13;
reg [bw_psum+7:0] est_out14;
reg [bw_psum+7:0] est_out15;
reg [2*col*bw_psum-1:0] est_out;
wire [2*col*bw_psum-1:0] rtl_out;



fullchip #(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) fullchip_instance (
      .reset(reset),
      .clk(clk),
      .mem_in(mem_in),
      .inst(inst),
      .out(rtl_out)
);


initial begin

  $dumpfile("fullchip_tb.vcd");
  $dumpvars(0,fullchip_tb);



///// Q data txt reading /////

$display("##### Q data txt reading #####");


  qk_file = $fopen("qdata.txt", "r");
 
  for (q=0; q<total_cycle; q=q+1) begin
    $write("Q%0d = [", q);
    for (j=0; j<pr; j=j+1) begin
          qk_scan_file = $fscanf(qk_file, "%d\n", captured_data);
          Q[q][j] = captured_data;
          $write("%d", Q[q][j]);
    end
    $write("] Hex: ");
    for (j=0; j<pr; j=j+1) begin
        tempHex = Q[q][j] & 'hff;    
        $write("%h", tempHex);
    end
    $display();
  end

/////////////////////////////////




  for (q=0; q<2; q=q+1) begin
    #0.5 clk = 1'b0;  
    #0.5 clk = 1'b1;  
  end




///// K data txt reading /////

$display("##### K data 0 txt reading #####");

  for (q=0; q<10; q=q+1) begin
    #0.5 clk = 1'b0;  
    #0.5 clk = 1'b1;  
  end
  reset = 0;

  qk_file = $fopen("kdata_core0.txt", "r");

  for (q=0; q<col; q=q+1) begin
    $write("K%0d = [", q);
    for (j=0; j<pr; j=j+1) begin
          qk_scan_file = $fscanf(qk_file, "%d\n", captured_data);
          K[q][j] = captured_data;
          $write("%d", K[q][j]);
    end
    $write("] Hex: ");
    for (j=0; j<pr; j=j+1) begin
        tempHex = K[q][j] & 'hff;    
        $write("%h", tempHex);
    end
    $display();
  end

$display("##### K data 1 txt reading #####");

  qk_file = $fopen("kdata_core1.txt", "r");

  for (q=0; q<col; q=q+1) begin
    $write("K%0d = [", q);
    for (j=0; j<pr; j=j+1) begin
          qk_scan_file = $fscanf(qk_file, "%d\n", captured_data);
          K[q][j+8] = captured_data;
          $write("%d", K[q][j+8]);
    end
    $write("] Hex: ");
    for (j=0; j<pr; j=j+1) begin
        tempHex = K[q][j+8] & 'hff;    
        $write("%h", tempHex);
    end
    $display();
  end
/////////////////////////////////








//// Qmem writing  /////

$display("##### Qmem writing  #####");

  for (q=0; q<total_cycle; q=q+1) begin

    #0.5 clk = 1'b0;  
    qmem_wr = 1;  if (q>0) qkmem_add = qkmem_add + 1;

    mem_in[1*bw-1:0*bw] = Q[q][0];
    mem_in[2*bw-1:1*bw] = Q[q][1];
    mem_in[3*bw-1:2*bw] = Q[q][2];
    mem_in[4*bw-1:3*bw] = Q[q][3];
    mem_in[5*bw-1:4*bw] = Q[q][4];
    mem_in[6*bw-1:5*bw] = Q[q][5];
    mem_in[7*bw-1:6*bw] = Q[q][6];
    mem_in[8*bw-1:7*bw] = Q[q][7];
    mem_in[9*bw-1:8*bw] = Q[q][0];
    mem_in[10*bw-1:9*bw] = Q[q][1];
    mem_in[11*bw-1:10*bw] = Q[q][2];
    mem_in[12*bw-1:11*bw] = Q[q][3];
    mem_in[13*bw-1:12*bw] = Q[q][4];
    mem_in[14*bw-1:13*bw] = Q[q][5];
    mem_in[15*bw-1:14*bw] = Q[q][6];
    mem_in[16*bw-1:15*bw] = Q[q][7];
/*
    $write("Q%0d = [", q);
    for (i=0; i<col; i=i+1) begin
      $write("%d", Q[q][i]);
    end
    $write(" |");
    for (i=0; i<col; i=i+1) begin
      $write("%d", Q[q][i]);
    end
    $display("]");
*/
    #0.5 clk = 1'b1;  

  end


  #0.5 clk = 1'b0;  
  qmem_wr = 0;
  qkmem_add = 0;
  #0.5 clk = 1'b1;  
///////////////////////////////////////////





///// Kmem writing  /////

$display("##### Kmem writing #####");

  for (q=0; q<col; q=q+1) begin

    #0.5 clk = 1'b0;  
    kmem_wr = 1; if (q>0) qkmem_add = qkmem_add + 1;
   
    mem_in[1*bw-1:0*bw] = K[q][0];
    mem_in[2*bw-1:1*bw] = K[q][1];
    mem_in[3*bw-1:2*bw] = K[q][2];
    mem_in[4*bw-1:3*bw] = K[q][3];
    mem_in[5*bw-1:4*bw] = K[q][4];
    mem_in[6*bw-1:5*bw] = K[q][5];
    mem_in[7*bw-1:6*bw] = K[q][6];
    mem_in[8*bw-1:7*bw] = K[q][7];
    mem_in[9*bw-1:8*bw] = K[q][8];
    mem_in[10*bw-1:9*bw] = K[q][9];
    mem_in[11*bw-1:10*bw] = K[q][10];
    mem_in[12*bw-1:11*bw] = K[q][11];
    mem_in[13*bw-1:12*bw] = K[q][12];
    mem_in[14*bw-1:13*bw] = K[q][13];
    mem_in[15*bw-1:14*bw] = K[q][14];
    mem_in[16*bw-1:15*bw] = K[q][15];
/*
    $write("K%0d = [", q);
    for (i=0; i<col; i=i+1) begin
      $write("%d", K[q][i]);
    end
    $write(" |");
    for (i=0; i<col; i=i+1) begin
      $write("%d", K[q][i+8]);
    end
    $display("]");
*/
    #0.5 clk = 1'b1;  

  end

  #0.5 clk = 1'b0;  
  kmem_wr = 0;  
  qkmem_add = 0;
  #0.5 clk = 1'b1;  
///////////////////////////////////////////



  for (q=0; q<2; q=q+1) begin
    #0.5 clk = 1'b0;  
    #0.5 clk = 1'b1;  
  end


div = 0;
acc = 0;

/////  K data loading  /////
$display("##### K data loading to processor #####");

  for (q=0; q<col+1; q=q+1) begin
    #0.5 clk = 1'b0;  
    load = 1;
    if (q==1) kmem_rd = 1;
    if (q>1) begin
       qkmem_add = qkmem_add + 1;
    end

    #0.5 clk = 1'b1;  
  end

  #0.5 clk = 1'b0;  
  kmem_rd = 0; qkmem_add = 0;
  #0.5 clk = 1'b1;  

  #0.5 clk = 1'b0;  
  load = 0;
  #0.5 clk = 1'b1;  

///////////////////////////////////////////

 for (q=0; q<10; q=q+1) begin
    #0.5 clk = 1'b0;  
    #0.5 clk = 1'b1;  
 end





///// execution  /////
$display("##### execute #####");

  for (q=0; q<total_cycle; q=q+1) begin
    #0.5 clk = 1'b0;  
    execute = 1;
    qmem_rd = 1;

    if (q>0) begin
       qkmem_add = qkmem_add + 1;
    end

    #0.5 clk = 1'b1;  
  end

  #0.5 clk = 1'b0;  
  qmem_rd = 0; qkmem_add = 0; execute = 0;
  #0.5 clk = 1'b1;  


///////////////////////////////////////////

 for (q=0; q<10; q=q+1) begin
    #0.5 clk = 1'b0;  
    #0.5 clk = 1'b1;  
 end




////////////// output fifo rd and wb to psum mem ///////////////////

$display("##### move ofifo to pmem #####");

  for (q=0; q<total_cycle; q=q+1) begin
    #0.5 clk = 1'b0;  
    ofifo_rd = 1;
    pmem_wr = 1;

    if (q>0) begin
       pmem_add = pmem_add + 1;
    end

    #0.5 clk = 1'b1;  
  end

  #0.5 clk = 1'b0;  
  pmem_wr = 0; pmem_add = 0; ofifo_rd = 0;
  #0.5 clk = 1'b1;  

///////////////////////////////////////////

// assign get_sum = inst[19];
// assign div = inst[18];
// assign acc = inst[17];
$display("##### division in SFP #####");

#0.5 clk = 1'b0;  

for (q=0; q<total_cycle; q=q+1) begin

  #0.5 clk = 1'b1;  #0.5 clk = 1'b0;//pmem_shift, fifo_ext_rd
  div = 0;
  pmem_rd = 1;
  pmem_wr = 0;
  fifo_ext_rd = 0;
 
  #0.5 clk = 1'b1; #0.5 clk = 1'b0; //pmem_rd
  acc = 1;

  #0.5 clk = 1'b1; #0.5 clk = 1'b0; //pmem_rd, acc
  acc = 0;

  #0.5 clk = 1'b1; #0.5 clk = 1'b0; //pmem_rd
  div = 1;

  #0.5 clk = 1'b1; #0.5 clk = 1'b0;//pmem_rd, div
  pmem_rd = 0;
  pmem_wr = 1;
 
  #0.5 clk = 1'b1; #0.5 clk = 1'b0; //pmem_wr
  pmem_wr = 0;
  pmem_add = pmem_add + 1;
  fifo_ext_rd = 1;//fifo_ext_rd
 

end

$display("##### output from chip #####");

#0.5 clk = 1'b0;  
pmem_add = 0; div = 0;
#0.5 clk = 1'b1; #0.5 clk = 1'b0;
pmem_rd = 1; #0.5 clk = 1'b1; #0.5 clk = 1'b0;
pmem_add = pmem_add + 1;
//$display("cycle 0: %40h", rtl_out);
#0.5 clk = 1'b1; #0.5 clk = 1'b0;
<<<<<<< Updated upstream
for (t=0; t<total_cycle; t=t+1) begin
  #0.5 clk = 1'b1; #0.5 clk = 1'b0;
  if (t>0) begin
    fifo_out_wr = 1;
  end
  pmem_add = pmem_add + 1;
end
pmem_rd = 0;
pmem_wr = 0;
#0.5 clk = 1'b1;  #0.5 clk = 1'b0;
#0.5 clk = 1'b1;  #0.5 clk = 1'b0;
#0.5 clk = 1'b1;  #0.5 clk = 1'b0;
fifo_out_rd = 1;
fifo_out_wr = 0;
  $display("cycle 0: %40h", rtl_out);
#0.5 clk = 1'b1;  #0.5 clk = 1'b0;
  $display("cycle 1: %40h", rtl_out);
#0.5 clk = 1'b1;  #0.5 clk = 1'b0;
  $display("cycle 2: %40h", rtl_out);
#0.5 clk = 1'b1;  #0.5 clk = 1'b0;
  $display("cycle 3: %40h", rtl_out);
#0.5 clk = 1'b1;  #0.5 clk = 1'b0;
  $display("cycle 4: %40h", rtl_out);
#0.5 clk = 1'b1;  #0.5 clk = 1'b0;
  $display("cycle 5: %40h", rtl_out);
#0.5 clk = 1'b1;  #0.5 clk = 1'b0;
  $display("cycle 6: %40h", rtl_out);
#0.5 clk = 1'b1;  #0.5 clk = 1'b0;
  $display("cycle 7: %40h", rtl_out);
fifo_out_rd = 0;
=======
pmem_add = pmem_add + 1;
$display("cycle 0: %40h", rtl_out);
#0.5 clk = 1'b1; #0.5 clk = 1'b0;
pmem_add = pmem_add + 1;
$display("cycle 1: %40h", rtl_out);
#0.5 clk = 1'b1; #0.5 clk = 1'b0;
pmem_add = pmem_add + 1;
$display("cycle 2: %40h", rtl_out);
#0.5 clk = 1'b1; #0.5 clk = 1'b0;
pmem_add = pmem_add + 1;
$display("cycle 3: %40h", rtl_out);
#0.5 clk = 1'b1; #0.5 clk = 1'b0;
pmem_add = pmem_add + 1;
$display("cycle 4: %40h", rtl_out);
#0.5 clk = 1'b1; #0.5 clk = 1'b0;
pmem_add = pmem_add + 1;
$display("cycle 5: %40h", rtl_out);
#0.5 clk = 1'b1; #0.5 clk = 1'b0;
$display("cycle 6: %40h", rtl_out);
pmem_rd = 0;
#0.5 clk = 1'b1; #0.5 clk = 1'b0;
$display("cycle 7: %40h", rtl_out);

>>>>>>> Stashed changes
#0.5 clk = 1'b1;  #0.5 clk = 1'b0;
pmem_add = 0; reset = 1;
#0.5 clk = 1'b1;  #0.5 clk = 1'b0;
reset = 0;






/////////////// Estimated result printing /////////////////

$display("##### Estimated multiplication result #####");

  for (t=0; t<total_cycle; t=t+1) begin
     for (q=0; q<col*2; q=q+1) begin
       result[t][q] = 0;
     end
  end

  for (t=0; t<total_cycle; t=t+1) begin
     sum_temp0 = 0;
     sum_temp1 = 0;
     for (q=0; q<col; q=q+1) begin//core0
         for (k=0; k<pr; k=k+1) begin
            result[t][q] = result[t][q] + Q[t][k] * K[q][k];
         end

         temp5h = result[t][q];//Qt*Kq (Q0*K0)
         temp40h = {temp40h[139:0], temp5h};
abs_temp5h = temp5h[bw_psum-1] ? ~temp5h[bw_psum-1:0] + 1 : temp5h[bw_psum-1:0]; //absolute value
//$display("core0 cycle%d val: %5h %5h %7h", q, result[t][q], abs_temp5h, sum_temp0);
sum_temp0 = sum_temp0 + abs_temp5h;//core0 sum
result[t][q] = abs_temp5h;
     end
     for (q=0; q<col; q=q+1) begin//core1
         for (k=0; k<pr; k=k+1) begin
            result[t][q+8] = result[t][q+8] + Q[t][k] * K[q][k+8];
         end

         temp5h = result[t][q+8];//Qt*Kq (Q0*K0)
         temp40h = {temp40h[139:0], temp5h};
abs_temp5h = temp5h[bw_psum-1] ? ~temp5h[bw_psum-1:0] + 1 : temp5h[bw_psum-1:0]; //absolute value
//$display("core1 cycle%d val: %5h %5h %7h", q, result[t][q+8], abs_temp5h, sum_temp1);
sum_temp1 = sum_temp1 + abs_temp5h;//core1 sum
result[t][q+8] = abs_temp5h;
     end
     #0.5 clk = 1'b1; #0.5 clk = 1'b0;
     //$display("@cycle%2d: %40h, sum: %d", t, temp40h, sum_temp0+sum_temp1);//before normalization
     est_out0 = (result[t][0]<<8) / (sum_temp0+sum_temp1);
     est_out1 = (result[t][1]<<8) / (sum_temp0+sum_temp1);
     est_out2 = (result[t][2]<<8) / (sum_temp0+sum_temp1);
     est_out3 = (result[t][3]<<8) / (sum_temp0+sum_temp1);
     est_out4 = (result[t][4]<<8) / (sum_temp0+sum_temp1);
     est_out5 = (result[t][5]<<8) / (sum_temp0+sum_temp1);
     est_out6 = (result[t][6]<<8) / (sum_temp0+sum_temp1);
     est_out7 = (result[t][7]<<8) / (sum_temp0+sum_temp1);
     est_out8 = (result[t][8]<<8) / (sum_temp0+sum_temp1);
     est_out9 = (result[t][9]<<8) / (sum_temp0+sum_temp1);
     est_out10 = (result[t][10]<<8) / (sum_temp0+sum_temp1);
     est_out11 = (result[t][11]<<8) / (sum_temp0+sum_temp1);
     est_out12 = (result[t][12]<<8) / (sum_temp0+sum_temp1);
     est_out13 = (result[t][13]<<8) / (sum_temp0+sum_temp1);
     est_out14 = (result[t][14]<<8) / (sum_temp0+sum_temp1);
     est_out15 = (result[t][15]<<8) / (sum_temp0+sum_temp1);
     $display("normalized: %5h %5h %5h %5h %5h %5h %5h %5h %5h %5h %5h %5h %5h %5h %5h %5h", est_out0, est_out1, est_out2, est_out3, est_out4, est_out5, est_out6, est_out7, est_out8, est_out9, est_out10, est_out11, est_out12, est_out13, est_out14, est_out15);//after normalization
  end


//////////////////////////////////////////////



///// v data txt reading /////

$display("##### value data txt reading #####");


  qk_file = $fopen("vdata.txt", "r");
 
  for (q=0; q<total_cycle; q=q+1) begin
    $write("Q%0d = [", q);
    for (j=0; j<pr; j=j+1) begin
          qk_scan_file = $fscanf(qk_file, "%d\n", captured_data);
          Q[q][j] = captured_data;
          $write("%d", Q[q][j]);
    end
    $write("] Hex: ");
    for (j=0; j<pr; j=j+1) begin
        tempHex = Q[q][j] & 'hff;    
        $write("%h", tempHex);
    end
    $display();
  end

/////////////////////////////////




  for (q=0; q<2; q=q+1) begin
    #0.5 clk = 1'b0;  
    #0.5 clk = 1'b1;  
  end




///// norm data txt reading /////

$display("##### norm data 0 txt reading #####");

  for (q=0; q<10; q=q+1) begin
    #0.5 clk = 1'b0;  
    #0.5 clk = 1'b1;  
  end
  reset = 0;

  qk_file = $fopen("norm_core0.txt", "r");

  for (q=0; q<col; q=q+1) begin
    $write("K%0d = [", q);
    for (j=0; j<pr; j=j+1) begin
          qk_scan_file = $fscanf(qk_file, "%d\n", captured_data);
          K[q][j] = captured_data;
          $write("%d", K[q][j]);
    end
    $write("] Hex: ");
    for (j=0; j<pr; j=j+1) begin
        tempHex = K[q][j] & 'hff;    
        $write("%h", tempHex);
    end
    $display();
  end

$display("##### norm data 1 txt reading #####");

  qk_file = $fopen("norm_core1.txt", "r");

  for (q=0; q<col; q=q+1) begin
    $write("K%0d = [", q);
    for (j=0; j<pr; j=j+1) begin
          qk_scan_file = $fscanf(qk_file, "%d\n", captured_data);
          K[q][j+8] = captured_data;
          $write("%d", K[q][j+8]);
    end
    $write("] Hex: ");
    for (j=0; j<pr; j=j+1) begin
        tempHex = K[q][j+8] & 'hff;    
        $write("%h", tempHex);
    end
    $display();
  end
/////////////////////////////////








//// Qmem writing  /////

$display("##### Qmem writing  #####");

  for (q=0; q<total_cycle; q=q+1) begin

    #0.5 clk = 1'b0;  
    qmem_wr = 1;  if (q>0) qkmem_add = qkmem_add + 1;

    mem_in[1*bw-1:0*bw] = Q[q][0];
    mem_in[2*bw-1:1*bw] = Q[q][1];
    mem_in[3*bw-1:2*bw] = Q[q][2];
    mem_in[4*bw-1:3*bw] = Q[q][3];
    mem_in[5*bw-1:4*bw] = Q[q][4];
    mem_in[6*bw-1:5*bw] = Q[q][5];
    mem_in[7*bw-1:6*bw] = Q[q][6];
    mem_in[8*bw-1:7*bw] = Q[q][7];
    mem_in[9*bw-1:8*bw] = Q[q][0];
    mem_in[10*bw-1:9*bw] = Q[q][1];
    mem_in[11*bw-1:10*bw] = Q[q][2];
    mem_in[12*bw-1:11*bw] = Q[q][3];
    mem_in[13*bw-1:12*bw] = Q[q][4];
    mem_in[14*bw-1:13*bw] = Q[q][5];
    mem_in[15*bw-1:14*bw] = Q[q][6];
    mem_in[16*bw-1:15*bw] = Q[q][7];
/*
    $write("Q%0d = [", q);
    for (i=0; i<col; i=i+1) begin
      $write("%d", Q[q][i]);
    end
    $write(" |");
    for (i=0; i<col; i=i+1) begin
      $write("%d", Q[q][i]);
    end
    $display("]");
*/
    #0.5 clk = 1'b1;  

  end


  #0.5 clk = 1'b0;  
  qmem_wr = 0;
  qkmem_add = 0;
  #0.5 clk = 1'b1;  
///////////////////////////////////////////





///// Kmem writing  /////

$display("##### Kmem writing #####");

  for (q=0; q<col; q=q+1) begin

    #0.5 clk = 1'b0;  
    kmem_wr = 1; if (q>0) qkmem_add = qkmem_add + 1;
   
    mem_in[1*bw-1:0*bw] = K[q][0];
    mem_in[2*bw-1:1*bw] = K[q][1];
    mem_in[3*bw-1:2*bw] = K[q][2];
    mem_in[4*bw-1:3*bw] = K[q][3];
    mem_in[5*bw-1:4*bw] = K[q][4];
    mem_in[6*bw-1:5*bw] = K[q][5];
    mem_in[7*bw-1:6*bw] = K[q][6];
    mem_in[8*bw-1:7*bw] = K[q][7];
    mem_in[9*bw-1:8*bw] = K[q][8];
    mem_in[10*bw-1:9*bw] = K[q][9];
    mem_in[11*bw-1:10*bw] = K[q][10];
    mem_in[12*bw-1:11*bw] = K[q][11];
    mem_in[13*bw-1:12*bw] = K[q][12];
    mem_in[14*bw-1:13*bw] = K[q][13];
    mem_in[15*bw-1:14*bw] = K[q][14];
    mem_in[16*bw-1:15*bw] = K[q][15];
/*
    $write("K%0d = [", q);
    for (i=0; i<col; i=i+1) begin
      $write("%d", K[q][i]);
    end
    $write(" |");
    for (i=0; i<col; i=i+1) begin
      $write("%d", K[q][i+8]);
    end
    $display("]");
*/
    #0.5 clk = 1'b1;  

  end

  #0.5 clk = 1'b0;  
  kmem_wr = 0;  
  qkmem_add = 0;
  #0.5 clk = 1'b1;  
///////////////////////////////////////////



  for (q=0; q<2; q=q+1) begin
    #0.5 clk = 1'b0;  
    #0.5 clk = 1'b1;  
  end


div = 0;
acc = 0;

/////  K data loading  /////
$display("##### K data loading to processor #####");

  for (q=0; q<col+1; q=q+1) begin
    #0.5 clk = 1'b0;  
    load = 1;
    if (q==1) kmem_rd = 1;
    if (q>1) begin
       qkmem_add = qkmem_add + 1;
    end

    #0.5 clk = 1'b1;  
  end

  #0.5 clk = 1'b0;  
  kmem_rd = 0; qkmem_add = 0;
  #0.5 clk = 1'b1;  

  #0.5 clk = 1'b0;  
  load = 0;
  #0.5 clk = 1'b1;  

///////////////////////////////////////////

 for (q=0; q<10; q=q+1) begin
    #0.5 clk = 1'b0;  
    #0.5 clk = 1'b1;  
 end





///// execution  /////
$display("##### execute #####");

  for (q=0; q<total_cycle; q=q+1) begin
    #0.5 clk = 1'b0;  
    execute = 1;
    qmem_rd = 1;

    if (q>0) begin
       qkmem_add = qkmem_add + 1;
    end

    #0.5 clk = 1'b1;  
  end

  #0.5 clk = 1'b0;  
  qmem_rd = 0; qkmem_add = 0; execute = 0;
  #0.5 clk = 1'b1;  


///////////////////////////////////////////

 for (q=0; q<10; q=q+1) begin
    #0.5 clk = 1'b0;  
    #0.5 clk = 1'b1;  
 end




////////////// output fifo rd and wb to psum mem ///////////////////

$display("##### move ofifo to pmem #####");

  for (q=0; q<total_cycle; q=q+1) begin
    #0.5 clk = 1'b0;  
    ofifo_rd = 1;
    pmem_wr = 1;

    if (q>0) begin
       pmem_add = pmem_add + 1;
    end

    #0.5 clk = 1'b1;  
  end

  #0.5 clk = 1'b0;  
  pmem_wr = 0; pmem_add = 0; ofifo_rd = 0;
  #0.5 clk = 1'b1;  

//////////////////////////////////////////////////////

$display("##### output from chip #####");

#0.5 clk = 1'b0;  
pmem_add = 0; div = 0;
#0.5 clk = 1'b1; #0.5 clk = 1'b0;
<<<<<<< Updated upstream
for (t=0; t<total_cycle; t=t+1) begin
  #0.5 clk = 1'b1; #0.5 clk = 1'b0;
  if (t>0) begin
    fifo_out_wr = 1;
  end
  pmem_add = pmem_add + 1;
end
=======
pmem_rd = 1; #0.5 clk = 1'b1; #0.5 clk = 1'b0;
pmem_add = pmem_add + 1;
$display("cycle 0: %40h", rtl_out);
#0.5 clk = 1'b1; #0.5 clk = 1'b0;
pmem_add = pmem_add + 1;
$display("cycle 1: %40h", rtl_out);
#0.5 clk = 1'b1; #0.5 clk = 1'b0;
pmem_add = pmem_add + 1;
$display("cycle 2: %40h", rtl_out);
#0.5 clk = 1'b1; #0.5 clk = 1'b0;
pmem_add = pmem_add + 1;
$display("cycle 3: %40h", rtl_out);
#0.5 clk = 1'b1; #0.5 clk = 1'b0;
pmem_add = pmem_add + 1;
$display("cycle 4: %40h", rtl_out);
#0.5 clk = 1'b1; #0.5 clk = 1'b0;
pmem_add = pmem_add + 1;
$display("cycle 5: %40h", rtl_out);
#0.5 clk = 1'b1; #0.5 clk = 1'b0;
pmem_add = pmem_add + 1;
$display("cycle 6: %40h", rtl_out);
#0.5 clk = 1'b1; #0.5 clk = 1'b0;
$display("cycle 7: %40h", rtl_out);
>>>>>>> Stashed changes
pmem_rd = 0;
pmem_wr = 0;
#0.5 clk = 1'b1;  #0.5 clk = 1'b0;
#0.5 clk = 1'b1;  #0.5 clk = 1'b0;
#0.5 clk = 1'b1;  #0.5 clk = 1'b0;
fifo_out_rd = 1;
fifo_out_wr = 0;
  $display("cycle 0: %40h", rtl_out);
#0.5 clk = 1'b1;  #0.5 clk = 1'b0;
  $display("cycle 1: %40h", rtl_out);
#0.5 clk = 1'b1;  #0.5 clk = 1'b0;
  $display("cycle 2: %40h", rtl_out);
#0.5 clk = 1'b1;  #0.5 clk = 1'b0;
  $display("cycle 3: %40h", rtl_out);
#0.5 clk = 1'b1;  #0.5 clk = 1'b0;
  $display("cycle 4: %40h", rtl_out);
#0.5 clk = 1'b1;  #0.5 clk = 1'b0;
  $display("cycle 5: %40h", rtl_out);
#0.5 clk = 1'b1;  #0.5 clk = 1'b0;
  $display("cycle 6: %40h", rtl_out);
#0.5 clk = 1'b1;  #0.5 clk = 1'b0;
  $display("cycle 7: %40h", rtl_out);
fifo_out_rd = 0;
#0.5 clk = 1'b1;  #0.5 clk = 1'b0;
pmem_add = 0; reset = 1;
#0.5 clk = 1'b1;  #0.5 clk = 1'b0;
reset = 0;


/////////////// Estimated norm * value printing /////////////////

$display("##### Estimated norm*value multiplication result #####");

  for (t=0; t<total_cycle; t=t+1) begin
     for (q=0; q<col*2; q=q+1) begin
       result[t][q] = 0;
     end
  end

  for (t=0; t<total_cycle; t=t+1) begin
     sum_temp0 = 0;
     sum_temp1 = 0;
     for (q=0; q<col; q=q+1) begin//core0
         for (k=0; k<pr; k=k+1) begin
            result[t][q] = result[t][q] + Q[t][k] * K[q][k];
         end
     end
     for (q=0; q<col; q=q+1) begin//core1
         for (k=0; k<pr; k=k+1) begin
            result[t][q+8] = result[t][q+8] + Q[t][k] * K[q][k+8];
         end
     end
     #0.5 clk = 1'b1; #0.5 clk = 1'b0;
     $display("cycle%d: %5h %5h %5h %5h %5h %5h %5h %5h %5h %5h %5h %5h %5h %5h %5h %5h", t, result[t][0],result[t][1], result[t][2], result[t][3], result[t][4], result[t][5], result[t][6], result[t][7], result[t][8], result[t][9], result[t][10], result[t][11], result[t][12], result[t][13], result[t][14],result[t][15]);
  end


//////////////////////////////////////////////


#10 $finish;

end


// always@(posedge clk) begin
//   counter = counter + 1; // To keep track of clock cycles elapsed
// end

// //////////// For printing purpose ////////////
//   always @(posedge clk) begin
//       if(fullchip_tb.fullchip_instance.core_instance.pmem_wr) begin
//           $write("Memory write to PSUM mem add %x Hex: %x -> Dec: [", `core.pmem_add, `core.pmem_in);
//  temp = pr;
//    repeat(pr) begin
//      mask = (`core.pmem_in >> (temp-1)*bw_psum) & ({bw_psum{1'b1}});
//      $write("%d ", mask);
//      temp = temp - 1;
//  end
//  $display("]");
//       end
//   end

endmodule
