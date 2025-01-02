// (c) Technion IIT, Department of Electrical Engineering 2023 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// updated Eyal Lev April 2023
// updated to state machine Dudy March 2023 


module	character_move	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input logic [9:0] num_input,
					input logic wall_collision,  //collision if smiley hits an object
					input	logic	[3:0] HitEdgeCode, //one bit per edge 
					input logic boots_collision,
					input logic game_over,
				
					output	 logic signed 	[10:0]	topLeftX, // output the top left corner 
					output	 logic signed	[10:0]	topLeftY  // can be negative , if the object is partliy outside 
					
);

// numbers directions
logic move_up;
logic move_down;
logic move_right;
logic move_left;
assign move_up = num_input[8];
assign move_down = num_input[2]; 
assign move_right = num_input[6];
assign move_left = num_input[4];

logic reset_position;
assign reset_position = num_input[5];
logic enable_reset_position = 0; //change to 1 to enable
logic speed_taken_p;
logic speed_taken_n;

// a module used to generate the  ball trajectory.  

parameter int INITIAL_X = 280;
parameter int INITIAL_Y = 100;
parameter int INITIAL_X_SPEED = 0;
parameter int INITIAL_Y_SPEED = 0;
parameter int Y_ACCEL = 0;
localparam int MAX_Y_speed = 400;
const int	FIXED_POINT_MULTIPLIER	=	64; // note it must be 2^n 
// FIXED_POINT_MULTIPLIER is used to enable working with integers in high resolution so that 
// we do all calculations with topLeftX_FixedPoint to get a resolution of 1/64 pixel in calcuatuions,
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n, to return to the initial proportions

int INITIAL_X_normalized = INITIAL_X * FIXED_POINT_MULTIPLIER;
int INITIAL_Y_normalized = INITIAL_Y * FIXED_POINT_MULTIPLIER;

// movement limits 
const int   OBJECT_WIDTH_X = 64;
const int   OBJECT_HIGHT_Y = 64;
const int	SafetyMargin =	2;

const int	x_FRAME_LEFT	=	(SafetyMargin)* FIXED_POINT_MULTIPLIER; 
const int	x_FRAME_RIGHT	=	(639 - SafetyMargin - OBJECT_WIDTH_X)* FIXED_POINT_MULTIPLIER; 
const int	y_FRAME_TOP		=	(SafetyMargin) * FIXED_POINT_MULTIPLIER;
const int	y_FRAME_BOTTOM	=	(479 -SafetyMargin - OBJECT_HIGHT_Y ) * FIXED_POINT_MULTIPLIER; //- OBJECT_HIGHT_Y

enum  logic [2:0] {IDLE_ST, // initial state
					MOVE_ST, // moving no colision 
					WAIT_FOR_EOF_ST, // change speed done, wait for startOfFrame  
					POSITION_CHANGE_ST,// position interpolate 
					POSITION_LIMITS_ST //check if inside the frame  
					}  SM_PS, 
						SM_NS ;

 int Xspeed_PS,  Xspeed_NS  ; // speed    
 int Yspeed_PS,  Yspeed_NS  ; 
 int Xposition_PS, Xposition_NS ; //position   
 int Yposition_PS, Yposition_NS ;  

 const int normal_speed = 80; 
 const int fast_speed = normal_speed * 1.5;
 
  int Yspeed;
  int Xspeed;
 logic [9:0] num_input_D;

 //---------
 
 always_ff @(posedge clk or negedge resetN)
		begin : fsm_sync_proc
			if (resetN == 1'b0) begin 
				SM_PS <= IDLE_ST ; 
				Xspeed_PS <= 0   ; 
				Yspeed_PS <= 0  ; 
				Yspeed <= normal_speed;
				Xspeed <= normal_speed;
				Xposition_PS <= 0  ; 
				Yposition_PS <= 0   ; 
				num_input_D <= 10'b0;	
				speed_taken_p <= 1'b0;
			end 	
			else begin 
				speed_taken_p <= speed_taken_n;
				SM_PS  <= SM_NS ;
				Xspeed_PS   <= Xspeed_NS    ; 
				Yspeed_PS    <=   Yspeed_NS  ; 
				Xposition_PS <=  Xposition_NS    ; 
				Yposition_PS <=  Yposition_NS    ; 
				
				if( speed_taken_p == 1'b1 )begin
					Yspeed <= fast_speed ; 
					Xspeed <= fast_speed; 
				end
				
				if(game_over) begin
					Yspeed <= 0 ; 
					Xspeed <= 0; 
					Xspeed_PS <= 0; 
					Yspeed_PS <= 0; 
				end
				num_input_D = num_input ;  //shift register to detect edge 
			end ; 
		end // end fsm_sync

 
 ///-----------------
 
 
always_comb 
begin
	// set default values 
		 SM_NS = SM_PS  ;
		 Xspeed_NS  = Xspeed_PS ; 
		 Yspeed_NS  = Yspeed_PS  ; 
		 Xposition_NS =  Xposition_PS ;
		 Yposition_NS  = Yposition_PS ; 
	 	

	case(SM_PS)
//------------
		IDLE_ST: begin
//------------
		 Xspeed_NS  = INITIAL_X_SPEED ; 
		 Yspeed_NS  = INITIAL_Y_SPEED  ; 
		 Xposition_NS = INITIAL_X_normalized; 
		 Yposition_NS = INITIAL_Y_normalized; 

		 if (startOfFrame) 
				SM_NS = MOVE_ST ;
 	
	end
	
//------------
		MOVE_ST:  begin     // moving no colision 
//------------
		
		
		// uncomment these 2 lines to change the behaviour from toggle to hold
			Yspeed_NS = 0;
			Xspeed_NS = 0;
			
			
			if (move_up ) begin
					Yspeed_NS = -Yspeed; // decrease Y -> move up
			end	
			else if (move_down) begin
					Yspeed_NS =  Yspeed;// increase Y -> move down
				  end
						
			if (move_right ) begin
						Xspeed_NS = Xspeed;
					end	
			else if (move_left) begin
						Xspeed_NS = - Xspeed;	
				end
			
			if (wall_collision) begin  //any colisin was detected 
				
					if (HitEdgeCode [2] == 1 )  // hit top border of brick  
						if (Yspeed_PS < 0) // while moving up
								Yspeed_NS = -Yspeed_PS ; 
								
					
					if ( HitEdgeCode [0] == 1 )// hit bottom border of brick  
						if (Yspeed_PS > 0 )//  w2hile moving down
								Yspeed_NS = -Yspeed_PS ; 
		
					if (HitEdgeCode [3] == 1)   
						if (Xspeed_PS < 0 ) // while moving left
								Xspeed_NS = -Xspeed_PS ; // positive move right 
									
					if ( HitEdgeCode [1] == 1 )   // hit right border of brick  
							if (Xspeed_PS > 0 ) //  while moving right
									Xspeed_NS = -Xspeed_PS  ;  // negative move left   
								
					SM_NS = WAIT_FOR_EOF_ST ; 
				end 	

			if (startOfFrame) 
						SM_NS = POSITION_CHANGE_ST ; 
		end 
				
//--------------------
		WAIT_FOR_EOF_ST: begin  // change speed already done once, now wait for EOF 
//--------------------
									
			if (startOfFrame) 
				SM_NS = POSITION_CHANGE_ST ; 
		end 

//------------------------
 		POSITION_CHANGE_ST : begin  // position interpolate 
//---------------------
	
			 Xposition_NS =  Xposition_PS + Xspeed_PS; 
			 Yposition_NS  = Yposition_PS + Yspeed_PS ;
			 
		// accelerate 	
            if (Yspeed_PS	<= MAX_Y_speed)	
				       Yspeed_NS = Yspeed_PS  - Y_ACCEL ; // deAccelerate : slow the speed down every clock tick 
				
				if (enable_reset_position && reset_position) begin
					Xposition_NS = INITIAL_X_normalized ;
					Yposition_NS = INITIAL_Y_normalized;
				end
				SM_NS = POSITION_LIMITS_ST ; 
		end
		
		
//------------------------
		POSITION_LIMITS_ST : begin  //check if still inside the frame 
//------------------------
		

				 if (Xposition_PS < x_FRAME_LEFT ) 
						begin  
//							Xposition_NS = x_FRAME_LEFT; 
//							if (Xspeed_PS < 0 ) // moving to the left 
//									Xspeed_NS = 0- Xspeed_PS ; // change direction 

						Xposition_NS = x_FRAME_RIGHT; // hitting the edge teleportes to the other direction (cyclic) 

						end ; 
	
				 if (Xposition_PS > x_FRAME_RIGHT) 
						begin  
//							Xposition_NS = x_FRAME_RIGHT; 
//							if (Xspeed_PS > 0 ) // moving to the right 
//									Xspeed_NS = 0- Xspeed_PS ; // change direction 
						Xposition_NS = x_FRAME_LEFT; // hitting the edge teleportes to the other direction (cyclic) 

						end ; 

							
				if (Yposition_PS < y_FRAME_TOP ) 
						begin  
//							Yposition_NS = y_FRAME_TOP; 
//							if (Yspeed_PS < 0 ) // moving to the top 
//									Yspeed_NS = 0- Yspeed_PS ; // change direction 
							Yposition_NS = y_FRAME_BOTTOM; // hitting the edge teleportes to the other direction (cyclic) 
						end ; 
	
				 if (Yposition_PS > y_FRAME_BOTTOM) 
						begin  
//							Yposition_NS = y_FRAME_BOTTOM; 
//							if (Yspeed_PS > 0 ) // moving to the bottom 
//									Yspeed_NS = 0- Yspeed_PS ; // change direction 
						Yposition_NS = y_FRAME_TOP; // hitting the edge teleportes to the other direction (cyclic) 
						end ;

			SM_NS = MOVE_ST ; 
			
		end
		
endcase  // case 
end		
//return from FIXED point  trunc back to prame size parameters 
  
assign 	topLeftX = Xposition_PS / FIXED_POINT_MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = Yposition_PS / FIXED_POINT_MULTIPLIER ;    

	
always_comb begin 
	speed_taken_n = 1'b0;
	
	if(boots_collision) begin
		speed_taken_n = 1'b1;
	end
	
end
endmodule	
//---------------
 
