`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 02:07:04 AM
// Design Name: 
// Module Name: memory_wrapper
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module memory_wrapper(a,d,dpra,clk,we,dpo);

input [8:0] a,dpra; //write address, read address
input [31:0] d; //write data
input clk,we;
output [31:0] dpo; //read data
     
dist_mem_gen_0 ins_memory(
  .a(a), 
  .d(d), 
  .dpra(dpra),
  .clk(clk),
  .we(we),
  .dpo(dpo)
);
endmodule

