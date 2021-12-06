`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:58:50 10/21/2021
// Design Name:   gray
// Module Name:   E:/ISE/P1/gray_text.v
// Project Name:  P1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: gray
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module gray_text;

	// Inputs
	reg Clk;
	reg Reset;
	reg En;

	// Outputs
	wire [2:0] Output;
	wire Overflow;

	// Instantiate the Unit Under Test (UUT)
	gray uut (
		.Clk(Clk), 
		.Reset(Reset), 
		.En(En), 
		.Output(Output), 
		.Overflow(Overflow)
	);

	initial begin
		// Initialize Inputs
		Clk = 0;
		Reset = 0;
		En = 1;

		#30 Reset =1;
		#10 Reset =0;
		// Wait 100 ns for global reset to finish
		
        
		// Add stimulus here

	end
	always #5 Clk = ~Clk;
endmodule

