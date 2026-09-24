extends CharacterBody2D

const SPEED = 200.0
var on_tile := false

func _physics_process(_delta: float) -> void:
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var y_change := ((int(Input.is_action_pressed("plr_move_down"))-int((Input.is_action_pressed("plr_move_up"))))*(SPEED*_delta))/2
	var x_change := ((int(Input.is_action_pressed("plr_move_right"))-int((Input.is_action_pressed("plr_move_left"))))*SPEED*_delta)
	
	position = Vector2(
		position.x + x_change,
		position.y + y_change
	)
	
	if on_tile == false:
		pass

func _on_collisions_body_entered(body: Node2D) -> void:
	on_tile = true
	print(on_tile)


func _on_collisions_body_exited(body: Node2D) -> void:
		on_tile = false
