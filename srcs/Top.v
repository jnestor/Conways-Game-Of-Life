`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/08/2015 10:42:10 AM
// Design Name: 
// Module Name: Top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Top(
    input clk,
	input reset,
    output Hsync,
    output Vsync,
    output [3:0] red,
    output [3:0] green,
    output [3:0] blue,
	input  [3:0] selector, // for debugging, this will load a preset
	input	write_enb,
	input enb,
	input scan_enb
    );
    
    wire [10:0] y;
    wire [10:0] x;
	wire [15:0] alive_out, alive_in, alive_vga, val;
	wire [1:0] array_pos;
	wire frame;

	
	 
	wire run;    
					
	assign red = rgb[11:8];;
					  
	assign green = rgb[7:4];
				  
	assign blue = rgb[3:0];
						

    VESADriver U_MONITOR(.clk(clk),.Hsyncb(Hsync), .Vsyncb(Vsync), .x(x), .y(y),.frame(frame));
    
    Timer #(.COUNT_MAX(100000000)) U_TIMER(.clk(clk),.trigger(trigger));
    
    assign val = selector[0] ? 16'h3300 :
                 selector[1] ? 16'h33CC :
                 selector[2] ? 16'h0700 :
                 selector[3] ? 16'h6186 :
                               16'h0; 
    
    Display U_DISPLAY (.x(x), .y(y), .alive(alive_vga), .rgb(rgb), .array_pos(array_pos));
    
    Block_Mem U_MEM (.clk(clk), .array_in_vga(array_pos), .alive_out_vga(alive_vga),
                    .write_enb(1'b0), .array_in_selector(), .alive_in_selector(alive_in),
                    .alive_out_selector(alive_out));
                    
    assign run = trigger & enb;
    
    assign scan = trigger & scan_enb;
    
    Counter U_COUNTER (.clk(clk), .scan(scan), .reset(reset), .count_val());
    
	life_array_4x4 U_Array (.clk(clk),.reset(reset), .alive(alive_in),
									.val(val),.write_enb(write_enb),.scan(scan),.scan_write_val(1'b0),
									.scan_write_enb(1'b0), .scan_read_val(), .run(run),
									.nw(1'b0), .ne(1'b0), .se(1'b0), .sw(1'b0),
									.n(4'b0), .e(4'b0), .s(4'b0), .w(4'b0) );
	 
endmodule