extends Node

const ROOMS = [
	[
		[ 1, 1, 1, 1,-1, 1, 1, 1, 1,],
		[ 1, 0, 0, 0, 0, 0, 0, 0, 1,],
		[ 1, 0, 0, 0, 0, 0, 0, 0, 1,],
		[ 1, 0, 0, 0, 0, 0, 0, 0, 1,],
		[-1, 0, 0, 0, 0, 0, 0, 0,-1,],
		[ 1, 0, 0, 0, 0, 0, 0, 0, 1,],
		[ 1, 0, 0, 0, 0, 0, 0, 0, 1,],
		[ 1, 0, 0, 0, 0, 0, 0, 0, 1,],
		[ 1, 1, 1, 1,-1, 1, 1, 1, 1,],
	],

]

func make_room(doors:Array) -> Array:
	var ret = ROOMS[0].duplicate(true)
	ret[4][0] = 1
	if doors[0]==2:
		ret[4][0] = 0
	ret[0][4] = 1
	if doors[1] == 2:
		ret[0][4] = 0
	ret[4][8] = 1
	if doors[2]==2:
		ret[4][8] = 0
	ret[8][4] = 1
	if doors[3] == 2:
		ret[8][4] = 0
	return ret
