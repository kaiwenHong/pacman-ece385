//-------------------------------------------------------------------------
//      lab7_usb.sv                                                      --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Fall 2014 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 7                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module  lab8 		( input         CLOCK_50,
                       input[3:0]    KEY, //bit 0 is set up as Reset
							  output [6:0]  HEX0, HEX1,// HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
							  //output [8:0]  LEDG,
							  //output [17:0] LEDR,
							  // VGA Interface 
                       output [7:0]  VGA_R,					//VGA Red
							                VGA_G,					//VGA Green
												 VGA_B,					//VGA Blue
							  output        VGA_CLK,				//VGA Clock
							                VGA_SYNC_N,			//VGA Sync signal
												 VGA_BLANK_N,			//VGA Blank signal
												 VGA_VS,					//VGA virtical sync signal	
												 VGA_HS,					//VGA horizontal sync signal
							  // CY7C67200 Interface
							  inout [15:0]  OTG_DATA,						//	CY7C67200 Data bus 16 Bits
							  output [1:0]  OTG_ADDR,						//	CY7C67200 Address 2 Bits
							  output        OTG_CS_N,						//	CY7C67200 Chip Select
												 OTG_RD_N,						//	CY7C67200 Write
												 OTG_WR_N,						//	CY7C67200 Read
												 OTG_RST_N,						//	CY7C67200 Reset
							  input			 OTG_INT,						//	CY7C67200 Interrupt
							  // SDRAM Interface for Nios II Software
							  output [12:0] DRAM_ADDR,				// SDRAM Address 13 Bits
							  inout [31:0]  DRAM_DQ,				// SDRAM Data 32 Bits
							  output [1:0]  DRAM_BA,				// SDRAM Bank Address 2 Bits
							  output [3:0]  DRAM_DQM,				// SDRAM Data Mast 4 Bits
							  output			 DRAM_RAS_N,			// SDRAM Row Address Strobe
							  output			 DRAM_CAS_N,			// SDRAM Column Address Strobe
							  output			 DRAM_CKE,				// SDRAM Clock Enable
							  output			 DRAM_WE_N,				// SDRAM Write Enable
							  output			 DRAM_CS_N,				// SDRAM Chip Select
							  output			 DRAM_CLK				// SDRAM Clock
											);
    
	 

											 
	 logic [155:0] horiz_walls, vert_walls;
	 logic [1:0] level;
	 
	 logic [7:0] testing;
	 logic [7:0] testing2;
	 
	 logic isPre; // set by control
	 //assign level = 2'b01;
	 get_walls get_walls_module(.*);
	 
	 logic [143:0] dotStartMap;
	 getDotStarts get_dots_module(.*, .dotMap(dotStartMap) );
	 logic anyDotsLeft;
	 logic [143:0] currDotMap;
	 allPacDots all_dots_module(.*, .clk(Clk), .reset(resetObjects), .dotStarts(dotStartMap), .pacX(ballxsig), .pacY(ballysig), .anyLeft(anyDotsLeft), .stillHere(currDotMap) );
	 
	 logic [4:0] displayLevel;
	 logic resetObjects;
	 assign resetObjects = resetAll | Reset_h;
	 logic resetAll;
	 
	 logic [3:0] hitPacman;
	 logic pacManDied;
	 assign pacManDied = (hitPacman[0] | hitPacman[1] | hitPacman[2] | hitPacman[3]);
	 
	 
	 
	 
	 
	 
    logic Reset_h, vssig, Clk;
    logic [9:0] drawxsig, drawysig, ballxsig, ballysig, ballsizesig;
	 logic [9:0] orangexsig, orangeysig, bluexsig, blueysig, redxsig, redysig, pinkxsig, pinkysig;
	 logic [15:0] keycode;
	 logic [15:0] orangeRandomness, blueRandomness, redRandomness, pinkRandomness;
    
	 assign Clk = CLOCK_50;
    assign {Reset_h}=~ (KEY[0]);  // The push buttons are active low
	
	 logic [2:0] temp;
	 control control_module(.*, .clk(Clk), .reset(Reset_h), .keycode(keycode), .pacManDied(pacManDied) );
	 
	 wire [1:0] hpi_addr;
	 wire [15:0] hpi_data_in, hpi_data_out;
	 wire hpi_r, hpi_w, hpi_cs;
	 

	 logic clkdiv;
	 logic ghostClk;
	 logic [17:0] counter;
	 logic [17:0] ghostCounter;
	 always_ff @ (posedge Clk or posedge Reset_h )
    begin 
        if (Reset_h) 
		  begin
            counter <= {18{1'b0}};
				ghostCounter <= {18{1'b0}};
				clkdiv <= 1'b0;
				ghostClk <= 1'b0;
		  end
        else
		  begin 
			   counter <= counter + 1;
				ghostCounter <= ghostCounter + 1;
				if(counter >= 200000)
				begin
					counter <= {18{1'b0}};
					clkdiv <= ~(clkdiv);
				end
				if(ghostCounter >= 262000)
				begin
					ghostCounter <= {18{1'b0}};
					ghostClk <= ~(ghostClk);
				end
				
		  end
				
    end
	 
	 //logic [9:0]  BallX, BallY, BallS;
	 /*
	 lab7_soc m_lab7_soc (.clk_clk(CLOCK_50),
										 .reset_reset_n(KEY[0]),
										 .keys_wire_export(KEY[3:2]),
										 
										 .keycode_export(keycode),
										 .otg_hpi_address_export(hpi_addr),
										 .otg_hpi_cs_export(hpi_cs),
										 .otg_hpi_data_in_port(hpi_data_in),
										 .otg_hpi_data_out_port(hpi_data_out),
										 .otg_hpi_r_export(hpi_r),
										 .otg_hpi_w_export(hpi_w),
										 
										 .sdram_wire_addr(DRAM_ADDR),    //  sdram_wire.addr
										 .sdram_wire_ba(DRAM_BA),      	//  .ba
										 .sdram_wire_cas_n(DRAM_CAS_N),    //  .cas_n
										 .sdram_wire_cke(DRAM_CKE),     	//  .cke
										 .sdram_wire_cs_n(DRAM_CS_N),      //  .cs_n
										 .sdram_wire_dq(DRAM_DQ),      	//  .dq
										 .sdram_wire_dqm(DRAM_DQM),     	//  .dqm
										 .sdram_wire_ras_n(DRAM_RAS_N),    //  .ras_n
										 .sdram_wire_we_n(DRAM_WE_N),      //  .we_n
										 .sdram_clk_clk(DRAM_CLK),
										 .switches_wire_export(SW)//  clock out to SDRAM from other PLL port
										 );
	 */
	 hpi_io_intf hpi_io_inst(   .from_sw_address(hpi_addr),
										 .from_sw_data_in(hpi_data_in),
										 .from_sw_data_out(hpi_data_out),
										 .from_sw_r(hpi_r),
										 .from_sw_w(hpi_w),
										 .from_sw_cs(hpi_cs),
		 								 .OTG_DATA(OTG_DATA),    
										 .OTG_ADDR(OTG_ADDR),    
										 .OTG_RD_N(OTG_RD_N),    
										 .OTG_WR_N(OTG_WR_N),    
										 .OTG_CS_N(OTG_CS_N),    
										 .OTG_RST_N(OTG_RST_N),   
										 .OTG_INT(OTG_INT),
										 .Clk(Clk),
										 .Reset(Reset_h)
	 );
	 
	 //The connections for nios_system might be named different depending on how you set up Qsys
	 nios_system nios_system(
										 .clk_clk(Clk),         
										 .reset_reset_n(KEY[0]),   
										 .sdram_wire_addr(DRAM_ADDR), 
										 .sdram_wire_ba(DRAM_BA),   
										 .sdram_wire_cas_n(DRAM_CAS_N),
										 .sdram_wire_cke(DRAM_CKE),  
										 .sdram_wire_cs_n(DRAM_CS_N), 
										 .sdram_wire_dq(DRAM_DQ),   
										 .sdram_wire_dqm(DRAM_DQM),  
										 .sdram_wire_ras_n(DRAM_RAS_N),
										 .sdram_wire_we_n(DRAM_WE_N), 
										 .sdram_clk_clk(DRAM_CLK),
										 .keycode_export(keycode),  
										 .otg_hpi_address_export(hpi_addr),
										 .otg_hpi_data_in_port(hpi_data_in),
										 .otg_hpi_data_out_port(hpi_data_out),
										 .otg_hpi_cs_export(hpi_cs),
										 .otg_hpi_r_export(hpi_r),
										 .otg_hpi_w_export(hpi_w),
										 .orange_rand_export(orangeRandomness),
										 .blue_rand_export(blueRandomness),
										 .pink_rand_export(pinkRandomness),
										 .red_rand_export(redRandomness)
										 );
	
	//Fill in the connections for the rest of the modules 
    vga_controller vgasync_instance(.*, .Reset(Reset_h), .hs(VGA_HS), .vs(VGA_VS), .pixel_clk(VGA_CLK), .sync(VGA_SYNC_N), .blank(VGA_BLANK_N), .DrawX(drawxsig), .DrawY(drawysig));
    
	 logic [4:0] orangeStartX, blueStartX, redStartX, pinkStartX, orangeStartY, blueStartY, redStartY, pinkStartY;
	 logic  [4:0] ghostStart;
	 assign ghostStart = 5'h06;
	 assign orangeStartX = ghostStart;
	 assign orangeStartY = ghostStart;
	 assign blueStartX = ghostStart;
	 assign blueStartY = ghostStart;
	 assign redStartX = ghostStart;
	 assign redStartY = ghostStart;
	 assign pinkStartX = ghostStart;
	 assign pinkStartY = ghostStart;
//	 assign orangeStartX = 5'h06;
//	 assign orangeStartY = 5'h06;
//	 assign blueStartX = 5'h06;
//	 assign blueStartY = 5'h06;
	 ghost_motion orange_ghost(.*, .Reset(resetObjects), .frame_clk(ghostClk), .ghostX(orangexsig), .ghostY(orangeysig),   .pacX(ballxsig), .pacY(ballysig), .x_start(orangeStartX), .y_start(orangeStartY), .randomness(orangeRandomness), .hitPacman(hitPacman[0])   );

	 
	 ghost_motion blue_ghost  (.*, .Reset(resetObjects), .frame_clk(ghostClk), .ghostX(bluexsig),   .ghostY(blueysig),     .pacX(ballxsig), .pacY(ballysig), .x_start(blueStartX),   .y_start(blueStartY),   .randomness(blueRandomness),   .hitPacman(hitPacman[1])   );
	 
	 ghost_motion red_ghost   (.*, .Reset(resetObjects), .frame_clk(ghostClk), .ghostX(redxsig),    .ghostY(redysig),      .pacX(ballxsig), .pacY(ballysig), .x_start(redStartX),    .y_start(redStartY),    .randomness(redRandomness) ,   .hitPacman(hitPacman[2])   );
	 ghost_motion pink_ghost  (.*, .Reset(resetObjects), .frame_clk(ghostClk), .ghostX(pinkxsig),   .ghostY(pinkysig),     .pacX(ballxsig), .pacY(ballysig), .x_start(pinkStartX),   .y_start(pinkStartY),   .randomness(pinkRandomness),   .hitPacman(hitPacman[3])   );
	 
	 logic [1:0] Direction;
	 logic [9:0] garbageVal;
    pac_motion pac_instance(.*, .Reset(resetObjects), .frame_clk(clkdiv), .pacX(ballxsig), .pacY(ballysig), .pacS(garbageVal), .Direction(Direction));
    assign ballsizesig = 16;
	 
    color_mapper color_instance(.*, .DrawX(drawxsig), .DrawY(drawysig), .BallX(ballxsig), .BallY(ballysig), .Ball_size(ballsizesig), .Red(VGA_R), .Green(VGA_G), .Blue(VGA_B), .Direction(Direction), .oghostx(orangexsig), .oghosty(orangeysig), .bghostx(bluexsig), .bghosty(blueysig), .rghostx(redxsig), .rghosty(redysig), .pghostx(pinkxsig), .pghosty(pinkysig));
	 //color_mapper color_instance(.DrawX(drawxsig), .DrawY(drawysig), .BallX(orangexsig), .BallY(orangeysig), .Ball_size(ballsizesig), .Red(VGA_R), .Green(VGA_G), .Blue(VGA_B));
	     // use this to display orangeGhost instead of pacman									  
//	 HexDriver hex_inst_0 (orangeRandomness[3:0], HEX0);
//	 HexDriver hex_inst_1 (orangeRandomness[7:4], HEX1);
	 //HexDriver hex_inst_0 (testing[3:0], HEX0);
	 //HexDriver hex_inst_1 (testing[7:4], HEX1);
	 //HexDriver hex_inst_0 ({testing2[7:6], testing[1:0]}, HEX0);
	 //HexDriver hex_inst_0 (horiz_walls[25:22], HEX0);
	 //HexDriver hex_inst_1 ({2'b11, vert_walls[1:0]}, HEX1);
	 //HexDriver hex_inst_0 (keycode[3:0], HEX0);
	 //HexDriver hex_inst_1 (keycode[7:4], HEX1);
	 HexDriver hex_inst_1 ({Direction, 2'b00}, HEX1);
	 HexDriver hex_inst_0 ({ballxsig[5:2]}, HEX0);
    
endmodule
