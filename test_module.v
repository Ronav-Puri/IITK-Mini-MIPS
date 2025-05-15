`timescale 1ns / 1ps

module tb_CPU();

    // Inputs
    reg clk;
    reg rst;
    
    reg write_instruction_enable;
    reg [9:0] write_instruction_address;
    reg [31:0] write_instruction;

   CPU cpu(clk, rst, write_instruction_address, write_instruction, write_instruction_enable);
   
   initial begin
   clk<=0;
   forever #10 clk<=~clk;
   end
    
    //Instructions
    initial begin
        write_instruction_enable = 1;
        write_instruction_address = 0;
        write_instruction = 0;
        rst = 1;
        
        //Multiplication of two integers
//        #5 write_instruction_address = 9'd0;
//        #5 write_instruction = 32'b01000000000000001000000000001000; //addi $1, $zero, 8
//        #5 write_instruction_enable = 0;
//        #5 write_instruction_address = 9'd1;
//        #5 write_instruction_enable = 1;
//        #5 write_instruction = 32'b01000000000000010000000000000111; //addi $2, $zero, 7
//        #5 write_instruction_enable = 0;
//        #5 write_instruction_address = 9'd2;
//        #5 write_instruction_enable = 1;
//        #5 write_instruction = 32'b00001100000100010000000000000000; //mul $1, $2
//        #5 write_instruction_enable = 0;

            //Subtraction of two floating-point integers
//            #5 write_instruction_address = 9'd0;
//            #5 write_instruction = 32'b01010010000001010100000110001100;  //lui $10, 418c
//            #5 write_instruction_enable = 0;
//            #5 write_instruction_address = 9'd1;
//            #5 write_instruction_enable = 1;
//            #5 write_instruction = 32'b01000110101001010000000000000000;    //ori $10, 0
//            #5 write_instruction_enable = 0;
//            #5 write_instruction_address = 9'd2;
//            #5 write_instruction_enable = 1;
//            #5 write_instruction = 32'b01010010000001011100000000010000;    //lui $11, 4010
//            #5 write_instruction_enable = 0;
//            #5 write_instruction_address = 9'd3;
//            #5 write_instruction_enable = 1;
//            #5 write_instruction = 32'b01000110101101011000000000000000;    //ori $11, 0
//            #5 write_instruction_enable = 0;
//            #5 write_instruction_address = 9'd4;
//            #5 write_instruction_enable = 1;
//            #5 write_instruction = 32'b11000101010000000000000000000000;  //mtcl $f0, $10
//            #5 write_instruction_enable = 0;
//            #5 write_instruction_address = 9'd5;
//            #5 write_instruction_enable = 1;
//            #5 write_instruction = 32'b11000101011000010000000000000000;  //mtcl $f1, $11
//            #5 write_instruction_enable = 0;
//            #5 write_instruction_address = 9'd6;
//            #5 write_instruction_enable = 1;
//            #5 write_instruction = 32'b11001100000000100000000001000000;  //sub.s $f2, $f0, $f1
//            #5 write_instruction_enable = 0;
            #1 rst = 0;
       
    end

endmodule
