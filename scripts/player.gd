extends CharacterBody2D


const SPEED = 30.0


func _physics_process(_delta: float) -> void:
	var inputX :float= Input.get_axis("ui_left", "ui_right")
	var inputY :float= Input.get_axis("ui_up", "ui_down")
	
	var inputAxis = [inputX,inputY]
	if inputAxis[0] == 0 && inputAxis[1] == 0:
		return
	
	var axis = sqrt(inputAxis[0]*inputAxis[0] + inputAxis[1]*inputAxis[1])
	
	if axis > inputAxis[0] + inputAxis[1]:
		axis = 1.2 # set value (makes corners faster,slightly)
		inputAxis[0] /= axis
		inputAxis[1] /= axis
	
	var movement = Vector2(
		inputAxis[0] * SPEED,
		inputAxis[1] * SPEED / 2
	)
	
	
	## if: just horizontal: move slight horizontal with vert
	## if: both held: follow slope
	## if: just vert: move slight vert with horizontal
	
	#var initMovement = movement
	var dir = [0,0] # Vertical, Horizontal
	if $TileSlopes1.has_overlapping_bodies():
		dir[0] += -1
		dir[1] += -1
			
	if $TileSlopes2.has_overlapping_bodies():
		dir[0] += -1
		dir[1] += 1
		
	if $TileSlopes3.has_overlapping_bodies():
		dir[0] += 1
		dir[1] += -1
	
	if $TileSlopes4.has_overlapping_bodies():
		dir[0] += 1
		dir[1] += 1
	
	if inputX == dir[1] && inputY==dir[0] || inputX == 0-dir[1] && inputY==0-dir[0]:
		if dir[0] == -1:
			movement.y = abs(movement.x) * inputY
		else:
			movement.y = 0
	else:
		if inputX == 0:
			if inputY == dir[0]:
				movement.x += dir[1] * abs(movement.y * 2) / 1.8
			else:
				movement.x += (-dir[1]) * abs(movement.y * 2) / 1.8
			
		if inputY == 0:
			if inputX == dir[1]:
				movement.y += dir[0] * abs(movement.x) / 1.8
			else:
				movement.y += (-dir[0]) * abs(movement.x) / 1.8
			
	
	
	if movement.x > 0:
		$Sprite.flip_h = false
	if movement.x < 0:
		$Sprite.flip_h = true
	velocity = movement
	move_and_slide()
