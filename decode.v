`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 02:43:49 AM
// Design Name: 
// Module Name: instruction_decode
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Decodes 32-bit instruction into type and ALU operation code
// 
//////////////////////////////////////////////////////////////////////////////////
module instruction_decode(instruction, type, op, fp_op, rs, rt, rd, shamt, imm, address, r0, f0, f1, f2);
   input [31:0] instruction;
   output [1:0] type;   // 0 = R-type, 1 = I-type, 2 = J-type
   output [4:0] op;     // What is the operation?
   output [3:0] fp_op;
   output [4:0] rs, rt, rd;
   output [9:0] shamt;
   output [15:0] imm;
   output [28:0] address;
   
   output [4:0] r0;
   output [4:0] f0, f1, f2;
   
   assign type = instruction[31:30];
   assign op = (type == 2'd2) ? {4'd0,instruction[29]} : (type == 2'd3) ? {1'b0, instruction[29:26]} : instruction[29:25];
   
   //R-type instructions
   assign rs = (type == 2'd0 || type == 2'd1) ? instruction[24:20] : 5'd0;
   assign rt = (type == 2'd0 || type == 2'd1) ? instruction[19:15] : 5'd0;
   assign rd = (type == 2'd0) ? instruction[14:10] : 5'd0;
   assign shamt = (type == 2'd0) ? instruction[9:0] : 5'd0;
   
   //I-type instructions
   assign imm = (type == 2'd1) ? instruction[14:0] : 15'd0;
   
   //J-type instructions
   assign address = (type == 2'd2) ? instruction[28:0] : 29'd0;
   
   //FP instructions decoding
   assign fp_op = (type == 2'd3) ? instruction[29:26] : 4'd0;
   assign r0 = (type == 2'd3) ? instruction[25:21] : 5'd0;
   assign f0 = (type == 2'd3) ? instruction[20:16] : 5'd0;
   assign f1 = (type == 2'd3) ? instruction[15:11] : 5'd0;
   assign f2 = (type == 2'd3) ? instruction[10:6] : 5'd0;
   
endmodule