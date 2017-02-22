//Subject:     CO project 2 - ALU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU(
    src1_i,
	src2_i,
	shamt,
	ctrl_i,
	result_o,
	zero_o
	
	);
     
//I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
input  [4-1:0]   ctrl_i;
input  [5-1:0]   shamt;
output [32-1:0]	 result_o;
output           zero_o;

//Internal signals

wire             zero_o;
wire    [32:0]   result;
//Parameter

//Main function
assign result = alu_out(src1_i,src2_i,ctrl_i);
assign result_o = result[31:0];
//assign zero_o = z_flag(result);	

	function [32:0] alu_out;
		input [32-1:0] src1_i,src2_i;
		
		input [4-1:0]ctrl_i;
		
		case(ctrl_i)
			4'b0000: alu_out=src1_i&src2_i;     		//AND	
			4'b0001: alu_out=src1_i|src2_i;          //OR
			4'b0010: alu_out=$signed(src1_i)+$signed(src2_i);        //ADD
			4'b0110: alu_out=$signed(src1_i)-$signed(src2_i);     //SUB
			4'b0111: begin
						if(src1_i[31]==0&&src2_i[31]==0)
						begin
							alu_out=(src1_i<src2_i);
						end
						else if(src1_i[31]==0&&src2_i[31]==1)
						begin
							alu_out=0;
							
						end
						else if(src1_i[31]==1&&src2_i[31]==0)
						begin
							alu_out=1;
							
						end
						else if(src1_i[31]==1&&src2_i[31]==1)
						begin
							alu_out=(src1_i>src2_i);
						end
					end         //SLT
			/*4'b1001: 
				begin
					if(src1_i[31]==0&&src2_i[31]==0)
					begin
						alu_out=(src1_i>src2_i);
					end
					else if(src1_i[31]==0&&src2_i[31]==1)
					begin
						alu_out=1;
						
					end
					else if(src1_i[31]==1&&src2_i[31]==0)
					begin
						alu_out=0;
						
					end
					else if(src1_i[31]==1&&src2_i[31]==1)
					begin
						alu_out=(src1_i<src2_i);
						
					end
				end         //BGT*/
			4'b1001:
					 alu_out=$signed(src1_i)>$signed(src2_i);           //BGT
			4'b1011: alu_out=src1_i==src2_i;          //BEQ
			4'b1110: alu_out=src1_i!=src2_i;       //BNE
			4'b0011: alu_out=src1_i>>src2_i;         //SRLV	
			4'b1100: alu_out=src2_i<<16;             //LUI
			4'b1101: alu_out=src2_i<<shamt;    //SLL
			4'b1000: alu_out=src1_i*src2_i;          //MUL
			/*4'b1010: begin
						if(src1_i[31]==0&&src2_i[31]==0)
						begin
							alu_out=(src1_i>=src2_i);
					
						end
						else if(src1_i[31]==0&&src2_i[31]==1)
						begin
							alu_out=1;
						
						end
						else if(src1_i[31]==1&&src2_i[31]==0)
						begin
							alu_out=0;
							
						end
						else if(src1_i[31]==1&&src2_i[31]==1)
						begin
							alu_out=(src1_i<=src2_i);
					
						end
					end        //BGE*/
			4'b1010:
					 alu_out=$signed(src1_i)>=$signed(src2_i); //BGE 
		endcase
	endfunction

	/*function z_flag;
	input [32-1:0] result;
		begin
		  z_flag = ~(result[0]|result[1]|result[2]|result[3]|result[4]|result[5]|result[6]|result[7]|result[8]|result[9]|result[10]|result[11]|result[12]|result[13]|result[14]|result[15]|result[16]|result[17]|result[18]|result[19]|result[20]|result[21]|result[22]|result[23]|result[24]|result[25]|result[26]|result[27]|result[28]|result[29]|result[30]|result[31]);
		
		end
	endfunction*/
	assign zero_o=result_o==0;

endmodule 





                    
                    