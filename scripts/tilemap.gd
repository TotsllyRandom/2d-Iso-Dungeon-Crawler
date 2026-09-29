extends Node2D


var size = 5
var tilemap = [
	
]
var rooms = [
	
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	make_tile_map()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$ColorRect.size = get_viewport_rect().size
	$ColorRect.position = $Player.position
	$ColorRect.position = Vector2(
		$ColorRect.position.x - $ColorRect.size.x/2,
		$ColorRect.position.y - $ColorRect.size.y/2
	)

func make_tile_map():
	$Ground.clear()
	for y in range(size):
		var row = []
		for x in range(size):
			row.append([-1,-1,-1,-1,0])
		rooms.append(row)
	
	make_room(size/2,size/2)
	var save = []
	for y in rooms:
		var line = []
		for x in y:
			line.append(Rooms.make_room(x))
		save.append(line)
	rooms = save
	
	tilemap = []

	for y in range(len(rooms)):
		var room_rows = []
		
		for x in range(len(rooms[y])):
			var current_room = rooms[y][x]
			
			for room_y in range(len(current_room)):
				if room_rows.size() <= room_y:
					room_rows.append([])
				
				room_rows[room_y].append_array(current_room[room_y])
		
		tilemap.append_array(room_rows)
	
	for y in range(len(tilemap)):
		for x in range(len(tilemap[0])):
			$Ground.set_cell(Vector2i(x,y),tilemap[y][x],Vector2i(1,0))
	
	$Player.position = $Ground.map_to_local(Vector2i(
		len(tilemap[0]) / 2,
		len(tilemap) / 2
	))
func make_room(x:int, y:int):
	var doors = rooms[y][x]
	## if first room
	if doors == [-1,-1,-1,-1,0]:
		doors = [randi_range(0,1),1,randi_range(0,1),randi_range(0,1),0]
	else:
		var n = 0
		for i in doors:
			if doors[n] == -1:
				doors[n] = max(randi_range(0,1),randi_range(0,1))
			n += 1
	var num = 0
	doors[4] = 5
	rooms[y][x][4] = 5
	for i in doors:
		if i == 1:
			var nx = x
			var ny = y
			match num:
				0:
					nx-=1
				1:
					ny-=1
				2:
					nx+=1
				3: 
					ny+=1
			doors[num] = 2
			var f = num - 2
			if f < 0:
				f += 4
			if nx >= 0 && ny >= 0 && nx <= size-1 && ny <= size-1 and rooms[ny][nx][4] == 0:
				doors[num] = 2
				rooms[ny][nx][f] = 2
				
				make_room(nx,ny)
			else:
				doors[num] = 0
			
		num += 1
	rooms[y][x] = doors
