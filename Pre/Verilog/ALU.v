module ttest;

	// Inputs
	reg [3:0] inA;
	reg [3:0] inB;
	reg [1:0] inC;
	reg [1:0] op;

	// Outputs
	wire [3:0] ans;

	// Instantiate the Unit Under Test (UUT)
	test uut (
		.inA(inA), 
		.inB(inB), 
		.inC(inC), 
		.op(op), 
		.ans(ans)
	);

	initial begin
        $dumpfile("wave.vcd");        //生成的vcd文件名称
        $dumpvars(0,ttest );
		// Initialize Inputs
		inA = 4;
		inB = 4;
		inC = 2;
		op = 2;
		// Wait 100 ns for global reset to finish
        
		// Add stimulus here

	end
   
		always begin
        #10 op=0;
        #10 op=1;
        #10 op=2;
        #10 op=3;
		end   
endmodule


module test(
input [3:0] inA,
input [3:0] inB,
input [1:0] inC,
input [1:0] op,
output [3:0] ans
    );

assign ans=
			op==2'b00 ? ($signed($signed(inA)>>>inC)) :
			op==2'b01 ? inA>>inC :
			op==2'b10 ? (inA-inB) :
			op==2'b11 ? (inA+inB) :4'b0000;
            
endmodule
