// lives controller

module Lives_controller (
    input logic clk,
    input logic resetN,
    input logic decrement_life, 				// Signal to decrement a life (e.g., on collision with a bomb)
	 input logic increment_life,
	 input logic OneSecPulse,
	 
	 output logic lives_over,
    output logic [3:0] lives   				// Number of remaining lives 
	 //output logic out_of_lives_game_over 	// Signal to indicate game over (to inform other affected modules, e.g., audio controller)
);
    parameter logic [3:0] INITIAL_LIVES = 2'b11; // Initial number of lives
	 
   
    logic [3:0] lives_n;
	 logic [3:0] lives_p;
	 //logic out_of_lives_internal;
    logic decrement_executed_p;
	 logic decrement_executed_n;
	 
	 logic increment_executed_p;
	 logic increment_executed_n;
always_ff @(posedge clk or negedge resetN) begin
        if (!resetN) begin
            // Initialization on reset
            lives_p <= INITIAL_LIVES;
				decrement_executed_p <= 0;
				increment_executed_p <= 0;
        end 
		  else begin
					
					decrement_executed_p <= decrement_executed_n;
					increment_executed_p <= increment_executed_n;
					lives_p <= lives_n;
        end
end
	 
always_comb begin
	decrement_executed_n = decrement_executed_p;
	increment_executed_n = increment_executed_p;
	lives_n = lives_p;
	if (!decrement_executed_p  && decrement_life && (lives_p > 0)) begin
					lives_n = lives_p - 1;
					decrement_executed_n  = 1;
            end
				// Increment a life if player aquired a life kit
            if (!increment_executed_p && increment_life) begin
					lives_n = lives_p + 1;
					increment_executed_n = 1;
            end
	
	if(OneSecPulse) begin
		decrement_executed_n = 0; // losing a life gives 1 second invurenablity
		increment_executed_n = 0;
	end
	
end	 
	 
	 
	 
	// Output the remaining lives
	assign lives = lives_p;
	assign lives_over = lives == 0 ;
endmodule
