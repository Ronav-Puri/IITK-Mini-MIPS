`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2025 02:42:49 AM
// Design Name: 
// Module Name: control
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
module control(type, op, alu_op, fpu_op, reg_write, mem_read, mem_write, branch, jump, write_hi_lo, concat_hi_lo, jal, jr, fp_op, fp_op_enable, fp_reg_write, fp_cmp, gen_to_fp, fp_to_gen, gen_reg_write);
    input [1:0] type;
    input [4:0] op;
    output reg [3:0] alu_op, fpu_op;
    output reg reg_write, mem_read, mem_write, branch, jump, write_hi_lo, concat_hi_lo;
    output reg jal, jr;
    input [3:0] fp_op;
    output reg fp_op_enable, fp_reg_write, fp_cmp, gen_to_fp, fp_to_gen, gen_reg_write;
    
    always @(*) begin
        alu_op = 4'd0;
        reg_write = 0;
        mem_read = 0;
        mem_write = 0;
        branch = 0;
        jump = 0;
        write_hi_lo = 0;
        concat_hi_lo = 0;
        jr = 0;
        jal = 0;
        
        fpu_op = 4'd0;
        fp_op_enable = 0;
        fp_reg_write = 0;
        fp_cmp = 0;
        gen_to_fp = 0;
        fp_to_gen = 0;
        gen_reg_write = 0;
        
        case(type)
            2'd0: begin // R-type instructions
                case(op)
                    5'd0: begin alu_op = 4'd1; reg_write = 1; end   //add
                    5'd1: begin alu_op = 4'd2; reg_write = 1; end   //sub
                    5'd2: begin alu_op = 4'd1; reg_write = 1; end   //addu
                    5'd3: begin alu_op = 4'd2; reg_write = 1; end   //subu
                    5'd4: begin alu_op = 4'd3; concat_hi_lo = 1; end    //madd
                    5'd5: begin alu_op = 4'd3; concat_hi_lo = 1; end    //maddu
                    5'd6: begin alu_op = 4'd3; write_hi_lo = 1; end     //mul
                    5'd7: begin alu_op = 4'd4; reg_write = 1; end   //and
                    5'd8: begin alu_op = 4'd5; reg_write = 1; end   //or
                    5'd9: begin alu_op = 4'd6; reg_write = 1; end   //not
                    5'd10: begin alu_op = 4'd7; reg_write = 1; end  //xor
                    5'd11: begin alu_op = 4'd8; reg_write = 1; end  //sll
                    5'd12: begin alu_op = 4'd9; reg_write = 1; end  //srl
                    5'd13: begin alu_op = 4'd8; reg_write = 1; end  //sla
                    5'd14: begin alu_op = 4'd10; reg_write = 1; end //sra
                    5'd15: begin jump = 1; jr = 1; end              //jr
                    5'd16: begin alu_op = 4'd11; reg_write = 1; end //slt
                endcase
            end
            
            2'd1: begin //I-type
                case(op)
                    5'd0: begin alu_op = 4'd1; reg_write = 1; end   //addi
                    5'd1: begin alu_op = 4'd1; reg_write = 1; end   //addiu
                    5'd2: begin alu_op = 4'd4; reg_write = 1; end   //andi
                    5'd3: begin alu_op = 4'd5; reg_write = 1; end   //ori
                    5'd4: begin alu_op = 4'd7; reg_write = 1; end   //xori
                    5'd5: begin alu_op = 4'd11; reg_write = 1; end  //slti
                    5'd6: begin alu_op = 4'd12; reg_write = 1; end  //seq
                    5'd7: begin alu_op = 4'd1; mem_read = 1; reg_write = 1; end   //lw
                    5'd8: begin alu_op = 4'd1; mem_write = 1; end //sw
                    5'd9: begin alu_op = 4'd14; reg_write = 1; end       //lui
                    5'd10: begin alu_op = 4'd12; branch = 1; end       //beq
                    5'd11: begin alu_op = 4'd12; branch = 1; end       //bne
                    5'd12: begin alu_op = 4'd13; branch = 1; end       //bgt
                    5'd13: begin alu_op = 4'd11; branch = 1; end       //bgte
                    5'd14: begin alu_op = 4'd11; branch = 1; end       //ble
                    5'd15: begin alu_op = 4'd13; branch = 1; end       //bleq
                    5'd16: begin alu_op = 4'd13; branch = 1; end       //bleu
                    5'd17: begin alu_op = 4'd13; branch = 1; end       //bgtu
                endcase
            end
            
            2'd2: begin //J-type
                case(op)
                    1'd0: jump = 1;     //j
                    1'd1: begin jump = 1; jal = 1; reg_write = 1; end    //jal
                endcase
           end
           
           2'd3: begin  //FP-type
                case(fp_op)
                    4'd0: begin fp_to_gen = 1; gen_reg_write = 1; end   //mfcl
                    4'd1: begin gen_to_fp = 1; fp_reg_write = 1; end    //mtcl
                    4'd2: begin fp_op_enable = 1; fp_reg_write = 1; fpu_op = 2; end //add.s
                    4'd3: begin fp_op_enable = 1; fp_reg_write = 1; fpu_op = 3; end //sub.s
                    4'd4: begin fp_op_enable = 1; fp_cmp = 1; fpu_op = 4; end       //c.eq.s
                    4'd5: begin fp_op_enable = 1; fp_cmp = 1; fpu_op = 5; end       //c.le.s
                    4'd6: begin fp_op_enable = 1; fp_cmp = 1; fpu_op = 6; end       //c.lt.s
                    4'd7: begin fp_op_enable = 1; fp_cmp = 1; fpu_op = 7; end       //c.ge.s
                    4'd8: begin fp_op_enable = 1; fp_cmp = 1; fpu_op = 8; end       //c.gt.s
                    4'd9: begin fp_op_enable = 1; fp_cmp = 1; fpu_op = 9; end       //mov.s
                    default: ;
                endcase
           end
       endcase  
   end
endmodule
