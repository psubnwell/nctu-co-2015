//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_CPU_1(
      clk_i,
		rst_i
		);
    
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_i;

/****************************************
Internal signal
****************************************/
/**** IF stage ****/
wire [31:0]pc;
//wire [31:0]pc_jump;
//wire [31:0]pc_new_pre;
wire [31:0]pc_new;

wire [31:0]pc_next_i_IFID;
wire [31:0]instr_w_i_IFID;

/**** ID stage ****/
wire [31:0]pc_next_o_IFID;
wire [31:0]instr_w_o_IFID;

wire [31:0]write_data;

wire [31:0]pc_next_i_IDEX;
	assign pc_next_i_IDEX = pc_next_o_IFID;
wire [31:0]RS_data_i_IDEX;
wire [31:0]RT_data_i_IDEX;
wire [31:0]imm_i_IDEX;
wire [4:0]RT_addr_i_IDEX;
	assign RT_addr_i_IDEX = instr_w_o_IFID[20:16];
wire [4:0]RD_addr_i_IDEX;
	assign RD_addr_i_IDEX = instr_w_o_IFID[15:11];


//control signal
wire RegWrite_i_IDEX;
wire MemToReg_i_IDEX;

wire Branch_i_IDEX;
wire MemRead_i_IDEX;
wire MemWrite_i_IDEX;

wire RegDst_i_IDEX;
wire [2:0]ALUOp_i_IDEX;
wire ALUSrc_i_IDEX;

// This lab don't use jump signals below(but will be generated).
wire [1:0]BranchType;
wire Jump;

/**** EX stage ****/
wire [31:0]pc_next_o_IDEX;
wire [31:0]RS_data_o_IDEX;
wire [31:0]RT_data_o_IDEX;
wire [31:0]imm_o_IDEX;
wire [4:0]RT_addr_o_IDEX;
wire [4:0]RD_addr_o_IDEX;

wire [31:0]MUX_ALUSrc_w;
wire [3:0]ALU_control;
wire [31:0]imm_sl;

wire [31:0]pc_branch_i_EXMEM;
wire zero_i_EXMEM;
wire [31:0]ALU_result_i_EXMEM;
wire [31:0]RT_data_i_EXMEM;
	assign RT_data_i_EXMEM = RT_data_o_IDEX;
wire [4:0]write_addr_i_EXMEM;

//control signal
wire RegWrite_o_IDEX;
wire MemToReg_o_IDEX;

wire Branch_o_IDEX;
wire MemRead_o_IDEX;
wire MemWrite_o_IDEX;

wire RegDst_o_IDEX;
wire [2:0]ALUOp_o_IDEX;
wire ALUSrc_o_IDEX;

wire RegWrite_i_EXMEM;
	assign RegWrite_i_EXMEM = RegWrite_o_IDEX;
wire MemToReg_i_EXMEM;
	assign MemToReg_i_EXMEM = MemToReg_o_IDEX;

wire Branch_i_EXMEM;
	assign Branch_i_EXMEM = Branch_o_IDEX;
wire MemRead_i_EXMEM;
	assign MemRead_i_EXMEM = MemRead_o_IDEX;
wire MemWrite_i_EXMEM;
	assign MemWrite_i_EXMEM = MemWrite_o_IDEX;


/**** MEM stage ****/
wire [31:0]pc_branch_o_EXMEM;
wire zero_o_EXMEM;
wire [31:0]ALU_result_o_EXMEM;
wire [31:0]RT_data_o_EXMEM;
wire [4:0]write_addr_o_EXMEM;

wire [31:0]Mem_data_i_MEMWB;
wire [31:0]ALU_result_i_MEMWB;
	assign ALU_result_i_MEMWB = ALU_result_o_EXMEM;
wire [4:0]write_addr_i_MEMWB;
	assign write_addr_i_MEMWB = write_addr_o_EXMEM;

//control signal
wire RegWrite_o_EXMEM;
wire MemToReg_o_EXMEM;

wire Branch_o_EXMEM;
wire MemRead_o_EXMEM;
wire MemWrite_o_EXMEM;

wire RegWrite_i_MEMWB;
	assign RegWrite_i_MEMWB = RegWrite_o_EXMEM;
wire MemToReg_i_MEMWB;
	assign MemToReg_i_MEMWB = MemToReg_o_EXMEM;


/**** WB stage ****/
wire [31:0]Mem_data_o_MEMWB;
wire [31:0]ALU_result_o_MEMWB;
wire [4:0]write_addr_o_MEMWB;

//control signal
wire RegWrite_o_MEMWB;
wire MemToReg_o_MEMWB;


/****************************************
Instnatiate modules
****************************************/
//Instantiate the components in IF stage
MUX_2to1 #(.size(32)) MUX3(
		.data0_i(pc_next_i_IFID),
		.data1_i(pc_branch_o_EXMEM),
		.select_i(Branch_o_EXMEM & zero_o_EXMEM),
		.data_o(pc_new)
		);

ProgramCounter PC(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.pc_in_i(pc_new),
		.pc_out_o(pc)
        );

Instr_Memory IM(
		.pc_addr_i(pc),
		.instr_o(instr_w_i_IFID)
	    );
			
Adder Adder1(
		.src1_i(pc),
		.src2_i(32'd4),
		.sum_o(pc_next_i_IFID)
		);

Pipe_Reg #(.size(64)) IF_ID(       //N is the total length of input/output
		.rst_i(rst_i),
		.clk_i(clk_i),
		.data_i({pc_next_i_IFID,instr_w_i_IFID}),
		.data_o({pc_next_o_IFID,instr_w_o_IFID})
);

		
//Instantiate the components in ID stage
Reg_File RF(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.RSaddr_i(instr_w_o_IFID[25:21]),
		.RTaddr_i(instr_w_o_IFID[20:16]),
		.RDaddr_i(write_addr_o_MEMWB),
		.RDdata_i(write_data),
		.RegWrite_i(RegWrite_o_MEMWB),
		.RSdata_o(RS_data_i_IDEX),
		.RTdata_o(RT_data_i_IDEX)
		);


Decoder Decoder(
		.instr_op_i(instr_w_o_IFID[31:26]),
		.RegWrite_o(RegWrite_i_IDEX),
		.MemToReg_o(MemToReg_i_IDEX),
		.Branch_o(Branch_i_IDEX),
		.MemRead_o(MemRead_i_IDEX),
		.MemWrite_o(MemWrite_i_IDEX),
		.RegDst_o(RegDst_i_IDEX),
		.ALUOp_o(ALUOp_i_IDEX),
		.ALUSrc_o(ALUSrc_i_IDEX),
		.BranchType_o(BranchType),     // not use
		.Jump_o(Jump)     // not use
		);

Sign_Extend SE(
		.data_i(instr_w_o_IFID[15:0]),
		.data_o(imm_i_IDEX)
		);	

Pipe_Reg #(.size(148)) ID_EX(
		.rst_i(rst_i),
		.clk_i(clk_i),
		.data_i({RegWrite_i_IDEX, MemToReg_i_IDEX, Branch_i_IDEX, MemRead_i_IDEX, MemWrite_i_IDEX, RegDst_i_IDEX, ALUOp_i_IDEX, ALUSrc_i_IDEX, pc_next_i_IDEX, RS_data_i_IDEX, RT_data_i_IDEX, imm_i_IDEX, RT_addr_i_IDEX, RD_addr_i_IDEX}),
		.data_o({RegWrite_o_IDEX, MemToReg_o_IDEX, Branch_o_IDEX, MemRead_o_IDEX, MemWrite_o_IDEX, RegDst_o_IDEX, ALUOp_o_IDEX, ALUSrc_o_IDEX, pc_next_o_IDEX, RS_data_o_IDEX, RT_data_o_IDEX, imm_o_IDEX, RT_addr_o_IDEX, RD_addr_o_IDEX})
		);
		
//Instantiate the components in EX stage	   
ALU ALU(
		.src1_i(RS_data_o_IDEX),
		.src2_i(MUX_ALUSrc_w),
		.ctrl_i(ALU_control),
		.shamt(RT_addr_o_IDEX),
		.result_o(ALU_result_i_EXMEM),
		.zero_o(zero_i_EXMEM)
		);
		
ALU_Ctrl AC(
		.funct_i(imm_o_IDEX[5:0]),
		.ALUOp_i(ALUOp_o_IDEX),
		.ALUCtrl_o(ALU_control)
		);

MUX_2to1 #(.size(5)) MUX1(
		.data0_i(RT_addr_o_IDEX),
		.data1_i(RD_addr_o_IDEX),
		.select_i(RegDst_o_IDEX),
		.data_o(write_addr_i_EXMEM)
        );
		
MUX_2to1 #(.size(32)) MUX2(
		.data0_i(RT_data_o_IDEX),
		.data1_i(imm_o_IDEX),
		.select_i(ALUSrc_o_IDEX),
		.data_o(MUX_ALUSrc_w)
        );

Shift_Left_Two_32 Shifter(
		.data_i(imm_o_IDEX),
		.data_o(imm_sl)
		);

Adder Adder2(
		.src1_i(pc_next_o_IDEX),     
		.src2_i(imm_sl),     
		.sum_o(pc_branch_i_EXMEM)      
	    );

Pipe_Reg #(.size(107)) EX_MEM(
		.rst_i(rst_i),
		.clk_i(clk_i),
		.data_i({RegWrite_i_EXMEM, MemToReg_i_EXMEM, Branch_i_EXMEM, MemRead_i_EXMEM, MemWrite_i_EXMEM, pc_branch_i_EXMEM, zero_i_EXMEM, ALU_result_i_EXMEM, RT_data_i_EXMEM, write_addr_i_EXMEM}),
		.data_o({RegWrite_o_EXMEM, MemToReg_o_EXMEM, Branch_o_EXMEM, MemRead_o_EXMEM, MemWrite_o_EXMEM, pc_branch_o_EXMEM, zero_o_EXMEM, ALU_result_o_EXMEM, RT_data_o_EXMEM, write_addr_o_EXMEM})
		);
			   
//Instantiate the components in MEM stage
Data_Memory DM(
		.clk_i(clk_i),
		.addr_i(ALU_result_o_EXMEM),
		.data_i(RT_data_o_EXMEM),
		.MemRead_i(MemRead_o_EXMEM),
		.MemWrite_i(MemWrite_o_EXMEM),
		.data_o(Mem_data_i_MEMWB)
	    );

Pipe_Reg #(.size(71)) MEM_WB(
		.rst_i(rst_i),
		.clk_i(clk_i),
		.data_i({RegWrite_i_MEMWB, MemToReg_i_MEMWB, Mem_data_i_MEMWB, ALU_result_i_MEMWB, write_addr_i_MEMWB}),
		.data_o({RegWrite_o_MEMWB, MemToReg_o_MEMWB, Mem_data_o_MEMWB, ALU_result_o_MEMWB, write_addr_o_MEMWB})
		);

//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) MUX6(
		.data0_i(ALU_result_o_MEMWB),
		.data1_i(Mem_data_o_MEMWB),
		.select_i(MemToReg_o_MEMWB),
		.data_o(write_data)
        );

/****************************************
signal assignment
****************************************/	
endmodule

