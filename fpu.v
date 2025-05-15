`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2025 12:32:37 PM
// Design Name: 
// Module Name: fpu
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
module fp_addsub (
    input  [31:0] a,
    input  [31:0] b,
    input         op, // 0 = add, 1 = sub
    output [31:0] result
);
    // Extract fields
    wire sign_a = a[31], sign_b = b[31] ^ op;
    wire [7:0] exp_a = a[30:23], exp_b = b[30:23];
    wire [23:0] mant_a = (exp_a == 0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
    wire [23:0] mant_b = (exp_b == 0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

    // Align exponents
    wire [7:0] exp_diff = (exp_a > exp_b) ? (exp_a - exp_b) : (exp_b - exp_a);
    wire [23:0] mant_a_shifted = (exp_a >= exp_b) ? mant_a : (mant_a >> exp_diff);
    wire [23:0] mant_b_shifted = (exp_b >= exp_a) ? mant_b : (mant_b >> exp_diff);
    wire [7:0] exp_res_pre = (exp_a >= exp_b) ? exp_a : exp_b;

    // Add/Sub mantissas based on sign
    wire same_sign = (sign_a == sign_b);
    wire [24:0] mant_add = {1'b0, mant_a_shifted} + {1'b0, mant_b_shifted};
    wire [24:0] mant_sub = (mant_a_shifted >= mant_b_shifted) ?
                           ({1'b0, mant_a_shifted} - {1'b0, mant_b_shifted}) :
                           ({1'b0, mant_b_shifted} - {1'b0, mant_a_shifted});

    wire [24:0] mant_res = same_sign ? mant_add : mant_sub;
    wire res_sign = same_sign ? sign_a :
                    (mant_a_shifted >= mant_b_shifted ? sign_a : sign_b);

    // Normalize
    reg [7:0] exp_res;
    reg [23:0] final_mant;
    integer i;
    always @(*) begin
        if (mant_res[24]) begin
            final_mant = mant_res[24:1];
            exp_res = exp_res_pre + 1;
        end else begin
            i = 0;
            while (mant_res[23 - i] == 0 && i < 23) i = i + 1;
            final_mant = mant_res[23:0] << i;
            exp_res = exp_res_pre - i;
        end
    end

    assign result = (mant_res == 0) ? 32'b0 : {res_sign, exp_res, final_mant[22:0]};
endmodule

module fpu(fpu_op, f1, f2, fpu_out);
    input [3:0] fpu_op;            
    input [31:0] f1;              
    input [31:0] f2;             
    output reg [31:0] fpu_out;   
    
    wire [31:0] addsub_result;
    wire operation = (fpu_op == 4'd2) ? 0 : 1;
    fp_addsub add_sub(f1, f2, operation, addsub_result);

    always @(*) begin
        fpu_out = 32'd0;

        case (fpu_op)
            4'd2: fpu_out = addsub_result; //add.s
            4'd3: fpu_out = addsub_result; //sub.s
            4'd4: fpu_out = {31'b0,(f1 == f2)}; // c.eq.s
            4'd5: fpu_out = {31'b0,(f1 <= f2)}; // c.le.s
            4'd6: fpu_out = {31'b0,(f1 <  f2)}; // c.lt.s
            4'd7: fpu_out = {31'b0,(f1 >= f2)}; // c.ge.s
            4'd8: fpu_out = {31'b0,(f1 >  f2)}; // c.gt.s
            4'd9: fpu_out = f1;             // mov.s
            default: fpu_out = 32'd0;
        endcase
    end
endmodule
