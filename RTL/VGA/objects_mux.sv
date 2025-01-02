
// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018

//-- Eyal Lev 31 Jan 2021

module	objects_mux	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
		   // character 
					input		logic	characterDrawingRequest, // two set of inputs per unit
					input		logic	[7:0] characterRGB, 
		
					input		logic	bombDrawingRequest, // two set of inputs per unit
					input		logic	[7:0] bombRGB,
		  ////////////////////////

					
					
					input		logic	explosionDrawingRequest, // two set of inputs per unit
					input		logic	[7:0] explosionRGB,
					/////////
					input    logic wallDrawingRequest, // box of numbers
					input		logic	[7:0] wallRGB,   
					
					
					input logic lifeDrawingRequest,
					input	logic	[7:0] lifeRGB,
					
					input logic bootsDrawingRequest,
					input	logic	[7:0] bootsRGB,
					
					input logic addBombDrawingRequest,
					input logic [7:0] addBombRGB,
					
					input logic landMineDrawingRequest,
					input logic [7:0] landMineRGB,
					
					input logic explosionMineDrawingRequest,
					input logic [7:0] explosionMineRGB,
					
					input logic livesDrawingRequest,
					input logic [7:0] livesRGB,
					
					
					
					input logic scoreLDrawingRequest,
					input logic [7:0] scoreLRGB,
					
					input logic scoreHDrawingRequest,
					input logic [7:0] scoreHRGB,
					
					
					input logic timerLDrawingRequest,
					input logic [7:0] timerLRGB,
					
					input logic timerHDrawingRequest,
					input logic [7:0] timerHRGB,
					
					
					input		logic	[7:0] RGB_MIF, 
					
					output	logic	[7:0] RGBOut

);

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			RGBOut	<= 8'b0;
	end
	
	else begin
		if (characterDrawingRequest == 1'b1 )   
			RGBOut <= characterRGB;  //first priority 
		else if 	(explosionDrawingRequest == 1'b1)
				RGBOut <= explosionRGB;
			else if (bombDrawingRequest == 1'b1)
					RGBOut <= bombRGB;
				else if (wallDrawingRequest == 1'b1 )
						RGBOut <= wallRGB;
						else if ( lifeDrawingRequest == 1'b1 )
								RGBOut<= lifeRGB;
								else if ( bootsDrawingRequest == 1'b1 )
										RGBOut<= bootsRGB;
										else if( addBombDrawingRequest == 1'b1)
												RGBOut <= addBombRGB;
												else if (landMineDrawingRequest == 1'b1)
														RGBOut <= landMineRGB;
														else if (explosionMineDrawingRequest == 1'b1)
														RGBOut <= explosionMineRGB;
															else if(livesDrawingRequest == 1'b1)
																	RGBOut <= livesRGB;
																	else if (scoreLDrawingRequest == 1'b1)
																			RGBOut <= scoreLRGB;
																			else if (scoreHDrawingRequest == 1'b1)
																			RGBOut <= scoreHRGB;
																					else if (timerLDrawingRequest == 1'b1 )
																							RGBOut <= timerLRGB;
																							else if (timerHDrawingRequest == 1'b1 )
																									RGBOut <= timerHRGB;
		else RGBOut <= RGB_MIF ;// last priority 

		end ; 
	end

endmodule


