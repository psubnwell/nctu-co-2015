//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Simple_Single_CPU(
      clk_i,
		rst_i
		);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles
wire [31:0]pc;
wire [31:0]pc_next;
wire [31:0]pc_branch;
wire [31:0]pc_jump;
wire [31:0]pc_new_pre;
wire [31:0]pc_new;

wire [31:0]instr_w;
wire [4:0]write_addr;
wire [31:0]write_data;
wire [31:0]RS_data;
wire [31:0]RT_data;
wire [31:0]imm;
wire [31:0]MUX_ALUSrc_w;
wire [31:0]ALU_result;
wire [31:0]imm_sl;
wire [3:0]ALU_control;
wire [31:0]Mem_data;
wire zero;
wire cout;
wire overflow;

wire Branch;
wire [1:0]MemToReg;
wire [1:0]BranchType;
wire Jump;
wire MemRead;
wire MemWrite;
wire [2:0]ALUOp;
wire ALUSrc;
wire RegWrite;
wire RegDst;

assign pc_jump = {pc_next[31:28],instr_w[25:0],2'b00};

//Greate componentes
ProgramCounter PC(
       .clk_i(clk_i),      
	    .rst_i(rst_i),     
	    .pc_in_i(pc_new) ,   
	    .pc_out_o(pc) 
	    );
	
Adder Adder1(
       .src1_i(32'd4),     
	    .src2_i(pc),     
	    .sum_o(pc_next)    
	    );
	
Instr_Memory IM(
       .pc_addr_i(pc),  
	    .instr_o(instr_w)    
	    );

MUX_2to1 #(.size(5)) MUX1(
        .data0_i(instr_w[20:16]),
        .data1_i(instr_w[15:11]),
        .select_i(RegDst),
        .data_o(write_addr)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	     .rst_i(rst_i),     
        .RSaddr_i(instr_w[25:21]),  
        .RTaddr_i(instr_w[20:16]),  
        .RDaddr_i(write_addr),  
        .RDdata_i(write_data), 
        .RegWrite_i(RegWrite),
        .RSdata_o(RS_data),  
        .RTdata_o(RT_data)   
        );
	
Decoder Decoder(
       .instr_op_i(instr_w[31:26]), 
	    .RegWrite_o(RegWrite), 
	    .ALUOp_o(ALUOp),   
	    .ALUSrc_o(ALUSrc),   
	    .RegDst_o(RegDst),   
		 .Branch_o(Branch),
		 .MemToReg_o(MemToReg),
		 .BranchType_o(BranchType),
		 .Jump_o(Jump),
		 .MemRead_o(MemRead),
		 .MemWrite_o(MemWrite)
	    );

ALU_Ctrl AC(
        .funct_i(instr_w[5:0]),   
        .ALUOp_i(ALUOp),   
        .ALUCtrl_o(ALU_control) 
        );
	
Sign_Extend SE(
        .data_i(instr_w[15:0]),
        .data_o(imm)
        );

MUX_2to1 #(.size(32)) MUX2(
        .data0_i(RT_data),
        .data1_i(imm),
        .select_i(ALUSrc),
        .data_o(MUX_ALUSrc_w)
        );	
		
ALU ALU(
       .instruc(instr_w),
		 .src1_i(RS_data),
	    .src2_i(MUX_ALUSrc_w),
	    .ctrl_i(ALU_control),
	    .result_o(ALU_result),
		 .zero_o(zero)
	    );
		 
MUX_4to1 #(.size(1)) MUX5(
		 .data0_i(zero),
       .data1_i(~(zero | ALU_result[31])),
       .data2_i(~ALU_result[31]),
       .data3_i(~zero),
       .select_i(BranchType),
       .data_o(MUX_zero_result)
       );
		
Adder Adder2(
       .src1_i(pc_next),     
	    .src2_i(imm_sl),     
	    .sum_o(pc_branch)      
	    );
		
Shift_Left_Two_32 Shifter(
        .data_i(imm),
        .data_o(imm_sl)
        ); 		
		
MUX_2to1 #(.size(32)) MUX3(
        .data0_i(pc_next),
        .data1_i(pc_branch),
        .select_i(Branch & MUX_zero_result),
        .data_o(pc_new_pre)
        );	

MUX_2to1 #(.size(32)) MUX4(
        .data0_i(pc_new_pre),
        .data1_i(pc_jump),
        .select_i(Jump),
        .data_o(pc_new)
        );	
		  
Data_Memory Data_Memory(
		  .clk_i(clk_i),
		  .addr_i(ALU_result),
		  .data_i(RT_data),
		  .MemRead_i(MemRead),
		  .MemWrite_i(MemWrite),
		  .data_o(Mem_data)
        );

MUX_4to1 #(.size(32)) MUX6(
		  .data0_i(ALU_result),
        .data1_i(Mem_data),
        .data2_i(imm),
        .data3_i(imm),     // 3-input MUX
        .select_i(MemToReg),
        .data_o(write_data)
        );

endmodule
		  


