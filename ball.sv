//-------------------------------------------------------------------------
//    pac.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  pac ( input Reset, frame_clk,
					input [15:0]  keycode,
               output [9:0]  pacX, pacY, pacS );
    
    logic [9:0] pac_X_Pos, pac_X_Turn_Motion, pac_Y_Pos, pac_Y_Turn_Motion, pac_Size, pac_X_Continue_Motion, pac_Y_Continue_Motion;
	 
    parameter [9:0] pac_X_Center=320;  // Center position on the X axis
    parameter [9:0] pac_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] pac_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] pac_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] pac_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] pac_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] pac_X_Step=1;      // Step size on the X axis
    parameter [9:0] pac_Y_Step=1;      // Step size on the Y axis

    assign pac_Size = 4;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
    logic [15:0] codeA, codeW, codeS, codeD;
	 assign codeA = 16'h0004;
	 assign codeW = 16'h001a;
	 assign codeS = 16'h0016;
	 assign codeD = 16'h0007;
	 
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_pac
        if (Reset)  // Asynchronous Reset
        begin 
            pac_Y_Motion <= 10'd0; //pac_Y_Step;
				pac_X_Motion <= 10'd0; //pac_X_Step;
				pac_Y_Pos <= pac_Y_Center;
				pac_X_Pos <= pac_X_Center;
        end
           
        else 
        begin 
				 if ( (pac_Y_Pos + pac_Size) >= pac_Y_Max )  // pac is at the bottom edge, BOUNCE!
					  pac_Y_Motion <= (~ (pac_Y_Step) + 1'b1);  // 2's complement.
					  
				 else if ( (pac_Y_Pos - pac_Size) <= pac_Y_Min )  // pac is at the top edge, BOUNCE!
					  pac_Y_Motion <= pac_Y_Step;
					  
				 else if ( (pac_X_Pos + pac_Size) >= pac_X_Max )  // pac is at the right edge, BOUNCE!
					  pac_X_Motion <= (~ (pac_X_Step) + 1'b1);  // 2's complement.
					  
				 else if ( (pac_X_Pos - pac_Size) <= pac_X_Min )  // pac is at the left edge, BOUNCE!
					  pac_X_Motion <= pac_X_Step;

				 else if (keycode == codeS)
				 begin
					  pac_Y_Motion <= pac_Y_Step;
					  pac_X_Motion <= 10'd0;
				 end
				 else if (keycode == codeW)
				 begin
				     pac_Y_Motion <= (~ (pac_Y_Step) + 1'b1);  // 2's complement.
					  pac_X_Motion <= 10'd0;
				 end
				 else if (keycode == codeD)
				 begin
					  pac_Y_Motion <= 10'd0;
					  pac_X_Motion <= pac_X_Step;
				 end
				 
				 else if (keycode == codeA)
				 begin
					  pac_Y_Motion <= 10'd0;
					  pac_X_Motion <= (~ (pac_X_Step) + 1'b1);  // 2's complement.					  
				 end
				 
				 else 
				 begin
					  pac_Y_Motion <= pac_Y_Motion;  // pac is somewhere in the middle, don't bounce, just keep moving
					  pac_X_Motion <= pac_X_Motion;
				 end
				 
				   // You need to remove this and make both X and Y respond to keyboard input
				 
				 pac_Y_Pos <= (pac_Y_Pos + pac_Y_Motion);  // Update pac position
				 pac_X_Pos <= (pac_X_Pos + pac_X_Motion);
			
			
	  /**************************************************************************************
	    ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
		 Hidden Question #2/2:
          Note that pac_Y_Motion in the above statement may have been changed at the same clock edge
          that is causing the assignment of pac_Y_pos.  Will the new value of pac_Y_Motion be used,
          or the old?  How will this impact behavior of the pac during a bounce, and how might that 
          interact with a response to a keypress?  Can you fix it?  Give an answer in your Post-Lab.
      **************************************************************************************/
      
			
		end  
    end
       
    assign pacX = pac_X_Pos;
   
    assign pacY = pac_Y_Pos;
   
    assign pacS = pac_Size;
    

endmodule
