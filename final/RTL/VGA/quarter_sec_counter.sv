
module quarter_sec_counter      	
	(
   // Input, Output Ports
	input  logic clk, 
	input  logic resetN, 
	input  logic turbo,
	output logic qua_sec, 
	output logic duty50
   );
	
	localparam int n = 1 ;
	localparam oneSecVal = 26'd12_500_000; //// large value for real time
	//localparam oneSecVal = 26'd32;          //smaller parameter for simulation
	localparam oneSecValTurbo = oneSecVal/8; 
	int oneSecCount ;
	int n_sec_val ;


always_comb
begin

	if (turbo )
		n_sec_val = (n * oneSecValTurbo);
	else
		n_sec_val = (n * oneSecVal);
end

   always_ff @( posedge clk or negedge resetN )
   begin
	
      // Asynchronic reset
      if ( !resetN ) begin
			qua_sec <= 1'b0;
			duty50 <= 1'b0;
			oneSecCount <= 26'd0;
		end //asynch
		// Synchronic logic	
      else begin
				if (oneSecCount >= n_sec_val) begin
					qua_sec <= 1'b1;
					duty50 <= ~duty50;
					oneSecCount <= 0;
				end
				else begin
					oneSecCount <= oneSecCount + 1;
					qua_sec		<= 1'b0;
				end
		end //synch
	end // always
endmodule
