
module	song_generator	(	
//		--------	Clock Input	 	
					input	logic	clk,
					input	logic	resetN,
					
					input	logic	qua_sec,
					
					input logic player_wall_collision,		    	// indicates that the player collided with a wall
					input logic life_increase,				    		// indicates that the player earned a coin
					input logic life_loss,								// indicates that the player lost a life
					input logic gameover_loss, 						// indicates that the player lost the game due to not reaching the required score by TIMEOUT_VALUE or running out of lives
					input logic gameover_win, 							// indicates that the player won the game due to reaching the required score by TIMEOUT_VALUE	
					
					output logic enable_sound,
					output logic [3:0] tone					
);

int counter1;
int counter2;
int counter3;
int counter4;
int counter5;

logic gameover_loss_flag;
logic gameover_win_flag;
logic life_increase_flag;
logic player_wall_collision_flag;

//int jump_flag;

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			enable_sound <= 1'b0;
			counter1 <= 1'b0;
			counter2 <= 1'b0;
			counter3 <= 1'b0;
			counter4 <= 1'b0;
			counter5 <= 1'b0;
			gameover_loss_flag <= 0;
			gameover_win_flag <= 0;
			life_increase_flag <= 0;
			player_wall_collision_flag <= 0;
	end

	else begin
			gameover_loss_flag <= gameover_loss_flag || gameover_loss;
			gameover_win_flag <= gameover_win_flag || gameover_win;
			life_increase_flag <= life_increase_flag || life_increase;;
			player_wall_collision_flag <=  player_wall_collision_flag || player_wall_collision;
			
			
			if (qua_sec) begin
			
				if (gameover_loss_flag) begin
						if(counter3 < 2) begin
							if(counter2 < 2) begin
								if(counter1 == 0) begin
									enable_sound <= 1'b1;
									tone <= 9;
									counter1 <= counter1 + 1;
								end
								else if(counter1 == 1) begin
									enable_sound <= 1'b1;
									tone <= 2;
									counter1 <= counter1 + 1;
								end
								else if(counter1 == 2) begin
									enable_sound <= 1'b1;
									tone <= 2;
									counter1 <= counter1 + 1;
								end
								else if(counter1 == 3) begin
									enable_sound <= 1'b1;
									tone <= 2;
									counter1 <= 0;
									counter2 <= counter2 + 1;
								end
							end
							else begin
								if(counter1 == 0) begin
									enable_sound <= 1'b1;
									tone <= 9;
									counter1 <= counter1 + 1;
								end
								else if(counter1 == 1) begin
									enable_sound <= 1'b1;
									tone <= 7;
									counter1 <= counter1 + 1;
								end
								else if(counter1 == 2) begin
									enable_sound <= 1'b1;
									tone <= 5;
									counter1 <= counter1 + 1;
								end
								else if(counter1 == 3) begin
									enable_sound <= 1'b1;
									tone <= 2;
									counter1 <= 0;
									counter3 <= counter3 + 1;
								end
							end
						end
						else begin
							enable_sound <= 1'b0;
						end
				end
				
				else if (gameover_win_flag) begin
						if(counter4 < 2) begin
							if(counter1 == 0) begin
								enable_sound <= 1'b1;
								tone <= 0;
								counter1 <= counter1 + 1;
							end
							else if(counter1 == 1) begin
								enable_sound <= 1'b1;
								tone <= 4;
								counter1 <= counter1 + 1;
							end
							else if(counter1 == 2) begin
								enable_sound <= 1'b1;
								tone <= 7;
								counter1 <= counter1 + 1;
							end
							else if(counter1 == 3) begin
								enable_sound <= 1'b1;
								tone <= 0;
								counter1 <= counter1 + 1;
							end
							else if(counter1 == 4) begin
								enable_sound <= 1'b1;
								tone <= 9;
								counter1 <= counter1 + 1;
							end
							else if(counter1 == 5) begin
								enable_sound <= 1'b1;
								tone <= 7;
								counter1 <= counter1 + 1;
							end
							else if(counter1 == 6) begin
								enable_sound <= 1'b1;
								tone <= 9;
								counter1 <= counter1 + 1;
							end
							else if(counter1 == 7) begin
								enable_sound <= 1'b1;
								tone <= 7;
								counter4 <= counter4 + 1;
								counter1 <= 0;
							end
						end
						else begin
							enable_sound <= 1'b0;
						end
				end
				
				else if (life_increase_flag) begin
						if(counter5 == 0) begin
							enable_sound <= 1'b1;
							tone <= 4;
							counter5 <= counter5 + 1;
						end
//						else if(counter5 == 1) begin
//							enable_sound <= 1'b1;
//							tone <= 7;
//							counter5 <= counter5 + 1;
//						end
						else begin
							enable_sound <= 1'b0;
						end
				end
				
				else if (player_wall_collision_flag) begin
						if(counter1 == 0) begin
							enable_sound <= 1'b1;
							tone <= 6;
							counter1 <= counter1 + 1;

						end
//						else if(counter1 == 1) begin
//							enable_sound <= 1'b1;
//							tone <= 7;
//							counter1 <= counter1 + 1;
//							//enable_sound <= 1'b0;
//						end
						else begin
							enable_sound <= 1'b0;
							counter1 <= 0;
						end
				end
				
				gameover_loss_flag <= 0;
				gameover_win_flag <= 0;
				life_increase_flag <= 0;
				player_wall_collision_flag <= 0;
			end
		end
	end
endmodule
	