`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 03:19:49 PM
// Design Name: 
// Module Name: register_file
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
module regfile(clk, rst, we, add1, add2, w_add, data, data1, data2, gen_to_fp, fp_to_gen, fp_gen_transfer);
    input clk, rst, we;
    input wire [4:0] add1, add2, w_add;
    input [31:0] data;
    input gen_to_fp, fp_to_gen;
    output [31:0] data1, data2;
    inout [31:0] fp_gen_transfer;
    
    reg [31:0] register [31:0]; //register[0] is $zero
    
    assign data1 = (add1 == 0) ? 32'b0 : register[add1];
    assign data2 = (add2 == 0) ? 32'b0 : register[add2];
    
    assign fp_gen_transfer = (gen_to_fp) ? register[add1] : 32'bz;
    
    integer i;
    
    always @(posedge clk) begin
        if(rst) begin
            for(i=0; i<32; i=i+1)
                register[i] <= 32'b0;
        end
        else if(we && w_add != 5'b0) begin
            register[w_add] <= data;
        end
    end
endmodule