module check_walls_row #(N = 12) ( 
					input [0:N]  vert_walls,
					input [0:N-1] below_walls, above_walls,
					input [0:4] xpos,
               output logic turnL, turnR, turnU, turnD
					);
    
	 always_comb begin
		 unique case (xpos)
		 5'h00 : begin
				turnD = 1'b0;
				turnU = 1'b0;
				turnL = 1'b0;
				turnR = 1'b1;
		 end
		 5'h01 : begin
				turnD = ~below_walls[0];
				turnU = ~above_walls[0];
				turnL = ~vert_walls[0];
				turnR = ~vert_walls[1];
		 end
		 5'h02 : begin
				turnD = ~below_walls[1];
				turnU = ~above_walls[1];
				turnL = ~vert_walls[1];
				turnR = ~vert_walls[2];
		 end
		 5'h03 : begin
				turnD = ~below_walls[2];
				turnU = ~above_walls[2];
				turnL = ~vert_walls[2];
				turnR = ~vert_walls[3];
		 end
		 5'h04 : begin
				turnD = ~below_walls[3];
				turnU = ~above_walls[3];
				turnL = ~vert_walls[3];
				turnR = ~vert_walls[4];
		 end
		 5'h05 : begin
				turnD = ~below_walls[4];
				turnU = ~above_walls[4];
				turnL = ~vert_walls[4];
				turnR = ~vert_walls[5];
		 end
		 5'h06 : begin
				turnD = ~below_walls[5];
				turnU = ~above_walls[5];
				turnL = ~vert_walls[5];
				turnR = ~vert_walls[6];
		 end
		 5'h07 : begin
				turnD = ~below_walls[6];
				turnU = ~above_walls[6];
				turnL = ~vert_walls[6];
				turnR = ~vert_walls[7];
		 end
		 5'h08 : begin
				turnD = ~below_walls[7];
				turnU = ~above_walls[7];
				turnL = ~vert_walls[7];
				turnR = ~vert_walls[8];
		 end
		 5'h09 : begin
				turnD = ~below_walls[8];
				turnU = ~above_walls[8];
				turnL = ~vert_walls[8];
				turnR = ~vert_walls[9];
		 end
		 5'h0a : begin
				turnD = ~below_walls[9];
				turnU = ~above_walls[9];
				turnL = ~vert_walls[9];
				turnR = ~vert_walls[10];
		 end
		 5'h0b : begin
				turnD = ~below_walls[10];
				turnU = ~above_walls[10];
				turnL = ~vert_walls[10];
				turnR = ~vert_walls[11];
		 end
		 5'h0c : begin
				turnD = ~below_walls[11];
				turnU = ~above_walls[11];
				turnL = ~vert_walls[11];
				turnR = ~vert_walls[12];
		 end
		 default : begin
				turnD = 1'b0;
				turnU = 1'b0;
				turnL = 1'b1;
				turnR = 1'b0;
		 end
		 endcase
	 end

endmodule
