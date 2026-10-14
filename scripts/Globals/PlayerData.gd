extends Node

## Default Player Data
var default_player_data = {
	"name" : "John Doe",
	"weapon_equipped" : "none",
}

## Real Player Data
var player_data = {}



const PLAYER_DIR := "user://"
const FOLDERS := [
	"data",
]

const PATH_FOLDER = PLAYER_DIR + FOLDERS[0]
const PATH = PATH_FOLDER + "/player.json"


func _ready() -> void:
	load_player_dir()
	load_player_data()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("SAVING PLAYER DATA: ", player_data)
		save_player_data()
		get_tree().quit()


func load_player_dir() -> void:
	# Make sure all required folders exist
	for folder in FOLDERS:
		var p = PLAYER_DIR + folder
		
		if not DirAccess.dir_exists_absolute(p):
			DirAccess.make_dir_absolute(p)
	
	var dir = DirAccess.open(PLAYER_DIR)
	
	if dir == null:
		return
		
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if dir.current_is_dir():
			print("Found directory: " + file_name)
		else:
			print("Found file: " + file_name)
			
		file_name = dir.get_next()
	print(OS.get_user_data_dir())
	
	dir.list_dir_end()

func save_player_data():
	var file = FileAccess.open(PATH, FileAccess.WRITE)
	if file:
		print("found Player Data file")
	file.store_string(JSON.stringify(player_data))
	print("Stored Data: "+JSON.stringify(player_data))
	file.close()

func load_player_data():
	#Player Data
	if not FileAccess.file_exists(PATH):
		var newFile = FileAccess.open(PATH, FileAccess.WRITE)
		newFile.store_string(JSON.stringify(default_player_data))
		newFile.close()
	player_data = JSON.parse_string(FileAccess.get_file_as_string(PATH))
	if player_data == null:
		player_data = default_player_data
	for key in default_player_data:
		if not player_data.keys().has(key):
			player_data[key] = default_player_data[key]
