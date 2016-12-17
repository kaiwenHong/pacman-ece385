module allPacDots ( 
					input  clk,
					input	 reset,
					input  [143:0] dotStarts,
					input  [9:0] pacX, pacY,
					
					output anyLeft,
					output [143:0] stillHere
               );
    
	 
	 
	logic atIntersection;
	assign atIntersection = ~(pacX[0] | pacX[1] | pacX[2] | pacX[3] | pacX[4] | pacY[0] | pacY[1] | pacY[2] | pacY[3] | pacY[4]);
	
	logic anyLeftRows[11:0];
	always_comb begin
		if(anyLeftRows)
			anyLeft = 1'b1;
		else 
			anyLeft = 1'b0;
	end
	
	
	pacDotRow dotRow1  ( .*, .dotRowStart(dotStarts[143:132]), .dotY(5'h01), .stillHere(stillHere[143:132]), .anyLeft(anyLeftRows[11]));
	pacDotRow dotRow2  ( .*, .dotRowStart(dotStarts[131:120]), .dotY(5'h02), .stillHere(stillHere[131:120]), .anyLeft(anyLeftRows[10]));
	pacDotRow dotRow3  ( .*, .dotRowStart(dotStarts[119:108]), .dotY(5'h03), .stillHere(stillHere[119:108]), .anyLeft(anyLeftRows[9]));
	pacDotRow dotRow4  ( .*, .dotRowStart(dotStarts[107:96]),  .dotY(5'h04), .stillHere(stillHere[107:96] ), .anyLeft(anyLeftRows[8]));
	pacDotRow dotRow5  ( .*, .dotRowStart(dotStarts[95:84]),   .dotY(5'h05), .stillHere(stillHere[95:84]  ), .anyLeft(anyLeftRows[7]));
	pacDotRow dotRow6  ( .*, .dotRowStart(dotStarts[83:72]),   .dotY(5'h06), .stillHere(stillHere[83:72]  ), .anyLeft(anyLeftRows[6]));
	pacDotRow dotRow7  ( .*, .dotRowStart(dotStarts[71:60]),   .dotY(5'h07), .stillHere(stillHere[71:60]  ), .anyLeft(anyLeftRows[5]));
	pacDotRow dotRow8  ( .*, .dotRowStart(dotStarts[59:48]),   .dotY(5'h08), .stillHere(stillHere[59:48]  ), .anyLeft(anyLeftRows[4]));
	pacDotRow dotRow9  ( .*, .dotRowStart(dotStarts[47:36]),   .dotY(5'h09), .stillHere(stillHere[47:36]  ), .anyLeft(anyLeftRows[3]));
	pacDotRow dotRow10 ( .*, .dotRowStart(dotStarts[35:24]),   .dotY(5'h0a), .stillHere(stillHere[35:24]  ), .anyLeft(anyLeftRows[2]));
	pacDotRow dotRow11 ( .*, .dotRowStart(dotStarts[23:12]),   .dotY(5'h0b), .stillHere(stillHere[23:12]  ), .anyLeft(anyLeftRows[1]));
	pacDotRow dotRow12 ( .*, .dotRowStart(dotStarts[11:0] ),   .dotY(5'h0c), .stillHere(stillHere[11:0]   ), .anyLeft(anyLeftRows[0]));
	
	


endmodule
