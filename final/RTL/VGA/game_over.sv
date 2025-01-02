
module Game_Over (
    input logic clk,
    input logic resetN,
    input logic tc,            // Indicates the timer has run out
    input logic [15:0] score,
    input lives_over,   		 	
    output logic game_over,    // Indicates the game is over (win or loss)
    output logic win,          // Indicates if the player won
    output logic loss          // Indicates if the player lost
);

    localparam SCORE_THRESHOLD = 16'd10;  // Define the score threshold required to win

    always_ff @(posedge clk or negedge resetN) begin
        if (!resetN) begin
            game_over <= 1'b0;
            win <= 1'b0;
            loss <= 1'b0;
        end else begin
            if (lives_over) begin  // Player loses if no lives are left
                game_over <= 1'b1;
                loss <= 1'b1;
                win <= 1'b0;
            end else if (tc) begin  // If the timer runs out
                if (score >= SCORE_THRESHOLD) begin  // Player wins if they reached the threshold
                    game_over <= 1'b1;
                    win <= 1'b1;
                    loss <= 1'b0;
                end else begin  // Player loses if they didn't reach the threshold
                    game_over <= 1'b1;
                    win <= 1'b0;
                    loss <= 1'b1;
                end
            end
        end
    end
endmodule
