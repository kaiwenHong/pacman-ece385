module check_walls #(N = 12) (
					input [0:N*(N+1) - 1]  horiz_walls, vert_walls,
					input [0:4] xpos, ypos,
					output [0:7] testing,
               output logic outTurnL, outTurnR, outTurnU, outTurnD 
					);

	 logic [0:11] turnL, turnR, turnU, turnD;
	 
	 check_walls_row check_walls_row0( .*, .turnD(turnD[0]),  .turnL(turnL[0]),  .turnR(turnR[0]),  .turnU(turnU[0]),  .vert_walls(vert_walls[0:N]),                 .above_walls(horiz_walls[0:N-1]),       .below_walls(horiz_walls[N:2*N-1]));
	 check_walls_row check_walls_row1( .*, .turnD(turnD[1]),  .turnL(turnL[1]),  .turnR(turnR[1]),  .turnU(turnU[1]),  .vert_walls(vert_walls[   N+1 :2*(N+1)-1]),   .above_walls(horiz_walls[N:2*N-1]),     .below_walls(horiz_walls[2*N:3*N-1]));
	 check_walls_row check_walls_row2( .*, .turnD(turnD[2]),  .turnL(turnL[2]),  .turnR(turnR[2]),  .turnU(turnU[2]),  .vert_walls(vert_walls[2*(N+1):3*(N+1)-1]),   .above_walls(horiz_walls[2*N:3*N-1]),   .below_walls(horiz_walls[3*N:4*N-1]));
	 check_walls_row check_walls_row3( .*, .turnD(turnD[3]),  .turnL(turnL[3]),  .turnR(turnR[3]),  .turnU(turnU[3]),  .vert_walls(vert_walls[3*(N+1):4*(N+1)-1]),   .above_walls(horiz_walls[3*N:4*N-1]),   .below_walls(horiz_walls[4*N:5*N-1]));
	 check_walls_row check_walls_row4( .*, .turnD(turnD[4]),  .turnL(turnL[4]),  .turnR(turnR[4]),  .turnU(turnU[4]),  .vert_walls(vert_walls[4*(N+1):5*(N+1)-1]),   .above_walls(horiz_walls[4*N:5*N-1]),   .below_walls(horiz_walls[5*N:6*N-1]));
	 check_walls_row check_walls_row5( .*, .turnD(turnD[5]),  .turnL(turnL[5]),  .turnR(turnR[5]),  .turnU(turnU[5]),  .vert_walls(vert_walls[5*(N+1):6*(N+1)-1]),   .above_walls(horiz_walls[5*N:6*N-1]),   .below_walls(horiz_walls[6*N:7*N-1]));
	 check_walls_row check_walls_row6( .*, .turnD(turnD[6]),  .turnL(turnL[6]),  .turnR(turnR[6]),  .turnU(turnU[6]),  .vert_walls(vert_walls[6*(N+1):7*(N+1)-1]),   .above_walls(horiz_walls[6*N:7*N-1]),   .below_walls(horiz_walls[7*N:8*N-1]));
	 check_walls_row check_walls_row7( .*, .turnD(turnD[7]),  .turnL(turnL[7]),  .turnR(turnR[7]),  .turnU(turnU[7]),  .vert_walls(vert_walls[7*(N+1):8*(N+1)-1]),   .above_walls(horiz_walls[7*N:8*N-1]),   .below_walls(horiz_walls[8*N:9*N-1]));
	 check_walls_row check_walls_row8( .*, .turnD(turnD[8]),  .turnL(turnL[8]),  .turnR(turnR[8]),  .turnU(turnU[8]),  .vert_walls(vert_walls[8*(N+1):9*(N+1)-1]),   .above_walls(horiz_walls[8*N:9*N-1]),   .below_walls(horiz_walls[9*N:10*N-1]));
	 check_walls_row check_walls_row9( .*, .turnD(turnD[9]),  .turnL(turnL[9]),  .turnR(turnR[9]),  .turnU(turnU[9]),  .vert_walls(vert_walls[9*(N+1):10*(N+1)-1]),  .above_walls(horiz_walls[9*N:10*N-1]),  .below_walls(horiz_walls[10*N:11*N-1]));
	 check_walls_row check_walls_row10(.*, .turnD(turnD[10]), .turnL(turnL[10]), .turnR(turnR[10]), .turnU(turnU[10]), .vert_walls(vert_walls[10*(N+1):11*(N+1)-1]), .above_walls(horiz_walls[10*N:11*N-1]), .below_walls(horiz_walls[11*N:12*N-1]));
	 check_walls_row check_walls_row11(.*, .turnD(turnD[11]), .turnL(turnL[11]), .turnR(turnR[11]), .turnU(turnU[11]), .vert_walls(vert_walls[11*(N+1):12*(N+1)-1]), .above_walls(horiz_walls[11*N:12*N-1]), .below_walls(horiz_walls[12*N:13*N-1]));
	 
	 assign testing = {turnL[0], turnR[0], turnU[0], turnD[0], vert_walls[0], vert_walls[1], vert_walls[11], vert_walls[12]};
	 
	 always_comb begin
		 unique case (ypos)
		 5'h00 : begin
				outTurnD = 1'b1;
				outTurnU = 1'b0;
				outTurnR = 1'b0;
				outTurnL = 1'b0;
		 end
		 5'h01 : begin
				outTurnD = turnD[0];
				outTurnU = turnU[0];
				outTurnR = turnR[0];
				outTurnL = turnL[0];
		 end
		 5'h02 : begin
				outTurnD = turnD[1];
				outTurnU = turnU[1];
				outTurnR = turnR[1];
				outTurnL = turnL[1];
		 end
		 5'h03 : begin
				outTurnD = turnD[2];
				outTurnU = turnU[2];
				outTurnR = turnR[2];
				outTurnL = turnL[2];
		 end
		 5'h04 : begin
				outTurnD = turnD[3];
				outTurnU = turnU[3];
				outTurnR = turnR[3];
				outTurnL = turnL[3];
		 end
		 5'h05 : begin
				outTurnD = turnD[4];
				outTurnU = turnU[4];
				outTurnR = turnR[4];
				outTurnL = turnL[4];
		 end
		 5'h06 : begin
				outTurnD = turnD[5];
				outTurnU = turnU[5];
				outTurnR = turnR[5];
				outTurnL = turnL[5];
		 end
		 5'h07 : begin
				outTurnD = turnD[6];
				outTurnU = turnU[6];
				outTurnR = turnR[6];
				outTurnL = turnL[6];
		 end
		 5'h08 : begin
				outTurnD = turnD[7];
				outTurnU = turnU[7];
				outTurnR = turnR[7];
				outTurnL = turnL[7];
		 end
		 5'h09 : begin
				outTurnD = turnD[8];
				outTurnU = turnU[8];
				outTurnR = turnR[8];
				outTurnL = turnL[8];
		 end
		 5'h0a : begin
				outTurnD = turnD[9];
				outTurnU = turnU[9];
				outTurnR = turnR[9];
				outTurnL = turnL[9];
		 end
		 5'h0b : begin
				outTurnD = turnD[10];
				outTurnU = turnU[10];
				outTurnR = turnR[10];
				outTurnL = turnL[10];
		 end
		 5'h0c : begin
				outTurnD = turnD[11];
				outTurnU = turnU[11];
				outTurnR = turnR[11];
				outTurnL = turnL[11];
		 end
		 default : begin
				outTurnD = 1'b0;
				outTurnU = 1'b1;
				outTurnR = 1'b0;
				outTurnL = 1'b0;
		 end
		 endcase
	 end

endmodule
