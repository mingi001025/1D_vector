// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module sram_w8 (CLK, D, Q, CEN, WEN, A);

  parameter sram_bit = 128;
  input  CLK;
  input  WEN;
  input  CEN;
  input  [sram_bit-1:0] D;
  input  [2:0] A;
  output reg [sram_bit-1:0] Q;

  reg [sram_bit-1:0] memory0;
  reg [sram_bit-1:0] memory1;
  reg [sram_bit-1:0] memory2;
  reg [sram_bit-1:0] memory3;
  reg [sram_bit-1:0] memory4;
  reg [sram_bit-1:0] memory5;
  reg [sram_bit-1:0] memory6;
  reg [sram_bit-1:0] memory7;


/*
  assign Q = (add_q == 0)  ? memory0 : (
             (add_q == 1)  ? memory1 : (
             (add_q == 2)  ? memory2 : (
             (add_q == 3)  ? memory3 : (
             (add_q == 4)  ? memory4 : (
             (add_q == 5)  ? memory5 : (
             (add_q == 6)  ? memory6 : (
             (add_q == 7)  ? memory7 : (
             (add_q == 8)  ? memory8 : (
             (add_q == 9)  ? memory9 : (
             (add_q == 10) ? memory10 : (
             (add_q == 11) ? memory11 : (
             (add_q == 12) ? memory12 : (
             (add_q == 13) ? memory13 : (
             (add_q == 14) ? memory14 : memory15))))))))))))));
*/

  always @ (posedge CLK) begin

   if (!CEN && WEN) begin // read 
     case (A)
      4'b0000: Q <= memory0; 
      4'b0001: Q <= memory1; 
      4'b0010: Q <= memory2; 
      4'b0011: Q <= memory3; 
      4'b0100: Q <= memory4; 
      4'b0101: Q <= memory5; 
      4'b0110: Q <= memory6; 
      4'b0111: Q <= memory7; 
    endcase
   end

   else if (!CEN && !WEN) begin // write
     case (A)
      4'b0000: memory0  <= D; 
      4'b0001: memory1  <= D; 
      4'b0010: memory2  <= D; 
      4'b0011: memory3  <= D; 
      4'b0100: memory4  <= D; 
      4'b0101: memory5  <= D; 
      4'b0110: memory6  <= D; 
      4'b0111: memory7  <= D; 
    endcase
  end
end

endmodule
