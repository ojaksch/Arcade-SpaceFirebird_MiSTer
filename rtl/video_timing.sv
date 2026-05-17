module video_timing(
	 input RESET,
    input clk,
	 
	 input signed [3:0] HOFFSET,
	 input signed [3:0] VOFFSET,
	 
    output reg pix_clk,
	 output reg [1:0] pixcount,

    output reg [8:0] hcnt,
    output reg [8:0] vcnt,

    output reg hsync,
    output reg vsync,
    output reg hblank,
    output reg vblank
);

// each sprite pixel is two star pixels
// so creates twice as many pixel clocks as pixels!
 
wire [8:0] H_START = 0;
wire [8:0] H_END = 318 - 1;
wire [8:0] HS_START; // = 263;
wire [8:0] HS_END;   // = 286 - 1;
wire [8:0] HB_START = 256;
wire [8:0] HB_END = H_END;

wire [8:0] V_START = 0;
wire [8:0] V_END = 262 - 1;
wire [8:0] VS_START; // = 254;
wire [8:0] VS_END;   // = 262 - 1;
wire [8:0] VB_START = 224;
wire [8:0] VB_END = V_END;


// allow sync adjust to centre screen on CRT
always @(*) begin
	HS_START <= 263 + HOFFSET;
	HS_END   <= 286 + HOFFSET;
	VS_START <= 246 + VOFFSET; 
	VS_END   <= 254 + VOFFSET;	
end

always_ff @(posedge clk) begin

	// divide clock by selected amount to get pixel clock
	
	if (RESET==1'b1) begin
		pixcount <= 2'b00;
		pix_clk <= 1'b0;
	end 
	else begin
		pixcount <= pixcount + 1'b1;
		pix_clk <= pixcount[0];
	end;

	// also use pixel clock to increment counters
	
	if (pixcount == 3) begin
	  hcnt <= hcnt + 1;
	  if (hcnt == H_END) begin
			hcnt <= H_START;
			vcnt <= vcnt + 1;

			if (vcnt == V_END) begin
				 vcnt <= V_START;
			end
	  end

	  hsync <= (hcnt >= HS_START && hcnt <= HS_END);
	  hblank <= (hcnt >= HB_START && hcnt <= HB_END);
	  vsync <= (vcnt >= VS_START && vcnt <= VS_END);
	  vblank <= (vcnt >= VB_START && vcnt <= VB_END);
	end
end
endmodule
