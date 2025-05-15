`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 07:24:34 AM
// Design Name: 
// Module Name: pc
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
module pc(clk, rst, target, pc_next);
    input clk;
    input rst;
    input [31:0] target;
    output reg [31:0] pc_next;
    
    always @(posedge clk or posedge rst) begin
        if(rst)
            pc_next <= -4;
        else
            pc_next <= target;
    end
endmodule