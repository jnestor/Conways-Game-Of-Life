`include "pe_array_decs.sv"
`include "pe_decs.sv"

// Non-tiled version - Conway's game of Life using generate

module pe_array ( input                       clk, reset,
 		  input [`PE_CMD_BITS-1:0]    cmd,
		  input [`PE_STATE_BITS-1:0]  state_in,
		  output logic [`PE_STATE_BITS-1:0] state_out,
		  output logic		      active,
		  input [`N_PX_BITS-1:0]      adr_x,
		  input [`N_PY_BITS-1:0]      adr_y
		  );

   genvar i, j;

   logic [`N_PX+2-1:0][`N_PY+2-1:0][`N_STATUS_BITS-1:0] status_a;  // use oversized array to connect edges!!!
   logic [`N_PX-1:0][`N_PY-1:0] active_a;
   logic [`N_PX-1:0][`N_PY-1:0][`PE_STATE_BITS-1:0] state_out_a;   

   logic [`N_PX-1:0] 		csel_v;
   logic [`N_PY-1:0] 		rsel_v;

   	  
  // row decoder logic
   generate
     for (i=0; i<`N_PX; i=i+1)
       assign csel_v[i] = (adr_x == i);
   endgenerate

  // col decoder logic
   generate
     for (i=0; i<`N_PY; i=i+1)
       assign rsel_v[i] = (adr_y == i);
   endgenerate

   generate
      for (i=0; i<`N_PX; i=i+1) // build column-by-column
	begin: outer
	   for (j=0; j<`N_PY; j=j+1) // instantiate cells in each column
	     begin : inner
		pe PE_INST (.clk(clk), .rst(reset), .rsel(rsel_v[j]), .csel(csel_v[i]), .cmd(cmd),
			    .status_out(status_a[(i+1)][(j+1)]), .state_in(state_in), .state_out(state_out_a[i][j]),
			    .active(active_a[i][j]),
			    .w_i(status_a[(i+1)-1][(j+1)]),
			    .n_i(status_a[(i+1)][(j+1)-1]),
			    .e_i(status_a[(i+1)+1][(j+1)]),
			    .s_i(status_a[(i+1)][(j+1)+1]),
			    .nw_i(status_a[(i+1)-1][(j+1)-1]),
			    .ne_i(status_a[(i+1)+1][(j+1)-1]),
			    .se_i(status_a[(i+1)+1][(j+1)+1]),
			    .sw_i(status_a[(i+1)-1][(j+1)+1])
			    );
		end
	end
   endgenerate

   generate
      for (i=0; i<`N_PX+2; i=i+1) begin
	 assign status_a[i][0] = 1'b0;   // top edge and corners
	 assign status_a[i][`N_PY+1] = 1'b0;  // bottom edge and corners
      end
   endgenerate

   generate
      for (j=1; j<`N_PY+1; j=j+1) begin
	 assign status_a[0][j] = 1'b0;   // left edge
	 assign status_a[`N_PX+1][j] = 1'b0;  // right edge
      end
   endgenerate

   // OR together active and state_out signals from PEs to get active output

   always_comb
     begin
	    integer i, j;
	    active = 0;
	    state_out = 0;
	    for (i=0; i<`N_PX; i=i+1) begin
	       for (j=0; j<`N_PY; j=j+1) begin
	            active = active | active_a[i][j];
	            state_out = state_out | state_out_a[i][j];
	       end
	     end
     end
      
endmodule // pe_array
