module  ghost_motion ( input Reset, frame_clk,
					input [4:0]   x_start, y_start,
					input [155:0] horiz_walls, vert_walls,
					input [9:0]   pacX, pacY,
					input [15:0]  randomness,
					output        hitPacman,
               output [9:0]  ghostX, ghostY/*, ghostS*/ );
					
    
    logic [9:0] ghost_X_Pos, ghost_X_Motion, ghost_Y_Motion, ghost_X_Turn_Motion, ghost_Y_Pos, ghost_Y_Turn_Motion, ghost_Size, ghost_X_Continue_Motion, ghost_Y_Continue_Motion;
	 logic [9:0] last_X_Turn_Motion, last_Y_Turn_Motion;
	 logic atIntersection, turn_blocked, continue_blocked;
	 logic [9:0] X_motion_final, Y_motion_final;
	 logic [2:0] counter_rand, next_counter_rand;
	 //logic last_turn_blocked;
	 
	 logic [7:0] testing2; // not used
	 logic [7:0] testing; // not used
	 
	 
    parameter [9:0] ghost_X_Center=320;  // Center position on the X axis
    parameter [9:0] ghost_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] ghost_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] ghost_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] ghost_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] ghost_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] ghost_X_Step=1;      // Step size on the X axis
    parameter [9:0] ghost_Y_Step=1;      // Step size on the Y axis
	 
	 logic [9:0] ghost_X_Start;  // Center position on the X axis
	 logic [9:0] ghost_Y_Start;  // Center position on the Y axis
	 assign ghost_X_Start = {x_start, 5'b0};
	 assign ghost_Y_Start = {y_start, 5'b0};

	 logic turnL, turnR, turnU, turnD;
	 logic left, right, up, down; // current motion
	 logic [2:0] turnDir; // LRUD - 0,1,2,3,
	 check_walls check_walls_module(.*, .xpos(ghost_X_Pos[9:5]), .ypos(ghost_Y_Pos[9:5]), .outTurnL(turnL), .outTurnR(turnR), .outTurnU(turnU), .outTurnD(turnD), .testing(testing2) );
	 
    assign ghost_Size = 4;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 
	 //assign testing = {Y_motion_final[3:0], X_motion_final[3:0]};
	 assign testing = {turnL, turnR, turnU, turnD, ghost_X_Pos[8:5]};
	 //assign testing = {ghost_X_Pos[8:5], ghost_Y_Pos[8:5]};
	 
	 logic sameY, sameX;
	 logic [1:0] curr_rand;
	 logic [9:0] cmpX, cmpY;
	 logic [9:0] cmpX2, cmpY2;
	 logic [9:0] absX, absY;
	 logic [9:0] hitX, hitY; // absX-collisionDist and absY-collisionDist
	 logic [9:0] collisionDist;
	 assign collisionDist = 10'h010; // TODO: optimize this, currently: 16
	 
	 logic tooFarDown, tooFarRight, tooFarUp, tooFarLeft;
	 
	 logic sameBlockX, sameBlockY;
	 
	 logic [3:0] dirs;
	 assign dirs = {turnL, turnR, turnU, turnD};
	 always_comb begin
	 
		cmpX2 = (~ghost_X_Pos + 1'b1) + (pacX);
		cmpY2 = (~ghost_Y_Pos + 1'b1) + (pacY);
	 
		cmpX = ghost_X_Pos + (~pacX + 1'b1);
		cmpY = ghost_Y_Pos + (~pacY + 1'b1);
		
		if(cmpX[9])
			absX = cmpX2;
		else
			absX = cmpX;
		if(cmpY[9])
			absY = cmpY2;
		else
			absY = cmpY;
			
		hitX = absX + (~collisionDist + 1'b1);
		hitY = absY + (~collisionDist + 1'b1);
		if((!hitX && hitY[9]) || (!hitY && hitX[9]) )
			hitPacman = 1'b1;
		else
			hitPacman = 1'b0;
		
		
		
		if(!cmpX[9] && cmpX)
		begin
			tooFarRight = 1'b1;
			tooFarLeft = 1'b0;
		end
		else
		begin
			tooFarRight = 1'b0;
			if(cmpX)
				tooFarLeft = 1'b1;
			else
				tooFarLeft = 1'b0;
		end
		if(!cmpY[9] && cmpY)
		begin
			tooFarDown = 1'b1;
			tooFarUp = 1'b0;
		end
		else
		begin
			tooFarDown = 1'b0;
			if(cmpY)
				tooFarUp = 1'b1;
			else
				tooFarUp = 1'b0;
		end
		 
	 
	 /*
	 
		 if (keycode == codeS)
		 begin
			  ghost_Y_Turn_Motion = ghost_Y_Step;
			  ghost_X_Turn_Motion = 10'd0;
			  turn_blocked = ~turnD;
			  turnDir = 3'b011;
		 end
		 else if (keycode == codeW)
		 begin
			  ghost_Y_Turn_Motion = (~ (ghost_Y_Step) + 1'b1);  // 2's complement.
			  ghost_X_Turn_Motion = 10'd0;
			  turn_blocked = ~turnU;
			  turnDir = 3'b010;
		 end
		 else if (keycode == codeD)
		 begin
			  ghost_Y_Turn_Motion = 10'd0;
			  ghost_X_Turn_Motion = ghost_X_Step;
			  turn_blocked = ~turnR;
			  turnDir = 3'b001;
		 end
		 
		 else if (keycode == codeA)
		 begin
			  ghost_Y_Turn_Motion = 10'd0;
			  ghost_X_Turn_Motion = (~ (ghost_X_Step) + 1'b1);  // 2's complement.
			  turn_blocked = ~turnL;
			  turnDir = 3'b000;
		 end
		 else
		 begin
			  ghost_Y_Turn_Motion = last_Y_Turn_Motion;
			  ghost_X_Turn_Motion = last_X_Turn_Motion;
			  //ghost_Y_Turn_Motion = 10'd0;
			  //ghost_X_Turn_Motion = 10'd0;
			  turn_blocked = 1'b1;
			  //turn_blocked = last_turn_blocked;
			  turnDir = 3'b111;
		 end*/
		 
		 unique case (counter_rand)
			3'h0 : curr_rand = randomness[1:0];
			3'h1 : curr_rand = randomness[3:2];
			3'h2 : curr_rand = randomness[5:4];
			3'h3 : curr_rand = randomness[7:6];
			3'h4 : curr_rand = randomness[9:8];
			3'h5 : curr_rand = randomness[11:10];
			3'h6 : curr_rand = randomness[13:12];
			3'h7 : curr_rand = randomness[15:14];
			default : curr_rand = randomness[1:0];
		 endcase
		 sameBlockX = ~( ghost_X_Pos[0] | ghost_X_Pos[1] | ghost_X_Pos[2] | ghost_X_Pos[3] | ghost_X_Pos[4] );
		 sameBlockY = ~( ghost_Y_Pos[0] | ghost_Y_Pos[1] | ghost_Y_Pos[2] | ghost_Y_Pos[3] | ghost_Y_Pos[4] );
		 atIntersection = sameBlockX & sameBlockY;
		 
		 //if(ghost_X_Pos[9:5] == 5'h01)
		 
		 left = ghost_X_Motion[9];
		 up   = ghost_Y_Motion[9];
		 right = ghost_X_Motion[0] & ~ghost_X_Motion[9];
		 down  = ghost_Y_Motion[0] & ~ghost_Y_Motion[9];
		 
		 unique case(dirs)
			4'h0 : begin // no options, go up
				ghost_Y_Turn_Motion = (~ (ghost_Y_Step) + 1'b1);  // 2's complement.
				ghost_X_Turn_Motion = 10'd0;
			end
			4'h1 : begin // D
				ghost_Y_Turn_Motion = ghost_Y_Step;  // 2's complement.
				ghost_X_Turn_Motion = 10'd0;
			end
			4'h2 : begin // U
				ghost_Y_Turn_Motion = (~ (ghost_Y_Step) + 1'b1);  // 2's complement.
				ghost_X_Turn_Motion = 10'd0;
			end
			4'h4 : begin // R
				ghost_Y_Turn_Motion = 10'd0;
				ghost_X_Turn_Motion = ghost_X_Step;  // 2's complement.
			end
			4'h8 : begin // L
				ghost_Y_Turn_Motion = 10'd0;
				ghost_X_Turn_Motion = (~ (ghost_X_Step) + 1'b1);  // 2's complement.
			end
			4'hc : begin // LR
				if(curr_rand == 2'b11) // 25% chance of going back
				begin
					if(left)
					begin
						ghost_Y_Turn_Motion = 10'd0;
						ghost_X_Turn_Motion = ghost_X_Step;  // 2's complement.
					end
					else begin
						ghost_Y_Turn_Motion = 10'd0;
						ghost_X_Turn_Motion = (~ (ghost_X_Step) + 1'b1);  // 2's complement.
					end
				end
				else begin
					if(left)
					begin
						ghost_Y_Turn_Motion = 10'd0;
						ghost_X_Turn_Motion = (~ (ghost_X_Step) + 1'b1);  // 2's complement.
					end
					else begin
						ghost_Y_Turn_Motion = 10'd0;
						ghost_X_Turn_Motion = ghost_X_Step;  // 2's complement.
					end
				end
			end
			4'ha : begin // LU
				if(curr_rand == 2'b11) // 25% chance of going back
				begin
					if(down)
					begin
						ghost_Y_Turn_Motion = (~ (ghost_Y_Step) + 1'b1);  // 2's complement.
						ghost_X_Turn_Motion = 10'd0;
					end
					else begin
						ghost_Y_Turn_Motion = 10'd0;
						ghost_X_Turn_Motion = (~ (ghost_X_Step) + 1'b1);  // 2's complement.
					end
				end
				else begin
					if(down)
					begin
						ghost_Y_Turn_Motion = 10'd0;
						ghost_X_Turn_Motion = (~ (ghost_X_Step) + 1'b1);  // 2's complement.
					end
					else begin
						ghost_Y_Turn_Motion = (~ (ghost_Y_Step) + 1'b1);  // 2's complement.
						ghost_X_Turn_Motion = 10'd0;
					end
				end
			end
			4'h9 : begin // LD
				if(curr_rand == 2'b11) // 25% chance of going back
				begin
					if(up)
					begin
						ghost_Y_Turn_Motion = ghost_Y_Step;
						ghost_X_Turn_Motion = 10'd0;
					end
					else begin
						ghost_Y_Turn_Motion = 10'd0;
						ghost_X_Turn_Motion = (~ (ghost_X_Step) + 1'b1);  // 2's complement.
					end
				end
				else begin
					if(up)
					begin
						ghost_Y_Turn_Motion = 10'd0;
						ghost_X_Turn_Motion = (~ (ghost_X_Step) + 1'b1);  // 2's complement.
					end
					else begin
						ghost_Y_Turn_Motion = ghost_Y_Step;
						ghost_X_Turn_Motion = 10'd0;
					end
				end
			end
			4'h6 : begin // RU
				if(curr_rand == 2'b11) // 25% chance of going back
				begin
					if(down)
					begin
						ghost_Y_Turn_Motion = (~ (ghost_Y_Step) + 1'b1);  // 2's complement.
						ghost_X_Turn_Motion = 10'd0;
					end
					else begin
						ghost_Y_Turn_Motion = 10'd0;
						ghost_X_Turn_Motion = ghost_X_Step;
					end
				end
				else begin
					if(down)
					begin
						ghost_Y_Turn_Motion = 10'd0;
						ghost_X_Turn_Motion = ghost_X_Step;
					end
					else begin
						ghost_Y_Turn_Motion = (~ (ghost_Y_Step) + 1'b1);  // 2's complement.
						ghost_X_Turn_Motion = 10'd0;
					end
				end
			end
			4'h5 : begin // RD
				if(curr_rand == 2'b11) // 25% chance of going back
				begin
					if(up)
					begin
						ghost_Y_Turn_Motion = ghost_Y_Step;
						ghost_X_Turn_Motion = 10'd0;
					end
					else begin
						ghost_Y_Turn_Motion = 10'd0;
						ghost_X_Turn_Motion = ghost_X_Step;
					end
				end
				else begin
					if(up)
					begin
						ghost_Y_Turn_Motion = 10'd0;
						ghost_X_Turn_Motion = ghost_X_Step;
					end
					else begin
						ghost_Y_Turn_Motion = ghost_Y_Step;
						ghost_X_Turn_Motion = 10'd0;
					end
				end
			end
			4'h3 : begin // UD
				if(curr_rand == 2'b11) // 25% chance of going back
				begin
					if(up)
					begin
						ghost_Y_Turn_Motion = ghost_Y_Step;
						ghost_X_Turn_Motion = 10'd0;
					end
					else begin
						ghost_Y_Turn_Motion = (~ (ghost_Y_Step) + 1'b1);  // 2's complement.
						ghost_X_Turn_Motion = 10'd0;
					end
				end
				else begin
					if(up)
					begin
						ghost_Y_Turn_Motion = (~ (ghost_Y_Step) + 1'b1);  // 2's complement.
						ghost_X_Turn_Motion = 10'd0;
					end
					else begin
						ghost_Y_Turn_Motion = ghost_Y_Step;
						ghost_X_Turn_Motion = 10'd0;
					end
				end
			end
			4'he : begin // LRU
				if(tooFarDown)
				begin
					ghost_Y_Turn_Motion = (~ (ghost_Y_Step) + 1'b1);  // 2's complement.
					ghost_X_Turn_Motion = 10'd0;
				end
				else if(tooFarRight)
				begin
					ghost_Y_Turn_Motion = 10'd0;
					ghost_X_Turn_Motion = (~ (ghost_X_Step) + 1'b1);  // 2's complement.
				end
				else begin
					ghost_Y_Turn_Motion = 10'd0;
					ghost_X_Turn_Motion = ghost_X_Step;
				end
			end
			4'hd : begin // LRD
				if(tooFarUp)
				begin
					ghost_Y_Turn_Motion = ghost_Y_Step;
					ghost_X_Turn_Motion = 10'd0;
				end
				else if(tooFarRight)
				begin
					ghost_Y_Turn_Motion = 10'd0;
					ghost_X_Turn_Motion = (~ (ghost_X_Step) + 1'b1);  // 2's complement.
				end
				else begin
					ghost_Y_Turn_Motion = 10'd0;
					ghost_X_Turn_Motion = ghost_X_Step;
				end
			end
			4'hb : begin // LUD
				if(tooFarRight)
				begin
					ghost_Y_Turn_Motion = 10'd0;
					ghost_X_Turn_Motion = (~ (ghost_X_Step) + 1'b1);  // 2's complement.
				end
				else if(tooFarDown)
				begin
					ghost_Y_Turn_Motion = (~ (ghost_Y_Step) + 1'b1);  // 2's complement.
					ghost_X_Turn_Motion = 10'd0;
				end
				else begin
					ghost_Y_Turn_Motion = ghost_Y_Step;
					ghost_X_Turn_Motion = 10'd0;
				end
			end
			4'h7 : begin // RUD
				if(tooFarLeft)
				begin
					ghost_Y_Turn_Motion = 10'd0;
					ghost_X_Turn_Motion = ghost_X_Step;
				end
				else if(tooFarDown)
				begin
					ghost_Y_Turn_Motion = (~ (ghost_Y_Step) + 1'b1);  // 2's complement.
					ghost_X_Turn_Motion = 10'd0;
				end
				else begin
					ghost_Y_Turn_Motion = ghost_Y_Step;
					ghost_X_Turn_Motion = 10'd0;
				end
			end
			4'hf : begin // LRUD
				unique case (curr_rand) // may eventually replace with heuristic based logic
					2'b00 : begin // go L
						ghost_Y_Turn_Motion = 10'd0;
						ghost_X_Turn_Motion = (~ (ghost_X_Step) + 1'b1);  // 2's complement.
					end
					2'b01 : begin // go R
						ghost_Y_Turn_Motion = 10'd0;
						ghost_X_Turn_Motion = ghost_X_Step;
					end
					2'b10 : begin // go U
						ghost_Y_Turn_Motion = (~ (ghost_Y_Step) + 1'b1);  // 2's complement.
						ghost_X_Turn_Motion = 10'd0;
					end
					2'b11 : begin // go D
						ghost_Y_Turn_Motion = ghost_Y_Step;
						ghost_X_Turn_Motion = 10'd0;
					end
				endcase
			end
		 
		 endcase
		 //testing = {left,right,up,down, 1'b0 ,turnDir};
		 
		 
		 ghost_X_Continue_Motion = ghost_X_Motion;
		 ghost_Y_Continue_Motion = ghost_Y_Motion;
		 /*
		 if(atIntersection)
		 begin
				if(right && turnR)
				begin
					ghost_X_Continue_Motion = ghost_X_Step;
					ghost_Y_Continue_Motion = 10'd0;
				end
				else if(left && turnL)
				begin
					ghost_X_Continue_Motion = (~ (ghost_X_Step) + 1'b1);
					ghost_Y_Continue_Motion = 10'd0;
				end
				else if(up && turnU)
				begin
					ghost_X_Continue_Motion = 10'd0;
					ghost_Y_Continue_Motion = (~ (ghost_Y_Step) + 1'b1);
				end
				else if(down && turnD)
				begin
					ghost_X_Continue_Motion = 10'd0;
					ghost_Y_Continue_Motion = ghost_Y_Step;
				end
				else
				begin
					ghost_X_Continue_Motion = 10'd0;
					ghost_Y_Continue_Motion = 10'd0;
				end
				
		 end
		 else begin*/
		 
		 /*  																ghosts only turn at intersections
				if(turnDir == 3'b000 && right)
				begin
					ghost_X_Continue_Motion = (~ (ghost_X_Step) + 1'b1);
					ghost_Y_Continue_Motion = 10'd0;
				end
				else if(turnDir == 3'b001 && left)
				begin
					ghost_X_Continue_Motion = ghost_X_Step;
					ghost_Y_Continue_Motion = 10'd0;
				end
				else if(turnDir == 3'b010 && down)
				begin
					ghost_X_Continue_Motion = 10'd0;
					ghost_Y_Continue_Motion = (~ (ghost_Y_Step) + 1'b1);
				end
				else if(turnDir == 3'b011 && up)
				begin
					ghost_X_Continue_Motion = 10'd0;
					ghost_Y_Continue_Motion = ghost_Y_Step;
				end
				else
				begin
					ghost_X_Continue_Motion = ghost_X_Motion;
					ghost_Y_Continue_Motion = ghost_Y_Motion;
				end
		 end */
		 
		 if(atIntersection == 1'b0)
		 begin
				Y_motion_final = ghost_Y_Continue_Motion;
				X_motion_final = ghost_X_Continue_Motion;
				next_counter_rand = counter_rand;
		 end
		 else begin
				Y_motion_final = ghost_Y_Turn_Motion;
				X_motion_final = ghost_X_Turn_Motion;
				
				unique case (counter_rand)
					3'h0 : next_counter_rand = 3'h1;
					3'h1 : next_counter_rand = 3'h2;
					3'h2 : next_counter_rand = 3'h3;
					3'h3 : next_counter_rand = 3'h4;
					3'h4 : next_counter_rand = 3'h5;
					3'h5 : next_counter_rand = 3'h6;
					3'h6 : next_counter_rand = 3'h7;
					3'h7 : next_counter_rand = 3'h0;
					default : next_counter_rand = 3'h1;
				endcase
		 end
		 
		 
		 //if(wall)
		 //begin
			//ghost_Y_Continue_Motion = 10'd0;
			//ghost_X_Continue_Motion = 10'd0;
		 //end
	 end
	 
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_ghost
        if (Reset)  // Asynchronous Reset
        begin
            ghost_Y_Motion <= 10'd0; //ghost_Y_Step;
				ghost_X_Motion <= 10'd0; //ghost_X_Step;
				ghost_Y_Pos <= ghost_Y_Start;
				ghost_X_Pos <= ghost_X_Start;
				last_Y_Turn_Motion <= 10'd0;
				last_X_Turn_Motion <= 10'd0;
				counter_rand <= 3'h0;
        end
           
        else
        begin
				 last_Y_Turn_Motion <= ghost_Y_Turn_Motion;
				 last_X_Turn_Motion <= ghost_X_Turn_Motion;
				 ghost_Y_Motion <= Y_motion_final;
				 ghost_X_Motion <= X_motion_final;
				 
				 ghost_Y_Pos <= (ghost_Y_Pos + Y_motion_final);  // Update ghost position
				 ghost_X_Pos <= (ghost_X_Pos + X_motion_final);
			
				 counter_rand <= next_counter_rand;
		end  
    end
       
    assign ghostX = ghost_X_Pos;
   
    assign ghostY = ghost_Y_Pos;
   
    //assign ghostS = ghost_Size;
    

endmodule
