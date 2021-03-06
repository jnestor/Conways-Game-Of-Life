//-----------------------------------------------------------------------------
// Title         : life_col
// Project       : TSP - Tiled Spatial Processing
//-----------------------------------------------------------------------------
// File          : life_col4.v
// Author        : John Nestor
// Created       : 05.03.2013
// Last modified : 06.19.2015
// Modified by   : Greg Flynn
//-----------------------------------------------------------------------------
// Description :
// A column of tiles of length 4
//------------------------------------------------------------------------------
// Modification history :
// 05.03.2013 : created
// 06.19.2015 : added in scan feature
//-----------------------------------------------------------------------------
module life_col4(input clk,
		 input reset,
		 input [3:0] w_col,
		 input [3:0] e_col,
		 // These are ports to connect to the tile in the compass heading
		 input n, 
		 input s, 
		 input ne,
		 input nw,
		 input se,
		 input sw,
		 // These are ports to set the state of certain cells
		 input write_enb, 
		 input [3:0] val,	 
		 // This is the status of all of the cells
		 output [3:0] alive_col,
         output [3:0] alive_prev_col,
		 
		 // this is to run the entire column
		 input enable
		 );
    
   life_cell LC0(.clk(clk), .reset(reset), .n(n), .ne(ne), .e(e_col[0]),
        .write(write_enb), .val(val[0]), .enb(enable), .alive_prev(alive_prev_col[0]),
		 .se(e_col[1]), .s(alive_col[1]), .sw(w_col[1]), .w(w_col[0]), .nw(nw), .alive(alive_col[0]));

   life_cell LC1(.clk(clk), .reset(reset), .n(alive_col[0]), .ne(e_col[0]), .e(e_col[1]),
         .write(write_enb), .val(val[1]), .enb(enable), .alive_prev(alive_prev_col[1]),
		 .se(e_col[2]), .s(alive_col[2]), .sw(w_col[2]), .w(w_col[1]), .nw(w_col[0]), .alive(alive_col[1]));
		 
   life_cell LC2(.clk(clk), .reset(reset), .n(alive_col[1]), .ne(e_col[1]), .e(e_col[2]),
               .write(write_enb), .val(val[2]), .enb(enable), .alive_prev(alive_prev_col[2]),
               .se(e_col[3]), .s(alive_col[3]), .sw(w_col[3]), .w(w_col[2]), .nw(w_col[1]), .alive(alive_col[2]));

   life_cell LC3(.clk(clk), .reset(reset), .n(alive_col[2]), .ne(e_col[2]), .e(e_col[3]),
               .write(write_enb), .val(val[3]), .enb(enable), .alive_prev(alive_prev_col[3]),
               .se(se), .s(s), .sw(sw), .w(w_col[3]), .nw(w_col[2]), .alive(alive_col[3]));
		 
endmodule // life_col4
