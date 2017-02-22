`timescale 1ns/1ps

//Student Name: Hu Dongyao
//Student Number: 0340191

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:58:01 10/10/2011 
// Design Name: 
// Module Name:    alu_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module alu_top(
               src1,       //1 bit source 1 (input)
               src2,       //1 bit source 2 (input)
               less,       //1 bit less     (input)
               A_invert,   //1 bit A_invert (input)
               B_invert,   //1 bit B_invert (input)
               cin,        //1 bit carry in (input)
               operation,  //operation      (input)
               result,     //1 bit result   (output)
               cout,       //1 bit carry out(output)
               );

input         src1;
input         src2;
input         less;
input         A_invert;
input         B_invert;
input         cin;
input [2-1:0] operation;

output        result;
output        cout;

reg           result;
reg           cout;
reg           a,b;

always@( * )
begin

if (A_invert) a=~src1;
else a=src1;
if (B_invert) b=~src2;
else b=src2;

case (operation)
	2'b00:	begin
				result <= a & b; 
				cout   <= 1'b0;
				end
	2'b01:	begin
				result <= a | b; 
				cout   <= 1'b0;
				end
	2'b10:	begin
	         result <= a ^ b ^ cin;
				cout   <=(a&b)|((a^b)&cin);
				end
	2'b11:	begin
				result <= less;
				cout   <= (a&b)|((a^b)&cin);
				end
	default:	{cout,result} <= 2'b00;
endcase

end


endmodule
