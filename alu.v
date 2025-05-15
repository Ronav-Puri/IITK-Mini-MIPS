`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 05:29:20 AM
// Design Name: 
// Module Name: alu
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
module alu (r1, r2, r3, hi_lo, op);
    input [31:0] r1, r2;
    input [3:0] op;
    output reg [31:0] r3;
    output reg [63:0] hi_lo;

    always @(*) begin
        hi_lo = 64'd0;
        
        case (op)
            4'd1: r3 = r1 + r2;                          // add, addu, addi, addiu, lw, sw
            4'd2: r3 = r1 - r2;                          // sub, subu
            4'd3: begin hi_lo = r1 * r2; r3 = hi_lo[31:0]; end      // mul, madd, maddu
            4'd4: r3 = r1 & r2;                          // and, andi
            4'd5: r3 = r1 | r2;                          // or, ori
            4'd6: r3 = ~r1;                              // not
            4'd7: r3 = r1 ^ r2;                          // xor, xori
            4'd8: r3 = r1 << r2;                         // sll, sla
            4'd9: r3 = r1 >> r2;                         // srl
            4'd10: r3 = $signed(r1) >>> r2;              // sra
            4'd11: r3 = (r1 < r2) ? 32'd1 : 32'd0;       // slt, slti, bgte, ble
            4'd12: r3 = (r1 == r2) ? 32'd1 : 32'd0;      // seq, beq, bne
            4'd13: r3 = (r1 > r2) ? 32'd1 : 32'd0;       // bgt, bleq, bgtu, bleu
            4'd14: begin r3 = r1 + r2; r3 = r3 << 16; end   //lui
            default: r3 = 32'bx;
        endcase
   end

endmodule
