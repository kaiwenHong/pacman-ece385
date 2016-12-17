module control ( 
					input  clk,
					input	 reset,
					input  [15:0]keycode,
					input  pacManDied,
					input  anyDotsLeft,
					output  [1:0] level,
					output isPre,
					output resetAll,
					output [2:0] temp,
					output [4:0] displayLevel
               );
    
	 
	 enum logic [2:0] { LEVEL1, LEVEL2, BEAT1, BEAT2, NEWGAME } state, next_state;
	 logic [15:0] codeEnter;
	 assign codeEnter = 16'h0028;
	 logic next_resetAll;
	
	assign temp = state;
	
	always_ff @ (posedge clk or posedge reset) begin
		if (reset) begin
			state <= NEWGAME;
//			state <= LEVEL1;
			resetAll <= 1'b1;
		end else begin
			state <= next_state;
			resetAll <= next_resetAll;
		end
	end
	
	always_comb begin
		next_state = state;
		next_resetAll = resetAll;
		
		if(pacManDied)
		begin
			next_state = NEWGAME;
//			next_state = LEVEL1;
			next_resetAll = 1'b1;
		end
		else begin
			case (state)
			NEWGAME : begin
				next_resetAll = 1'b0;
				if(keycode == codeEnter)
					next_state = LEVEL1;
				else 
					next_state = NEWGAME;
			end
			LEVEL1 : begin
				if(anyDotsLeft)
				begin
					next_state = LEVEL1;
					next_resetAll = 1'b0;
				end
				else begin
					next_state = BEAT1;
					next_resetAll = 1'b1;
				end
			end
			LEVEL2 : begin
				if(anyDotsLeft)
				begin
					next_state = LEVEL2;
					next_resetAll = 1'b0;
				end
				else begin
					next_state = BEAT2;
					next_resetAll = 1'b1;
				end
			end
			BEAT1 : begin
				next_resetAll = 1'b0;
				if(keycode == codeEnter)
					next_state = LEVEL2;
				else 
					next_state = BEAT1;
			end
			BEAT2 : begin
				next_resetAll = 1'b0;
				if(keycode == codeEnter)
					next_state = LEVEL1;
				else 
					next_state = BEAT2;
			end
			
			endcase
		end
		
	end
	
	always_comb begin
		isPre = 1'b0;
		case (state)
			NEWGAME: begin
				level = 2'b01;
				isPre = 1'b1;
			end
			LEVEL1 : begin
				level = 2'b01;
			end
			LEVEL2 : begin
				level = 2'b10;
			end
			BEAT1 : begin
				level = 2'b10;
				isPre = 1'b1;
			end
			BEAT2 : begin
				level = 2'b01;
				isPre = 1'b1;
			end
		endcase
	end
	
	

endmodule
