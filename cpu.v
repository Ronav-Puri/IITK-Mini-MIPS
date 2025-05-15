`timescale 1ns / 1ps

module CPU(clk, rst, write_instruction_address, write_instruction, write_instruction_enable);
    input clk, rst;
    input [9:0] write_instruction_address;
    input [31:0] write_instruction;
    input write_instruction_enable;
    
    // Floating point
    // Floating-point control signals
    wire fp_op_enable, fp_reg_write, fp_cmp;
    wire gen_to_fp, fp_to_gen, gen_reg_write;

    // Floating-point decode fields
    wire [3:0] fp_op;
    wire [4:0] r0, f0, f1, f2;
    wire [3:0] fpu_op;

    // FP register file wires
    wire [31:0] fp_data1, fp_data2, fp_write_data;
    wire [31:0] fp_gen_transfer;  
    
    //Control Unit
    wire [3:0] alu_op;
    wire reg_write, mem_read, mem_write, branch, jump, write_hi_lo, concat_hi_lo;
    wire jr, jal;
    
    //Instruction Fetch
    wire [31:0] instruction;
    wire [31:0] pc, next_pc;

    reg [31:0] hi, lo;
    
    //Instruction Memory
    memory_wrapper INST_MEM(write_instruction_address, write_instruction, pc[10:2], clk, write_instruction_enable, instruction);
    
    //Instruction Decode
    wire [1:0] type;
    wire [4:0] op, rs, rt, rd;
    wire [4:0] write_reg = (jal) ? 5'd31 : (fp_to_gen) ? r0 : (reg_write || gen_reg_write) ? rt : rd;
    wire [9:0] shamt;
    wire [15:0] imm;
    wire [28:0] address;
    
    //Register File
    wire [4:0] reg_add1 = (gen_to_fp) ? r0 : rs;
    wire [31:0] reg1, reg2, wb_data;
    
    //ALU Execution
    wire [31:0] alu_in2 = (type == 2'd1) ? {17'd0,imm} : reg2;
    wire [31:0] alu_out;
    wire [63:0] mul_result;
    
    //Memory Access
    wire [31:0] mem_data;
    
    //Data Memory
    memory_wrapper DATA_MEM(alu_out[10:2], reg2, alu_out[10:2], clk, mem_write, mem_data);
    //Register 2 (rt) contains register data to store during sw
    
    //Modules
    pc PC(clk, rst, next_pc, pc);
    
    instruction_decode DECODER(instruction, type, op, fp_op, rs, rt, rd, shamt, imm, address, r0, f0, f1, f2);
    
    regfile RF(clk, rst, (reg_write|gen_reg_write), reg_add1, rt, write_reg, wb_data, reg1, reg2, gen_to_fp, fp_to_gen, fp_gen_transfer);
    
    alu ALU(reg1, alu_in2, alu_out, mul_result, alu_op);
    
    control CTRLUNIT(type, op, alu_op, fpu_op, reg_write, mem_read, mem_write, branch, jump, write_hi_lo, concat_hi_lo, jal, jr, fp_op, fp_op_enable, fp_reg_write, fp_cmp, gen_to_fp, fp_to_gen, gen_reg_write);
    
    fp_regfile FP_RF(clk, rst, fp_reg_write, f1, f2, f0, fp_write_data, fp_data1, fp_data2, gen_to_fp, fp_to_gen, fp_gen_transfer);
    
    fpu FPU(fpu_op, fp_data1, fp_data2, fp_write_data);
    
    always @(posedge clk or posedge rst) begin
        //Updating HI/LO register
        if(rst) begin
            hi <= 32'd0;
            lo <= 32'd0;
        end
        else begin
            if(write_hi_lo)
                {hi,lo} <= mul_result;
            else if(concat_hi_lo)
                {hi,lo} <= {hi,lo} + mul_result;
        end            
     end
     
     //Write Back
     assign wb_data = (fp_to_gen) ? fp_data1 : (mem_read) ? mem_data : alu_out;
     
     //Branch Logic
     wire branch_taken;
     
//     assign branch_taken = ((alu_op == 4'd11 && alu_out == 32'd0) ||   //bgte
//                           (alu_op == 4'd11 && alu_out == 32'd1) ||    //ble
//                           (alu_op == 4'd12 && alu_out == 32'd1) ||    //beq
//                           (alu_op == 4'd12 && alu_out == 32'd0) ||    //bne
//                           (alu_op == 4'd13 && alu_out == 32'd1) ||    //bgt, bgtu
//                           (alu_op == 4'd13 && alu_out == 32'd0));     //bleq, bleu

       assign branch_taken = 0;
                           
     wire [31:0] branch_offset = {{17{imm[14]}}, imm, 2'd0};
     wire [31:0] jump_target = {3'd0, address, 2'd0};
     assign next_pc = (jr) ? reg1 : (jump) ? jump_target : (branch && branch_taken) ? pc + 4 + branch_offset : pc + 4;
     
endmodule
