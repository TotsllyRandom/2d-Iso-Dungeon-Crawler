extends Node2D


var size = 5
var tilemap = []
var rooms = []
var fill_rooms = []

var total_rooms := 0
const MIN_ROOMS = 5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	make_tile_map()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Reset"):
		make_tile_map()
	$ColorRect.size = get_viewport_rect().size
	$ColorRect.position = $Player.position
	$ColorRect.position = Vector2(
		$ColorRect.position.x - $ColorRect.size.x/2,
		$ColorRect.position.y - $ColorRect.size.y/2
	)


func make_tile_map():
	print("Making Tilemap:\n")
	$Ground.clear()
	rooms.clear()
	tilemap.clear()
	fill_rooms.clear()
	total_rooms = 0
	print("Cleared Old Tiles")
	
	while total_rooms < MIN_ROOMS:
		rooms.clear()
		total_rooms = 0
		make_room(0,0,0)
		print(str(total_rooms) + " < " + str(MIN_ROOMS) +"?")
		
	
	print("Made rooms")
	fill_rooms = rooms.duplicate(true)
	rooms.clear()
	
	var mi = Vector2i(0,0)
	var ma = Vector2i(0,0)
	
	for room in fill_rooms:
	
		if room["cords"].x > ma.x:
			ma.x = room["cords"].x
		
		if room["cords"].x < mi.x:
			mi.x = room["cords"].x
		
		if room["cords"].y > ma.y:
			ma.y = room["cords"].y
		
		if room["cords"].y < mi.y:
			mi.y = room["cords"].y
	
	for y in range(abs(mi.y) + abs(ma.y) + 1):
		var line = []
		
		for x in range(abs(mi.x) + abs(ma.x) + 1):
			line.append({"doors":[-1,-1,-1,-1],"type":"hall"})
		
		rooms.append(line)
	
	for room in fill_rooms:
		var x = room["cords"].x - mi.x
		var y = room["cords"].y - mi.y
		
		rooms[y][x] = {
			"doors":room["doors"],
			"type":room["type"]
		}
	
	var save = []
	
	for y in rooms:
		var line = []
		
		for x in y:
			line.append(Rooms.make_room(x["doors"],x["type"]))
		
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
	
	var lx = len(tilemap[0]) - 1
	var ly = len(tilemap) - 1
	
	for y in range(len(tilemap)):
		for x in range(len(tilemap[0])):
			
			if str(tilemap[y][x]) == (" "):
				continue
			
			if not str(tilemap[y][x]) == "W":
				$Ground.set_cell(Vector2i(x,y),0,Vector2i(int(tilemap[y][x]),0))
			else:
				for ay in range(-1,2):
					for ax in range(-1,2):
						if (abs(ax) + abs(ay) == 1):
							var a := []
							
							if x != 0:
								a.append(tilemap[y][x-1])
							
							if x != lx:
								a.append(tilemap[y][x+1])
							
							if y != 0:
								a.append(tilemap[y-1][x])
							
							if y != ly:
								a.append(tilemap[y+1][x])
							
							var item = 0
							
							while (item < len(a)):
								if str(a[item]) == "W" or str(a[item]) == " ":
									a.pop_at(item)
									item -= 1
								
								item += 1
							
							if len(a) == 0:
								a.append(1)
							
							$Ground.set_cell(Vector2i(x,y),1,Vector2i(int(a[0]),0))
					
	$Player.position = $Ground.map_to_local(Vector2i(
		(-mi.x * 9) + 4,
		(-mi.y * 9) + 4
	))


func find_room_by_cord(x:int,y:int) -> int:
	for i in range(len(rooms)):
		if rooms[i]["cords"] == Vector2i(x,y):
			return i
		
	return -1


func make_room(x:int, y:int, strand:=0, type:String="none"):
	var max_strand_length := 5
	var item = find_room_by_cord(x,y)
	
	if item != -1:
		if rooms[item]["made"]:
			return
	
	var room := {}
	
	if item == -1:
		room = {
			"doors":[-1,1,0,0],
			"cords":Vector2i(x,y),
			"made":false,
			"type":"room"
		}
		
		
		rooms.append(room)
		item = rooms.size() - 1
	else:
		room = rooms[item]
	
	if room["type"] == "none":
		room["type"] = type
	
	for door in range(4):
		if room["doors"][door] == -1:
			var nx := x
			var ny := y
			
			match door:
				0:
					nx -= 1
				1:
					ny -= 1
				2:
					nx += 1
				3:
					ny += 1
			
			var new_door = door - 2
			
			if new_door < 0:
				new_door += 4
			
			var next_room = find_room_by_cord(nx,ny)
			
			if next_room == -1:
				rooms.append({
					"doors":[-1,-1,-1,-1],
					"cords":Vector2i(nx,ny),
					"made":false,
					"type":"none"
				})
				
				next_room = rooms.size() - 1
			
			if strand < max_strand_length && rooms[next_room]["doors"][new_door] == -1:
				room["doors"][door] = randi_range(0,1)
			else:
				room["doors"][door] = 0
				
				if room["type"] == "none":
					room["type"] = "room"
	
	room["made"] = true
	rooms[item] = room
	
	for door in range(4):
		var nx := x
		var ny := y
		
		match door:
			0:
				nx -= 1
			1:
				ny -= 1
			2:
				nx += 1
			3:
				ny += 1
		
		var new_door = door - 2
		
		if new_door < 0:
			new_door += 4
		
		var next_room = find_room_by_cord(nx,ny)
		
		if next_room == -1:
			rooms.append({
				"doors":[-1,-1,-1,-1],
				"cords":Vector2i(nx,ny),
				"made":false,
				"type":"none"
			})
			
			next_room = rooms.size() - 1
		
		if room["doors"][door] == 0:
			rooms[next_room]["doors"][new_door] = 0
		
		if room["doors"][door] == 1:
			rooms[next_room]["doors"][new_door] = 2
		
	if room["type"] == "none":
		var types = ["hall","room"]
		room["type"] = types[randi_range(0,1)]
	if room["type"] == "room":
		total_rooms += 1
		print("Room Made, current rooms - " + str(total_rooms))
		
	rooms[item] = room
	
	for door in range(4):
		var nx := x
		var ny := y
		
		match door:
			0:
				nx -= 1
			1:
				ny -= 1
			2:
				nx += 1
			3:
				ny += 1
		
		if room["doors"][door] == -1:
			room["doors"][door] = 0
		
		if room["doors"][door] == 1:
			room["doors"][door] = 2
		
			if strand < max_strand_length:
				if room["type"] == "room":
					make_room(nx,ny,strand + 1,"hall")
				else:
					make_room(nx,ny,strand + 1,"room")
					
					
	rooms[item] = room
