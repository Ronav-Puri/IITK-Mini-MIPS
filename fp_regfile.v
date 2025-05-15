`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2025 07:09:00 AM
// Design Name: 
// Module Name: fp_regfile
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
module fp_regfile(clk, rst, fp_reg_we, fp_reg_add1, fp_reg_add2, fp_reg_w_add, fp_reg_data, fp_reg_data1, fp_reg_data2, gen_to_fp, fp_to_gen, gen_fp_transfer);
    input clk, rst, fp_reg_we;
    input [4:0] fp_reg_add1, fp_reg_add2, fp_reg_w_add;
    input [31:0] fp_reg_data;
    input gen_to_fp, fp_to_gen;
    output [31:0] fp_reg_data1, fp_reg_data2;
    inout [31:0] gen_fp_transfer;
    
    reg [31:0] fp_register [31:0];
    
    assign fp_reg_data1 = fp_register[fp_reg_add1];
    assign fp_reg_data2 = fp_register[fp_reg_add2];
    
    integer i;
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            for(i=0; i<32; i=i+1)
                fp_register[i] <= 32'b0;
        end
    end
    
    always @(negedge clk) begin
        if(gen_to_fp) begin
            fp_register[fp_reg_w_add] <= gen_fp_transfer;
        end
        else if(fp_reg_we) begin
            fp_register[fp_reg_w_add] <= fp_reg_data;
        end
    end
endmodule
