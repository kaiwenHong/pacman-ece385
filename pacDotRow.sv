module pacDotRow ( 
					input  clk,
					input	 reset,
					input  atIntersection,
					input  [11:0] dotRowStart,
					input  [9:0] pacX, pacY,
					input  [4:0] dotY,
					output anyLeft,
					output [11:0] stillHere
               );
	
	//logic anyLeft;
	always_comb begin
		if(stillHere)
			anyLeft = 1'b1;
		else 
			anyLeft = 1'b0;
	end
	
	//Dot1, index 11 is far left
	pacDot pacDot1 ( .*, .resetVal(dotRowStart[11]), .dotX(5'h01), .stillHere(stillHere[11]));
	pacDot pacDot2 ( .*, .resetVal(dotRowStart[10]), .dotX(5'h02), .stillHere(stillHere[10]));
	pacDot pacDot3 ( .*, .resetVal(dotRowStart[9]), .dotX(5'h03), .stillHere(stillHere[9]));
	pacDot pacDot4 ( .*, .resetVal(dotRowStart[8]), .dotX(5'h04), .stillHere(stillHere[8]));
	pacDot pacDot5 ( .*, .resetVal(dotRowStart[7]), .dotX(5'h05), .stillHere(stillHere[7]));
	pacDot pacDot6 ( .*, .resetVal(dotRowStart[6]), .dotX(5'h06), .stillHere(stillHere[6]));
	pacDot pacDot7 ( .*, .resetVal(dotRowStart[5]), .dotX(5'h07), .stillHere(stillHere[5]));
	pacDot pacDot8 ( .*, .resetVal(dotRowStart[4]), .dotX(5'h08), .stillHere(stillHere[4]));
	pacDot pacDot9 ( .*, .resetVal(dotRowStart[3]), .dotX(5'h09), .stillHere(stillHere[3]));
	pacDot pacDot10 ( .*, .resetVal(dotRowStart[2]), .dotX(5'h0a), .stillHere(stillHere[2]));
	pacDot pacDot11 ( .*, .resetVal(dotRowStart[1]), .dotX(5'h0b), .stillHere(stillHere[1]));
	pacDot pacDot12 ( .*, .resetVal(dotRowStart[0]), .dotX(5'h0c), .stillHere(stillHere[0]));	

endmodule
