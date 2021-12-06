`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:13:29 10/21/2021
// Design Name:   BlockChecker
// Module Name:   E:/ISE/P1/BlockChecker_text.v
// Project Name:  P1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: BlockChecker
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module BlockChecker_text;

	// Inputs
	reg clk;
	reg reset;
	reg [7:0] in;

	// Outputs
	wire result;

	// Instantiate the Unit Under Test (UUT)
	BlockChecker uut (
		.clk(clk), 
		.reset(reset), 
		.in(in), 
		.result(result)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		in = "a";

		// Wait 100 ns for global reset to finish
		#2 reset =1 ;
		#10 reset = 0;
		in =" ";
		#10 in = "B";
		#10 in = "E";
		#10 in = "g";
		#10 in = "I";
		#10 in = "n";
		#10 in = " ";
		#10 in = "E";
		#10 in = "n";
		#10 in = "d";
		#10 in = "c";
		#10 in = " ";
		#10 in = "e";
		#10 in = "n";
		#10 in = "D";
		#10 in = " ";
		#10 in = "e";
		#10 in = "n";
		#10 in = "D";
		#10 in = "B";
		#10 in = "E";
		#10 in = "g";
		#10 in = "I";
		#10 in = "n";
		#10 in = " ";
		#10 in = " ";
		#10 in = "e";
		#10 in = "n";
		#10 in = "D";
		#10 in = " ";
		#10 in = "B";
		#10 in = "E";
		#10 in = "g";
		#10 in = "I";
		#10 in = "n";
		
        
		// Add stimulus here

	end
      always #5 clk = ~clk;
endmodule

