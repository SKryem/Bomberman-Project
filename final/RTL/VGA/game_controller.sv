
// game controller dudy Febriary 2020
// (c) Technion IIT, Department of Electrical Engineering 2021 
//updated --Eyal Lev 2021


module	game_controller	(	
			input	logic	clk,
			input	logic	resetN,
			input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
			input	logic	drawing_request_character,
			input logic drawing_request_explosion,
			input logic drawin_request_bomb,
			input	logic	drawing_request_wall,
			input logic drawing_request_boots,
			input logic drawing_request_life,
			input logic drawing_request_addBomb,
			input logic drawing_request_landMine,
			input logic drawing_request_explosionMine,
			input logic	[7:0] RGB_MIF,
			
			output logic wall_explode,
			output logic boots_collected,
			output logic life_collected,
			output logic addBomb_collected,
			output logic decrease_life,
			output logic explosionMine_exploded,
			output logic landMine_triggered,
			output logic wall_collision, // active in case of collision between two objects
			output logic SingleHitPulse // critical code, generating A single pulse in a frame
			
				
);




assign collision_character_wall = drawing_request_character && drawing_request_wall;
assign collision_character_boots = drawing_request_character && drawing_request_boots ;
assign collision_character_life = drawing_request_character && drawing_request_life ;
assign collision_character_addBomb = drawing_request_addBomb && drawing_request_character;
assign collision_explosion_wall = drawing_request_wall && drawing_request_explosion;
assign collision_character_explosion = drawing_request_character && drawing_request_explosion;					
assign collision_explosionMine_explosion = drawing_request_explosionMine && drawing_request_explosion;
assign collision_landMine_character = drawing_request_landMine && drawing_request_character;
assign collision_explosionMine_character = drawing_request_explosionMine && drawing_request_character;

//_______________________________________________________

assign wall_collision = collision_character_wall || collision_explosionMine_character;// stops movement of character 
assign boots_collected = collision_character_boots;
assign life_collected = collision_character_life;
assign wall_explode = collision_explosion_wall;
assign addBomb_collected = collision_character_addBomb;
assign decrease_life = collision_character_explosion || collision_landMine_character ;
assign explosionMine_exploded = collision_explosionMine_explosion;
assign landMine_triggered = collision_landMine_character;


logic flag ; // a semaphore to set the output only once per frame / regardless of the number of collisions 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		flag	<= 1'b0;
		SingleHitPulse <= 1'b0 ; 
	end 
	else begin 

			SingleHitPulse <= 1'b0 ; // default 
			if(startOfFrame) 
				flag <= 1'b0 ; // reset for next time 
				
//		change the section below  to collision between number and smiley


		if ( wall_collision && (flag == 1'b0)) begin
			flag	<= 1'b1; // to enter only once 
			SingleHitPulse <= 1'b1 ; 
		end ; 
	end 
end

endmodule
