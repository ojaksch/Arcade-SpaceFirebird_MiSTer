/////////////////////////////////////////////////////////////////////

module  ram_64_8
(
	input  I_CLK,
	input  [5:0]I_ADDR,
	input  [7:0]I_D,
	input  I_CE,
	input  I_WE,
	output [7:0]O_D
);

dpram #(6,8) ram_64_8
(
	.clock(I_CLK),
	.address_a(I_ADDR),
	.data_a(I_D),
	.wren_a(I_WE),
	.enable_a(I_CE),
	.q_a(O_D)
);

endmodule

/////////////////////////////////////////////////////////////////////
