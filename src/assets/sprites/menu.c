#include "menu.h"
// Data created with Img2CPC - (c) Retroworks - 2007-2017
// Tile sp_menu: 100x100 pixels, 50x100 bytes.
const u8 sp_menu[50 * 100] = {
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0xff, 0xff, 0xae, 0x0c, 0x0c, 0x5d, 0xff, 0xff, 0xae, 0x0c, 0x5d, 0xae, 0x0c, 0x5d, 0xae, 0x0c, 0x5d, 0xff, 0xff, 0x0c, 0x0c, 0x5d, 0xff, 0xff, 0xff, 0x0c, 0x5d, 0xff, 0xff, 0xae, 0x0c, 0x0c, 0xff, 0x0c, 0x0c, 0xff, 0x0c, 0x0c, 0x0c, 0xff, 0x0c, 0x0c, 0x0c, 0xff, 0x0c, 0x0c, 0xae, 0x0c,
	0x0c, 0x0c, 0xae, 0x0c, 0xff, 0x0c, 0x0c, 0xff, 0xae, 0x5d, 0xff, 0x0c, 0x5d, 0xff, 0x0c, 0xff, 0xae, 0x0c, 0x5d, 0x0c, 0x5d, 0xae, 0x0c, 0x5d, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0x0c, 0x0c, 0xae, 0x0c, 0x0c, 0xff, 0xae, 0x5d, 0xff, 0x0c, 0x0c, 0x5d, 0xff, 0xae, 0x0c, 0x0c, 0xff, 0xae, 0x0c, 0xae, 0x0c,
	0x0c, 0x0c, 0xae, 0x0c, 0xff, 0x0c, 0x0c, 0xff, 0x0c, 0x0c, 0xff, 0x0c, 0x5d, 0xff, 0x0c, 0xff, 0xae, 0x0c, 0x5d, 0x0c, 0x5d, 0xae, 0x0c, 0x5d, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0x0c, 0x0c, 0xae, 0x0c, 0x0c, 0xff, 0xae, 0x5d, 0xff, 0x0c, 0x0c, 0x5d, 0xff, 0xae, 0x0c, 0x0c, 0xff, 0xff, 0x0c, 0xae, 0x0c,
	0x0c, 0x0c, 0xff, 0xff, 0xff, 0x0c, 0x0c, 0xff, 0x0c, 0x0c, 0xff, 0x0c, 0x5d, 0xff, 0x0c, 0xff, 0xae, 0x0c, 0x5d, 0xff, 0xff, 0xae, 0x0c, 0x5d, 0xff, 0xff, 0xae, 0x0c, 0x5d, 0x0c, 0x0c, 0xae, 0x0c, 0x0c, 0xff, 0xae, 0x5d, 0xff, 0x0c, 0x0c, 0xff, 0xff, 0xff, 0x0c, 0x0c, 0xae, 0xff, 0x0c, 0xae, 0x0c,
	0x0c, 0x0c, 0xae, 0x0c, 0xff, 0x0c, 0x0c, 0xff, 0x0c, 0x0c, 0xff, 0x0c, 0x5d, 0x5d, 0xff, 0xae, 0xae, 0x0c, 0x5d, 0x0c, 0x5d, 0xae, 0x0c, 0x5d, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0xff, 0xff, 0xae, 0x0c, 0x0c, 0xae, 0xff, 0xff, 0x5d, 0x0c, 0x0c, 0xff, 0x0c, 0xff, 0x0c, 0x0c, 0xae, 0x5d, 0xae, 0xae, 0x0c,
	0x0c, 0x0c, 0xae, 0x0c, 0x5d, 0x0c, 0x0c, 0xff, 0x0c, 0x0c, 0xff, 0x0c, 0x5d, 0x5d, 0xff, 0xae, 0xae, 0x0c, 0x5d, 0x0c, 0x0c, 0xae, 0x0c, 0x5d, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0x0c, 0x5d, 0xae, 0x0c, 0x0c, 0xae, 0xff, 0xff, 0x5d, 0x0c, 0x0c, 0xff, 0xff, 0xff, 0x0c, 0x0c, 0xae, 0x5d, 0xff, 0xae, 0x0c,
	0x0c, 0x0c, 0xae, 0x0c, 0xff, 0x0c, 0x0c, 0xff, 0xae, 0x5d, 0xff, 0x0c, 0x5d, 0x5d, 0xff, 0xae, 0xae, 0x0c, 0x5d, 0x0c, 0x5d, 0xae, 0x0c, 0x5d, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0x0c, 0x0c, 0xff, 0x0c, 0x0c, 0xae, 0xff, 0xff, 0x5d, 0x0c, 0x5d, 0xae, 0x0c, 0x5d, 0xae, 0x0c, 0xae, 0x0c, 0xff, 0xae, 0x0c,
	0x0c, 0x0c, 0xff, 0xff, 0xae, 0x0c, 0x0c, 0x5d, 0xff, 0xff, 0xae, 0x0c, 0x5d, 0x0c, 0xff, 0x0c, 0xae, 0x0c, 0x5d, 0xff, 0xff, 0x0c, 0x0c, 0x5d, 0xff, 0xff, 0xff, 0x0c, 0x5d, 0x0c, 0x0c, 0x5d, 0x0c, 0x0c, 0xae, 0x5d, 0xae, 0x5d, 0x0c, 0x5d, 0xae, 0x0c, 0x5d, 0xae, 0x0c, 0xae, 0x0c, 0x5d, 0xae, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x0c,
	0x0c, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0xff, 0xff, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0xae, 0x0c, 0xff, 0x0c, 0xff, 0xff, 0xae, 0x5d, 0xae, 0x0c, 0xff, 0x5d, 0xff, 0xff, 0xae, 0x0c, 0x5d, 0x0c, 0x0c, 0xae, 0xff, 0xff, 0xff, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0xff, 0xae, 0xff, 0xae, 0x0c, 0x0c, 0x0c, 0x5d, 0xff, 0x5d, 0xff, 0x5d, 0xff, 0x5d, 0xff, 0x5d, 0xae, 0x0c, 0xff, 0x5d, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0x0c, 0x0c, 0xae, 0xae, 0x0c, 0xff, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0xff, 0x0c, 0x5d, 0xae, 0x0c, 0x0c, 0x0c, 0x5d, 0xff, 0x5d, 0xff, 0x5d, 0xae, 0x0c, 0xff, 0x0c, 0xae, 0x5d, 0xae, 0x5d, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0x0c, 0x0c, 0xae, 0xae, 0x0c, 0xff, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0xae, 0x0c, 0x0c, 0xae, 0x0c, 0x0c, 0x0c, 0x5d, 0xff, 0x5d, 0xff, 0x5d, 0x0c, 0x0c, 0x5d, 0x0c, 0xff, 0x5d, 0xae, 0x5d, 0xff, 0xff, 0xae, 0x0c, 0x5d, 0x0c, 0x0c, 0xae, 0xff, 0xff, 0xff, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0xff, 0x0c, 0xff, 0xae, 0x0c, 0x0c, 0x0c, 0x5d, 0x5d, 0xff, 0x5d, 0x5d, 0xae, 0x0c, 0xff, 0x0c, 0xff, 0xff, 0x0c, 0x5d, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0x0c, 0x0c, 0xae, 0xae, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0xff, 0xae, 0xff, 0xae, 0x0c, 0x0c, 0x0c, 0x5d, 0x5d, 0xff, 0x5d, 0x5d, 0xff, 0x5d, 0xff, 0x0c, 0x5d, 0xff, 0x0c, 0x5d, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0xae, 0x5d, 0xae, 0xae, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0xff, 0xff, 0xae, 0x0c, 0x0c, 0x0c, 0x5d, 0x5d, 0xff, 0x5d, 0x0c, 0xff, 0xff, 0xae, 0x0c, 0x5d, 0xff, 0x0c, 0x5d, 0xff, 0xff, 0xae, 0x0c, 0x5d, 0xff, 0xff, 0xae, 0xae, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0xae, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0x0c, 0x0c, 0x0c, 0x5d, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0xff, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0xae, 0x0c, 0xff, 0x0c, 0xff, 0xff, 0xae, 0x5d, 0xae, 0x0c, 0xff, 0x5d, 0xff, 0xff, 0xae, 0x0c, 0x5d, 0xff, 0xae, 0x0c, 0xff, 0xff, 0xae, 0x5d, 0xae, 0x5d, 0xae, 0x5d, 0x5d, 0xae, 0x0c, 0xae, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0xff, 0xae, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0xff, 0x5d, 0xff, 0x5d, 0xff, 0x5d, 0xff, 0x5d, 0xae, 0x0c, 0xff, 0x5d, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0x0c, 0xff, 0x5d, 0xff, 0x5d, 0xff, 0x5d, 0xae, 0xff, 0xae, 0x5d, 0x5d, 0xff, 0x0c, 0xae, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0xff, 0xae, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0xff, 0x5d, 0xff, 0x5d, 0xae, 0x0c, 0xff, 0x0c, 0xae, 0x5d, 0xae, 0x5d, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0x0c, 0x5d, 0x5d, 0xae, 0x0c, 0xff, 0x5d, 0xae, 0xff, 0xae, 0xff, 0x5d, 0xff, 0x0c, 0xae, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0xae, 0xff, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0xff, 0x5d, 0xff, 0x5d, 0x0c, 0x0c, 0x5d, 0x0c, 0xff, 0x5d, 0xae, 0x5d, 0xff, 0xff, 0xae, 0x0c, 0x5d, 0x0c, 0x5d, 0x5d, 0x0c, 0x0c, 0x5d, 0x0c, 0xae, 0xff, 0xae, 0xff, 0x5d, 0x5d, 0xae, 0xae, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0xff, 0xff, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0x5d, 0xff, 0x5d, 0x5d, 0xae, 0x0c, 0xff, 0x0c, 0xff, 0xff, 0x0c, 0x5d, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0x0c, 0x5d, 0x5d, 0xae, 0x0c, 0xff, 0x0c, 0xff, 0xae, 0xff, 0xff, 0x5d, 0x0c, 0xff, 0xae, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0xff, 0x0c, 0x5d, 0xae, 0x0c, 0x0c, 0x0c, 0x5d, 0x5d, 0xff, 0x5d, 0x5d, 0xff, 0x5d, 0xff, 0x0c, 0x5d, 0xff, 0x0c, 0x5d, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0x0c, 0xff, 0x5d, 0xff, 0x5d, 0xff, 0x0c, 0xff, 0xae, 0x5d, 0xae, 0x5d, 0x0c, 0xff, 0xae, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0xff, 0x0c, 0x5d, 0xae, 0x0c, 0x0c, 0x0c, 0x5d, 0x5d, 0xff, 0x5d, 0x0c, 0xff, 0xff, 0xae, 0x0c, 0x5d, 0xff, 0x0c, 0x5d, 0xff, 0xff, 0xae, 0x0c, 0x5d, 0xff, 0xae, 0x0c, 0xff, 0xff, 0xae, 0x0c, 0xff, 0xae, 0x5d, 0xae, 0x5d, 0x0c, 0x5d, 0xae, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0xff, 0xff, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0xae, 0x0c, 0xff, 0x0c, 0xff, 0xff, 0xae, 0x5d, 0xae, 0x0c, 0xff, 0x5d, 0xff, 0xff, 0xae, 0x0c, 0x5d, 0x0c, 0x0c, 0x5d, 0xff, 0xff, 0xae, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0xff, 0xae, 0xff, 0xae, 0x0c, 0x0c, 0x0c, 0x5d, 0xff, 0x5d, 0xff, 0x5d, 0xff, 0x5d, 0xff, 0x5d, 0xae, 0x0c, 0xff, 0x5d, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0x0c, 0x0c, 0x5d, 0x0c, 0x0c, 0x0c, 0xae, 0x0c, 0x0c, 0x0c, 0xae, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0xff, 0x0c, 0x5d, 0xae, 0x0c, 0x0c, 0x0c, 0x5d, 0xff, 0x5d, 0xff, 0x5d, 0xae, 0x0c, 0xff, 0x0c, 0xae, 0x5d, 0xae, 0x5d, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0x0c, 0x0c, 0x5d, 0x0c, 0x0c, 0x0c, 0xae, 0x0c, 0x0c, 0x0c, 0xae, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0xae, 0x0c, 0x0c, 0xae, 0x0c, 0x0c, 0x0c, 0x5d, 0xff, 0x5d, 0xff, 0x5d, 0x0c, 0x0c, 0x5d, 0x0c, 0xff, 0x5d, 0xae, 0x5d, 0xff, 0xff, 0xae, 0x0c, 0x5d, 0x0c, 0x0c, 0x5d, 0xff, 0xff, 0xae, 0xff, 0xff, 0xae, 0x0c, 0xae, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0xff, 0x0c, 0x5d, 0xae, 0x0c, 0x0c, 0x0c, 0x5d, 0x5d, 0xff, 0x5d, 0x5d, 0xae, 0x0c, 0xff, 0x0c, 0xff, 0xff, 0x0c, 0x5d, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0x0c, 0x0c, 0x5d, 0x0c, 0x0c, 0x0c, 0xae, 0x0c, 0x0c, 0x0c, 0xae, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0xff, 0xae, 0xff, 0xae, 0x0c, 0x0c, 0x0c, 0x5d, 0x5d, 0xff, 0x5d, 0x5d, 0xff, 0x5d, 0xff, 0x0c, 0x5d, 0xff, 0x0c, 0x5d, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0x0c, 0x0c, 0x5d, 0x0c, 0x0c, 0x0c, 0xae, 0x0c, 0x0c, 0x0c, 0xae, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0xff, 0xff, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0x5d, 0xff, 0x5d, 0x0c, 0xff, 0xff, 0xae, 0x0c, 0x5d, 0xff, 0x0c, 0x5d, 0xff, 0xff, 0xae, 0x0c, 0x5d, 0xff, 0xff, 0x5d, 0xff, 0xff, 0xae, 0xae, 0x0c, 0x0c, 0x0c, 0xae, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0xff, 0xff, 0xff, 0xae, 0x0c, 0x0c, 0x0c, 0x5d, 0xae, 0x0c, 0xff, 0x0c, 0xff, 0xff, 0xae, 0x5d, 0xae, 0x0c, 0xff, 0x5d, 0xff, 0xff, 0xae, 0x0c, 0x5d, 0xff, 0xff, 0x0c, 0xae, 0x5d, 0xff, 0xff, 0xae, 0x5d, 0x0c, 0x0c, 0xff, 0xff, 0xff, 0xff, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0xff, 0x0c, 0x5d, 0xae, 0x0c, 0x0c, 0x0c, 0x5d, 0xff, 0x5d, 0xff, 0x5d, 0xff, 0x5d, 0xff, 0x5d, 0xae, 0x0c, 0xff, 0x5d, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0x0c, 0x5d, 0x0c, 0xae, 0xff, 0xae, 0x0c, 0x0c, 0x5d, 0x0c, 0x0c, 0xae, 0x0c, 0xae, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0xff, 0x0c, 0x5d, 0xae, 0x0c, 0x0c, 0x0c, 0x5d, 0xff, 0x5d, 0xff, 0x5d, 0xae, 0x0c, 0xff, 0x0c, 0xae, 0x5d, 0xae, 0x5d, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0x0c, 0x5d, 0x0c, 0xae, 0xff, 0x0c, 0x0c, 0x0c, 0x5d, 0x0c, 0x0c, 0xae, 0x0c, 0xae, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0xff, 0xff, 0xff, 0xae, 0x0c, 0x0c, 0x0c, 0x5d, 0xff, 0x5d, 0xff, 0x5d, 0x0c, 0x0c, 0x5d, 0x0c, 0xff, 0x5d, 0xae, 0x5d, 0xff, 0xff, 0xae, 0x0c, 0x5d, 0xff, 0xff, 0x0c, 0xae, 0xae, 0x0c, 0xff, 0xae, 0x5d, 0xff, 0xff, 0xae, 0x0c, 0xae, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0xff, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0x5d, 0xff, 0x5d, 0x5d, 0xae, 0x0c, 0xff, 0x0c, 0xff, 0xff, 0x0c, 0x5d, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0x0c, 0xff, 0x0c, 0xae, 0xff, 0x0c, 0x0c, 0xae, 0x5d, 0x0c, 0x0c, 0xae, 0x0c, 0xae, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0xff, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0x5d, 0xff, 0x5d, 0x5d, 0xff, 0x5d, 0xff, 0x0c, 0x5d, 0xff, 0x0c, 0x5d, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0x0c, 0x5d, 0xae, 0xae, 0xff, 0xae, 0xff, 0xae, 0x5d, 0x0c, 0x0c, 0xae, 0x0c, 0xae, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0xff, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0x5d, 0xff, 0x5d, 0x0c, 0xff, 0xff, 0xae, 0x0c, 0x5d, 0xff, 0x0c, 0x5d, 0xff, 0xff, 0xae, 0x0c, 0x5d, 0x0c, 0x0c, 0xae, 0xae, 0x5d, 0xff, 0xff, 0x0c, 0x5d, 0x0c, 0x0c, 0xae, 0x0c, 0xae, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x5d, 0xff, 0xff, 0xff, 0x5d, 0xff, 0xff, 0x0c, 0xff, 0xff, 0xae, 0xff, 0xff, 0xff, 0x5d, 0xff, 0xff, 0xae, 0x0c, 0x5d, 0xae, 0x0c, 0xff, 0x0c, 0x5d, 0xff, 0xff, 0xff, 0xff, 0xff, 0xae, 0x0c, 0x0c, 0xff, 0xff, 0xff, 0x5d, 0xff, 0xff, 0xff, 0x5d, 0xae, 0x0c, 0x5d, 0xff, 0xff, 0x5d, 0xff, 0xff, 0xff,
	0x5d, 0xae, 0x0c, 0xff, 0x5d, 0x0c, 0x5d, 0x0c, 0xae, 0x0c, 0x0c, 0xff, 0x0c, 0x0c, 0x5d, 0xae, 0x0c, 0x0c, 0x0c, 0x0c, 0xff, 0x5d, 0xae, 0x0c, 0x0c, 0x0c, 0xae, 0x5d, 0xff, 0x5d, 0xff, 0x0c, 0x0c, 0xff, 0x0c, 0x0c, 0x0c, 0x0c, 0xae, 0x0c, 0x5d, 0xff, 0x0c, 0x5d, 0x0c, 0x5d, 0x0c, 0x0c, 0xae, 0x0c,
	0x5d, 0xae, 0x0c, 0xff, 0x5d, 0x0c, 0x5d, 0x0c, 0xae, 0x0c, 0x0c, 0xff, 0xae, 0x0c, 0x5d, 0xff, 0x0c, 0x0c, 0x0c, 0x0c, 0x5d, 0xff, 0x0c, 0x0c, 0x0c, 0x0c, 0xae, 0x5d, 0xae, 0x0c, 0xff, 0x0c, 0x0c, 0xff, 0xae, 0x0c, 0x0c, 0x0c, 0xae, 0x0c, 0xff, 0xff, 0x0c, 0x5d, 0x0c, 0x5d, 0x0c, 0x0c, 0xae, 0x0c,
	0x5d, 0xff, 0xff, 0xff, 0x5d, 0xff, 0xff, 0x0c, 0xff, 0xff, 0xae, 0x5d, 0xff, 0xff, 0x0c, 0xff, 0xff, 0xae, 0x0c, 0x0c, 0x0c, 0xae, 0x0c, 0x0c, 0x0c, 0x0c, 0xae, 0x5d, 0x0c, 0x0c, 0x5d, 0x0c, 0x0c, 0x5d, 0xff, 0xff, 0x0c, 0x0c, 0xae, 0x0c, 0xff, 0x5d, 0xae, 0x5d, 0xff, 0xff, 0x0c, 0x0c, 0xae, 0x0c,
	0x5d, 0xae, 0x0c, 0x0c, 0x5d, 0x0c, 0xff, 0x0c, 0xae, 0x0c, 0x0c, 0x0c, 0x0c, 0xff, 0x0c, 0x0c, 0x5d, 0xae, 0x0c, 0x0c, 0x5d, 0xff, 0x0c, 0x0c, 0x0c, 0x0c, 0xae, 0x5d, 0xae, 0x0c, 0xff, 0x0c, 0x0c, 0x0c, 0x0c, 0xff, 0x0c, 0x0c, 0xae, 0x0c, 0xff, 0xff, 0xae, 0x5d, 0x0c, 0xff, 0x0c, 0x0c, 0xae, 0x0c,
	0x5d, 0xae, 0x0c, 0x0c, 0x5d, 0x0c, 0x5d, 0xae, 0xae, 0x0c, 0x0c, 0xff, 0x0c, 0xff, 0x5d, 0xae, 0x5d, 0xae, 0x0c, 0x0c, 0xff, 0x5d, 0xae, 0x0c, 0x0c, 0x0c, 0xae, 0x5d, 0xff, 0x5d, 0xff, 0x0c, 0x0c, 0xff, 0x0c, 0xff, 0x0c, 0x0c, 0xae, 0x5d, 0xae, 0x0c, 0xff, 0x5d, 0x0c, 0x5d, 0xae, 0x0c, 0xae, 0x0c,
	0x5d, 0xae, 0x0c, 0x0c, 0x5d, 0x0c, 0x0c, 0xae, 0xff, 0xff, 0xae, 0xff, 0xff, 0xff, 0x5d, 0xff, 0xff, 0xae, 0x0c, 0x5d, 0xae, 0x0c, 0xff, 0x0c, 0x0c, 0x0c, 0xae, 0x0c, 0xff, 0xff, 0xae, 0x0c, 0x0c, 0xff, 0xff, 0xff, 0x0c, 0x0c, 0xae, 0x5d, 0xae, 0x0c, 0xff, 0x5d, 0x0c, 0x0c, 0xae, 0x0c, 0xae, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c
};

