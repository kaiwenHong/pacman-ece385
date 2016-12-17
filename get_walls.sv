module get_walls ( 
					input  [1:0] level,
					input  isPre,
					output [155:0] horiz_walls, vert_walls
               );
    
    logic [155:0] lvl0vert, lvl0horiz, lvl1vert, lvl1horiz, lvl2vert, lvl2horiz, defaultVert, defaultHoriz;
	 //logic [155:0] lvl1vertPre, lvl1horizPre; //unused, outdated
	 
	 always_comb begin
	 
			if (isPre)
			begin
				horiz_walls = defaultHoriz;
				vert_walls = defaultVert;
			end
			else begin
				unique case (level)
				2'b00 : begin
					horiz_walls = lvl0horiz;
					vert_walls  = lvl0vert;
				end
				2'b01 : begin
					horiz_walls = lvl1horiz;
					vert_walls  = lvl1vert;
				end
				2'b10 : begin
					horiz_walls = lvl2horiz;
					vert_walls  = lvl2vert;
				end
				default : begin
					horiz_walls = {156{1'b1}};
					vert_walls  = {156{1'b0}};
				end
			
				endcase
			end
			
	 end
   
	
    assign defaultVert = { // ghosts stay in center and pacman can't move
		 13'h1fff,
		 13'h1fff,
		 13'h1fff,
		 13'h1fff,
		 13'h1fff,
		 13'h1fbf,
		 13'h1fbf,
		 13'h1fff,
		 13'h1fff,
		 13'h1fff,
		 13'h1fff,
		 13'h1fff
	 };
	 
	 assign defaultHoriz = {
		{12{1'b1}},
		{12{1'b1}},
		{12{1'b1}},
		{12{1'b1}},
		{12{1'b1}},
		{12{1'b1}},
		12'hf9f,
		{12{1'b1}},
		{12{1'b1}},
		{12{1'b1}},
		{12{1'b1}},
		{12{1'b1}},
		{12{1'b1}}
	 };
	 
	 assign lvl0vert = { //12{13'h1001}};
		 13'h1001,
		 13'h1001,
		 13'h1001,
		 13'h1001,
		 13'h1001,
		 13'h1001,
		 13'h1001,
		 13'h1001,
		 13'h1181,
		 13'h1181,
		 13'h1181,
		 13'h1181
	 };
	 
	 assign lvl0horiz = {
		{12{1'b1}},
		{12{1'b0}},
		{12{1'b0}},
		{12{1'b0}},
		{12{1'b0}},
		{12{1'b0}},
		{12{1'b0}},
		{12{1'b0}},
		{12{1'b0}},
		{12{1'b0}},
		{12{1'b0}},
		{12{1'b0}},
		{12{1'b1}}
	 };
	 
	 assign lvl1vert = {
		 13'h1843,
		 13'h1fff,
		 13'h1803,
		 13'h1953,
		 13'h1b1b,
		 13'h18e3,
		 13'h1bfb,
		 13'h1b1b,
		 13'h1843,
		 13'h1a0b,
		 13'h1953,
		 13'h1803
	 };
	 
	 assign lvl1horiz = {
		{12{1'b1}},
		12'h294,
		12'h294,
		12'h264,
		12'h696,
		12'h666,
		12'h666,
		12'h060,
		12'h666,
		12'h294,
		12'h462,
		12'h39c,
		12'hfff
	 };
	 
	 assign lvl2vert = {
		 13'h1041,
		 13'h1eef,
		 13'h1001,
		 13'h1151,
		 13'h1319,
		 13'h10e1,
		 13'h13f9,
		 13'h1319,
		 13'h1041,
		 13'h1209,
		 13'h1151,
		 13'h1001
	 };
	 
	 assign lvl2horiz = {
		{12{1'b1}},
		12'h59a,
		12'h59a,
		12'h666,
		12'he97,
		12'he67,
		12'he67,
		12'h060,
		12'he67,
		12'h696,
		12'hc63,
		12'h79e,
		12'hfff
	 };
	 /*
	 assign lvl1vertPre = {
		 13'h1843,
		 13'h1fff,
		 13'h1803,
		 13'h1953,
		 13'h1b1b,
		 13'h18a3,
		 13'h1bbb,
		 13'h1b1b,
		 13'h1843,
		 13'h1a0b,
		 13'h195b,
		 13'h1803
	 };
	 
	 assign lvl1horizPre = {
		12'hfff,
		12'h298,
		12'h298,
		12'h264,
		12'h696,
		12'h666,
		12'h606,
		12'h060,
		12'h666,
		12'h294,
		12'h462,
		12'h39c,
		12'hfff
	 };
	 */
    

endmodule
