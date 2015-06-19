`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:36:54 06/19/2015
// Design Name:   life_array_4x4
// Module Name:   U:/Excel/TSP/Conway/Array_Scan_Test.v
// Project Name:  Conway
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: life_array_4x4
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Array_Scan_Test;

   task display_life;
      input [15:0] alive;
      integer i,j;
      for (i = 0; i < 4; i = i + 1) begin
         for (j = 0; j < 4; j = j + 1) begin
            $write("%b",alive[4*i+j]);
         end
         $display();
      end
      
   endtask
	    
   reg [15:0] expected_alive;
	
	// Inputs
	reg clk = 0;
	reg reset = 1;
	reg [1:0] row;
	reg [1:0] col;
	reg val;
	reg write_enb;
	reg scan;
	reg run;

	// Outputs
	wire [15:0] alive;

	// Instantiate the Unit Under Test (UUT)
	life_array_4x4 uut (
		.clk(clk), 
		.reset(reset), 
		.alive(alive), 
		.row(row), 
		.col(col), 
		.val(val), 
		.write_enb(write_enb), 
		.scan(scan), 
		.run(run)
	);

	always begin
	#5 clk = ~clk;
	end
	
	initial begin
		// Initialize Inputs
		row = 0;
		col = 0;
		val = 0;
		write_enb = 0;
		scan = 0;
		run = 0;

		// Wait 11 ns for global reset to finish
		#11;
		reset = 0;
        
		// Add stimulus here
		
		// Write cell 0,0 as 1
		val = 1;
		write_enb = 1;
		
		#10;
		write_enb = 0;
		
		#10;
		scan = 1;
		
		#160;
		$stop;
		

	end
      
endmodule

