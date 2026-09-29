extends Node

const ROOMS = [
	[## top corner
		["W","W","W","W","X","W","W","W","W",],##right Corner
		["W", 0,  0,  0,  0,  0,  0,  0, "W",],
		["W", 0,  0,  0,  0,  0,  0,  0, "W",],
		["W", 0,  0,  0,  0,  0,  0,  0, "W",],
		["X", 0,  0,  0,  0,  0,  0,  0, "X",],
		["W", 0,  0,  0,  0,  0,  0,  0, "W",],
		["W", 0,  0,  2,  0,  0,  0,  0, "W",],
		["W", 0,  0,  2,  0,  0,  0,  0, "W",],
		["W","W","W","W","X","W","W","W","W",],## bottom Corner
	], ## left corner

]

func make_room(doors:Array) -> Array:
	var ret = ROOMS[0].duplicate(true)
	ret[4][0] = "W"
	if doors[0]==2:
		ret[4][0] = ret[4][1]
	ret[0][4] = "W"
	if doors[1] == 2:
		ret[0][4] = ret[1][4]
	ret[4][8] = "W"
	if doors[2]==2:
		ret[4][8] = ret[4][7]
	ret[8][4] = "W"
	if doors[3] == 2:
		ret[8][4] = ret[7][4]
	return ret
