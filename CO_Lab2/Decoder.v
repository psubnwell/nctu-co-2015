// Hu Dongyao(���|��) 0340191

//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        2010/8/16
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
   instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;

//Parameter


//Main function
always@(*) begin
    case (instr_op_i)
	     // R-Type: add, sub, and, or, slt
		  6'b000000:
            {RegWrite_o, ALU_op_o, ALUSrc_o, RegDst_o, Branch_o} <= 8'b1_010_010;
        // addi
        6'b001000:
            {RegWrite_o, ALU_op_o, ALUSrc_o, RegDst_o, Branch_o} <= 8'b1_000_100;
        // beq
        6'b000100:
            {RegWrite_o, ALU_op_o, ALUSrc_o, RegDst_o, Branch_o} <= 8'b0_001_001;
        // slti
        6'b001010:
            {RegWrite_o, ALU_op_o, ALUSrc_o, RegDst_o, Branch_o} <= 8'b1_011_100;
        default:
            {RegWrite_o, ALU_op_o, ALUSrc_o, RegDst_o, Branch_o} <= 8'bx_xxx_xxx;
    endcase
end
endmodule





                    
                    