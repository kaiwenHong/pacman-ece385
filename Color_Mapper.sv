//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input  [9:0] BallX, BallY, DrawX, DrawY, Ball_size, oghostx, oghosty, bghostx, bghosty, rghostx, rghosty, pghostx, pghosty,
							  input  [0:143] currDotMap,
							  input 	[1:0] Direction, level,
							 // input	Level,
                       output logic [7:0]  Red, Green, Blue );

    logic ball_on, oghost_on, bghost_on, rghost_on, pghost_on, dot_on;
		logic wall_on;

 /* Old Ball: Generated square box by checking if the current pixel is within a square of length
    2*Ball_Size, centered at (BallX, BallY).  Note that this requires unsigned comparisons.

    if ((DrawX >= BallX - Ball_size) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY >= BallY - Ball_size) &&
       (DrawY <= BallY + Ball_size))

     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 12 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */

//    int DistX, DistY, Size;
//	 assign DistX = DrawX - BallX;
//    assign DistY = DrawY - BallY;
//    assign Size = Ball_size;
//
	 logic [7:0]sprite_addr;
	 logic [7:0]oghost_addr;
	 logic [7:0]bghost_addr;
	 logic [7:0]rghost_addr;
	 logic [7:0]pghost_addr;
	 
	 logic [0:31]sprite_data;
	 logic [31:0]oghost_data;
	 logic [31:0]bghost_data;
	 logic [31:0]rghost_data;
	 logic [31:0]pghost_data;

	 logic [9:0]wall_addr;
	 logic [415:0]wall_data;
	 
	 logic [2:0] dot_addr;
	 logic [1:0] dot_data;
	 
	 
	 logic [9:0] xp2, yp2;
	 assign xp2 = DrawX + 2 - 32;
	 assign yp2 = DrawY + 2 - 32;
	 
	 
	 logic [9:0] tmp1;
	 assign tmp1 = (DrawY - BallY + Ball_size + 96 + 32 * Direction);
	 
	 spriteData spritePac(.addr(sprite_addr), .data(sprite_data));
	 spriteData spriteOrange(.addr(oghost_addr), .data(oghost_data));
	 spriteData spriteBlue(.addr(bghost_addr), .data(bghost_data));
	 spriteData spriteRed(.addr(rghost_addr), .data(rghost_data));
	 spriteData spritePink(.addr(pghost_addr), .data(pghost_data));
	 wallData wallMap (.addr(wall_addr), .data(wall_data));
	 dotSpriteData dotSprite ( .addr(dot_addr), .data(dot_data) );
	 
    always_comb
    begin:Ball_on_proc
       // if ( ( DistX*DistX + DistY*DistY) <= (Size * Size) )
		 if ((DrawX >= BallX - Ball_size) &&(DrawX <= BallX + Ball_size) && (DrawY >= BallY - Ball_size) && (DrawY <= BallY + Ball_size))
		 begin
				
//				sprite_addr = (DrawY - BallY + Ball_size + );// + 32 * Direction);
				sprite_addr = tmp1[7:0];
				ball_on = 1'b1;
		 end
        else
		  begin
				sprite_addr = 7'b0000000;
            ball_on = 1'b0;
		  end
		  
		  if ((DrawX >= oghostx - Ball_size) &&(DrawX <= oghostx + Ball_size) && (DrawY >= oghosty - Ball_size) && (DrawY <= oghosty + Ball_size))
		 begin
				
//				sprite_addr = (DrawY - BallY + Ball_size + );// + 32 * Direction);
				oghost_addr = (DrawY - oghosty + Ball_size + 224);
				oghost_on = 1'b1;
		 end
        else
		  begin
				oghost_addr = 7'b0000000;
            oghost_on = 1'b0;
		  end
		  
		  if ((DrawX >= bghostx - Ball_size) &&(DrawX <= bghostx + Ball_size) && (DrawY >= bghosty - Ball_size) && (DrawY <= bghosty + Ball_size))
		 begin
				
//				sprite_addr = (DrawY - BallY + Ball_size + );// + 32 * Direction);
				bghost_addr = (DrawY - bghosty + Ball_size + 224);
				bghost_on = 1'b1;
		 end
        else
		  begin
				bghost_addr = 7'b0000000;
            bghost_on = 1'b0;
		  end
		  
		  if ((DrawX >= rghostx - Ball_size) &&(DrawX <= rghostx + Ball_size) && (DrawY >= rghosty - Ball_size) && (DrawY <= rghosty + Ball_size))
		 begin
				
//				sprite_addr = (DrawY - BallY + Ball_size + );// + 32 * Direction);
				rghost_addr = (DrawY - rghosty + Ball_size + 224);
				rghost_on = 1'b1;
		 end
        else
		  begin
				rghost_addr = 7'b0000000;
            rghost_on = 1'b0;
		  end
		  
		  if ((DrawX >= pghostx - Ball_size) &&(DrawX <= pghostx + Ball_size) && (DrawY >= pghosty - Ball_size) && (DrawY <= pghosty + Ball_size))
		 begin
				
//				sprite_addr = (DrawY - BallY + Ball_size + );// + 32 * Direction);
				pghost_addr = (DrawY - pghosty + Ball_size + 224);
				pghost_on = 1'b1;
		 end
        else
		  begin
				pghost_addr = 7'b0000000;
            pghost_on = 1'b0;
		  end
		  
		  if(DrawX > 16 && DrawY > 16 && DrawX < 410 && DrawY <= 400 && currDotMap[ yp2[9:5]*12 + xp2[9:5] ] == 1'b1 && xp2[4:0] <=3 && yp2[4:0] <=3 )//dot_on
		  begin
				dot_addr = yp2[2:0];
				dot_on = 1'b1;
		  end
		  else begin
				dot_addr = 3'b100;
				dot_on = 1'b0;
		  end
		  
		  if(DrawX < 416 && DrawY <= 400)
			begin
			  if(level == 2'b01)
			  begin
					wall_addr = DrawY + 220;// + 400*1'b0;
			  end
			  else
			  begin 
					wall_addr = DrawY + 224 + 400;
			  end
			  wall_on = 1'b1;
			end
			else
			begin
			  wall_addr = 10'b0000000000;
			  wall_on = 1'b0;
			end
     end

	  
//		always_comb
//		begin:Wall_on_proc
//			if(DrawX < 416 && DrawY <= 400)
//			begin
//			  wall_addr = DrawY + 220;// + 400*1'b0;
//			  wall_on = 1'b1;
//			end
//			else
//			begin
//			  wall_addr = 10'b0000000000;
//			  wall_on = 1'b0;
//			end
//			
//			//if()
//			
//		end

    always_comb
    begin:RGB_Display
        if ((ball_on == 1'b1) && sprite_data[DrawX - BallX + Ball_size] == 1'b1)
        begin
            Red = 8'hff;
            Green = 8'hff;
            Blue = 8'h00;
        end
		  /*else if(dot_on == 1'b1 && dot_data[])//pacdots
		  begin
		  
		  end*/
		  else if(oghost_on == 1'b1 && oghost_data[DrawX - oghostx + Ball_size] == 1'b1)
		  begin
            Red = 8'hff;
            Green = 8'hb8;
            Blue = 8'h51;
        end
		  else if(bghost_on == 1'b1 && bghost_data[DrawX - bghostx + Ball_size] == 1'b1)
		  begin
            Red = 8'h01;
            Green = 8'hff;
            Blue = 8'hff;
        end
		  else if(rghost_on == 1'b1 && rghost_data[DrawX - rghostx + Ball_size] == 1'b1)
		  begin
            Red = 8'hff;
            Green = 8'h5f;
            Blue = 8'h5f;
        end
		  else if(pghost_on == 1'b1 && pghost_data[DrawX - pghostx + Ball_size] == 1'b1)
		  begin
            Red = 8'hff;
            Green = 8'hb8;
            Blue = 8'hff;
        end
		  else if(dot_on == 1'b1 && dot_data[xp2[1:0]] == 1'b1)
		  begin
				Red = 8'hff;
            Green = 8'hff;
            Blue = 8'h00;
		  end
		  else if(wall_on == 1'b1 && wall_data[DrawX] == 1'b1)
        begin
				Red = 8'h00;
				Green = 8'h00;
				Blue = 8'hff;
        end
		  else
		  begin
				Red = 8'h00;
				Green = 8'h00;
//				Blue = 8'h3f - DrawX[9:3];
				Blue = 8'h00;// - DrawX[9:3];
		  end
    end

endmodule
