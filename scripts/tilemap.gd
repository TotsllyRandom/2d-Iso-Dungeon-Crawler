extends Node2D

const ROOMS = [
	{
		"enter" : Vector2i(-3,6),
		"enterHeight" : "low",
		"exit" : [
			{
				"pos" : Vector2i(-3,-2),
				"height" : "high"
			}
		]
	},
	{
		"enter" : Vector2i(-3,6),
		"enterHeight" : "low",
		"exit" : [
			{
				"pos" : Vector2i(-3,-2),
				"height" : "high"
			}
		]
	}
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func place_room(position:Vector2i):
	pass
