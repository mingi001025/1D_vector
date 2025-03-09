// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 

`timescale 1ns/1ps

`include "./verilog/defines.v"

module fullchip_tb;

parameter total_cycle = 8;   // how many streamed Q vectors will be processed
parameter bw = 8;            // Q & K vector bit precision
parameter bw_psum = 2*bw+4;  // partial sum bit precision
parameter pr = 8;           // how many products added in each dot product 
parameter col = 8;           // how many dot product units are equipped

integer qk_file ; // file handler
integer qk_scan_file ; // file handler
// integer counter = 0; // to track elapsed clock cycles


integer  captured_data;
integer  weight [col*pr-1:0];
`define NULL 0




integer  K[col-1:0][pr-1:0];
integer  Q[total_cycle-1:0][pr-1:0];
integer  result[total_cycle-1:0][col-1:0];
integer  rtlResult[total_cycle-1:0][col-1:0];
integer  sum[total_cycle-1:0];

integer i,j,k,t,p,q,s,u, m;
reg signed [bw_psum-1:0] mask = 0;
integer temp = 0;

reg [7:0] tempHex = 0;





reg reset = 1;
reg clk = 0;
reg [pr*bw-1:0] mem_in; 
reg ofifo_rd = 0;
wire [19:0] inst; 
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
reg get_sum;

assign inst[19] = get_sum;
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



reg [bw_psum-1:0] temp5b;
reg [bw_psum+3:0] temp_sum;
reg [bw_psum*col-1:0] temp16b;



fullchip #(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) fullchip_instance (
      .reset(reset),
      .clk(clk), 
      .mem_in(mem_in), 
      .inst(inst)
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

$display("##### K data txt reading #####");

  for (q=0; q<10; q=q+1) begin
    #0.5 clk = 1'b0;   
    #0.5 clk = 1'b1;   
  end
  reset = 0;

  qk_file = $fopen("kdata.txt", "r");

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
/////////////////////////////////








// /////////////// Estimated result printing /////////////////


// $display("##### Estimated multiplication result #####");

//   for (t=0; t<total_cycle; t=t+1) begin
//      for (q=0; q<col; q=q+1) begin
//        result[t][q] = 0;
//      end
//   end

//   for (t=0; t<total_cycle; t=t+1) begin
//      for (q=0; q<col; q=q+1) begin
//          for (k=0; k<pr; k=k+1) begin
//             result[t][q] = result[t][q] + Q[t][k] * K[q][k];
//          end

//          //temp5b = result[t][q];
//          //temp16b = {temp16b[139:0], temp5b};
//      end

//      //$display("%d %d %d %d %d %d %d %d", result[t][0], result[t][1], result[t][2], result[t][3], result[t][4], result[t][5], result[t][6], result[t][7]);
//      $write("prd @cycle%2d: Q%0d*K[n] = [", t, t);
//      for (q=0; q<col; q=q+1) begin
// 	$write("%d ", result[t][q]);	
//      end
//      $display("]");
//   end

// //////////////////////////////////////////////

/////////////// Estimated result printing /////////////////


$display("##### Estimated multiplication result #####");

  for (t=0; t<total_cycle; t=t+1) begin
     for (q=0; q<col; q=q+1) begin
       result[t][q] = 0;
     end
  end

  for (t=0; t<total_cycle; t=t+1) begin
     sum[t] = 0;
     for (q=0; q<col; q=q+1) begin
         for (k=0; k<pr; k=k+1) begin
            result[t][q] = result[t][q] + Q[t][k] * K[q][k];
         end

         temp5b = result[t][q];//Qt*Kq (Q0*K0)
         temp16b = {temp16b[139:0], temp5b};
	        abs_temp5b = temp5b[bw_psum-1] ? ~temp5b[bw_psum-1:0] + 1 : temp5b[bw_psum-1:0]; //absolute value
	        sum[t] = sum[t] + temp5b;//sum for normalization
     end
     
     $display("prd @cycle%2d: %40h", t, temp16b);//before normalization
     for (q=0; q<col; q=q+1) begin
	      result[t][q] = {result[t][q], 8'b00000000} / sum[t];
     end
     $display("normalized: %5h %5h %5h %5h %5h %5h %5h %5h", result[t][0], result[t][1], result[t][2], result[t][3], result[t][4], result[t][5], result[t][6], result[t][7]);//after normalization
  end

	  


//////////////////////////////////////////////






///// Qmem writing  /////

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

    // $write("Clock Cycle = %0d: Q%0d = [", counter, q);
    for (i=0; i<col; i=i+1) begin
      $write("%d", Q[q][i]);	
    end
    $display("]"); 

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

    // $write("Clock Cycle = %0d: K%0d = [", counter, q);
    for (i=0; i<col; i=i+1) begin
      $write("%d", K[q][i]);	
    end
    $display("]");

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


for (q=0; q<total_cycle; q=q+1) begin
  #0.5 clk = 1'b0;  
  acc = 1;
  pmem_rd = 1;
  #0.5 clk = 1'b1;  
  #0.5 clk = 1'b0;  
  pmem_add = pmem_add + 1;
  pmem_rd = 0;
  div = 1;
  acc = 0;
  #0.5 clk = 1'b1;  
end

#0.5 clk = 1'b0;  
div = 0; pmem_add = 0;
#0.5 clk = 1'b1;  


#10 $finish;

end


// always@(posedge clk) begin
//   counter = counter + 1; // To keep track of clock cycles elapsed
// end

// //////////// For printing purpose ////////////
//   always @(posedge clk) begin
//       if(fullchip_tb.fullchip_instance.core_instance.pmem_wr) begin
//           $write("Memory write to PSUM mem add %x Hex: %x -> Dec: [", `core.pmem_add, `core.pmem_in);
// 	  temp = pr; 
//  	  repeat(pr) begin
// 	      mask = (`core.pmem_in >> (temp-1)*bw_psum) & ({bw_psum{1'b1}}); 
// 	      $write("%d ", mask);
// 	      temp = temp - 1;
// 	  end
// 	  $display("]");
//       end
//   end

endmodule




