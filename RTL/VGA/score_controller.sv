// score controller


module Score (
    input logic clk,
    input logic resetN,
    input logic increment_score,	// Signal to increment the score (destroying a wall)
    output logic [15:0] score,
	 output logic [3:0] score_units,
	 output logic [3:0] score_tens
);
    // Internal signal
    logic [15:0] score_internal;
    
    always_ff @(posedge clk or negedge resetN) begin
        if (!resetN) begin
            score_internal <= 0;
        end 
		  else begin
            if (increment_score) begin
                score_internal <= score_internal + 1;
            end
        end
    end
    
    assign score = score_internal;
	 assign score_units = score % 10;
	 assign score_tens = score / 10;
	 
	 
endmodule




