extends StaticBody3D

@export var pos := Vector3(0.0, 0.0, 0.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = pos
