// Hu Dongyao(ºú–|¬Ž) 0340191

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
	 ALUOp_o,   
	 ALUSrc_o,   
	 RegDst_o,   
	 Branch_o,
	 MemToReg_o,
	 BranchType_o,
	 Jump_o,
	 MemRead_o,
	 MemWrite_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALUOp_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output [2-1:0] MemToReg_o;
output [2-1:0] BranchType_o;
output         Jump_o;
output         MemRead_o;
output         MemWrite_o;
 
//Internal Signals
reg            RegWrite_o;
reg    [3-1:0] ALUOp_o;
reg            ALUSrc_o;
reg            RegDst_o;
reg            Branch_o;
reg    [2-1:0] MemToReg_o;
reg    [2-1:0] BranchType_o;
reg            Jump_o;
reg            MemRead_o;
reg            MemWrite_o;

reg    [14-1:0] control_o; 

//Parameter


//Main function
always@(instr_op_i)
begin
	if(instr_op_i==6'd0)//R-type
	begin
		RegDst_o =1;
		ALUSrc_o =0;
		RegWrite_o =1;
		Branch_o =0;
		MemWrite_o =0;
		MemRead_o =0;
		BranchType_o=2'b00;
		Jump_o=0;
		MemToReg_o=0;
		ALUOp_o =3'd0;
	end
	else if(instr_op_i==6'd8)//addi
	begin
		RegDst_o =0;
		ALUSrc_o =1;
		RegWrite_o =1;
		Branch_o =0;
		MemWrite_o =0;
		MemRead_o =0;
		BranchType_o=2'b00;
		Jump_o=0;
		MemToReg_o=0;
		ALUOp_o =3'd1;
	end
	else if(instr_op_i==6'd13)//ori
	begin
		RegDst_o =0;
		ALUSrc_o =1;
		RegWrite_o =1;
		Branch_o =0;
		MemWrite_o =0;
		MemRead_o =0;
		BranchType_o=2'b00;
		Jump_o =0;
		MemToReg_o=0;
		ALUOp_o =3'd2;
	end
	else if(instr_op_i==6'd4)//beq
	begin
		RegDst_o =0;
		ALUSrc_o =0;
		RegWrite_o =0;
		Branch_o =1;
		MemWrite_o =0;
		MemRead_o =0;
		BranchType_o=2'b00;
		Jump_o =0;
		MemToReg_o=0;
		ALUOp_o =3'd5;
	end
	else if(instr_op_i==6'd10)//slti
	begin	
		RegDst_o =0;
		ALUSrc_o =1;
		RegWrite_o =1;
		Branch_o =0;
		MemWrite_o =0;
		MemRead_o =0;
		BranchType_o=2'b00;
		Jump_o =0;
		MemToReg_o=0;
		ALUOp_o =3'd7;
	end
	else if(instr_op_i==6'd5)//bne
	begin
		RegDst_o =0;
		ALUSrc_o =0;
		RegWrite_o =0;
		Branch_o =1;
		MemWrite_o =0;
		MemRead_o =0;
		BranchType_o=2'b11;
		Jump_o =0;
		MemToReg_o=0;
		ALUOp_o =3'd5;
	end
	else if(instr_op_i==6'd35)//lw
	begin
		RegDst_o =0;
		ALUSrc_o =1;
		RegWrite_o =1;
		Branch_o =0;
		MemWrite_o =0;
		MemRead_o =1;
		BranchType_o=2'b00;
		Jump_o =0;
		MemToReg_o =1;
		ALUOp_o =3'd6;
	end
	else if(instr_op_i==6'd43)//sw
	begin
		RegDst_o =0;
		ALUSrc_o =1;
		RegWrite_o =0;
		Branch_o =0;
		MemWrite_o =1;
		MemRead_o =0;
		BranchType_o=2'b00;
		Jump_o =0;
		MemToReg_o =1;
		ALUOp_o =3'd6;
	end
	else if(instr_op_i==6'd2)//jump
	begin
		RegDst_o =0;
		ALUSrc_o =0;
		RegWrite_o =0;
		Branch_o =0;
		MemWrite_o =0;
		MemRead_o =0;
		MemToReg_o =0;
		BranchType_o=2'b00;
		Jump_o =1;
	end
	else if(instr_op_i==6'd7)//bgt
	begin
		RegDst_o =0;
		ALUSrc_o =0;
		RegWrite_o =0;
		Branch_o =1;
		MemWrite_o =0;
		MemRead_o =0;
		Jump_o =0;
		BranchType_o=2'b01;
		MemToReg_o=0;
		ALUOp_o =3'd5;
	end
	else if(instr_op_i==6'd1)//bge
	begin
		RegDst_o =0;
		ALUSrc_o =0;
		RegWrite_o =0;
		Branch_o =1;
		MemWrite_o =0;
		MemRead_o =0;
		BranchType_o=2'b10;
		Jump_o =0;
		MemToReg_o=0;
		ALUOp_o =3'd3;
	end
	else if(instr_op_i==6'd15)//lui
	begin
		RegDst_o =0;
		ALUSrc_o =1;
		RegWrite_o =1;
		Branch_o =0;
		MemWrite_o =0;
		MemRead_o =0;
		BranchType_o=2'b00;
		Jump_o =0;
		MemToReg_o=0;
		ALUOp_o=3'd4;
	end
	else if(instr_op_i==6'd3)//jal
	begin
		
		RegDst_o = 0; // don't care
		ALUSrc_o = 0; // don't care
		RegWrite_o = 1;
		Branch_o = 0; // don't care
		BranchType_o = 2'b00; // don't care
		//Jump_o = 1;
		MemRead_o = 0; // don't care
		MemWrite_o = 0; // don't care
		MemToReg_o = 1;
		//ReadDataReg_o = 1; // don't care
		ALUOp_o = 3'd0; // don't care
	end
end
endmodule





                    
                    