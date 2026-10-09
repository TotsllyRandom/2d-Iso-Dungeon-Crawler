extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func _on_next_sector_pressed() -> void:
	var error = get_tree().change_scene_to_file("res://Scenes/dungeon.tscn")
	
	if error != OK:
		print("Failed to load scene: ", error)
