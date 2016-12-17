module pacDot ( 
					input  clk,
					input	 reset,
					input  resetVal,
					input  atIntersection,
					input  [9:0] pacX, pacY,
					input  [4:0] dotX, dotY,
					output stillHere
               );
    
	 
	 enum logic [1:0] { EATEN, UNEATEN } state, next_state;
	 
	
	always_ff @ (posedge clk, posedge reset) begin
		if (reset == 1'b1) begin
			state <= UNEATEN;
		end else begin
			state <= next_state;
		end
	end
	
	always_comb begin
		next_state = state;
		
		case (state)
		UNEATEN : begin
			if(dotX == pacX[9:5] && dotY == pacY[9:5] && atIntersection)
				next_state = EATEN;
			else 
				next_state = state;
		end
		EATEN : begin
			next_state = state;
		end		
		endcase
		
	end
	
	always_comb begin
		stillHere = resetVal;
		case (state)
			EATEN: begin
				stillHere = 1'b0;
			end
			UNEATEN : begin
				stillHere = resetVal;
			end
		endcase
	end
	
	

endmodule
