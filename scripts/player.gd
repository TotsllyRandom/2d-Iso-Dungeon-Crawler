extends CharacterBody2D


const SPEED = 30.0


func _physics_process(delta: float) -> void:
	var inputX := Input.get_axis("ui_left", "ui_right")
	var inputY = Input.get_axis("ui_up", "ui_down")
	
	var movement = Vector2(
		inputX * SPEED,
		inputY * SPEED / 2
	)
	if inputX > 0:
		$Sprite.flip_h = false
	if inputX < 0:
		$Sprite.flip_h = true
	
	## if: just horizontal: move slight horizontal with vert
	## if: both held: follow slope
	## if: just vert: move slight vert with horizontal
	"""
	var initMovement = movement
	if initMovement.x == 0 && initMovement.y == 0:
			return
	var total = movement.x + (movement.y * 2)
	if $TileSlopes1.has_overlapping_bodies():
		if initMovement.x == 0 && initMovement.y != 0:
			movement.x = initMovement.y / 2
			movement.y = 0
		elif initMovement.y == 0 && initMovement.x != 0:
			movement.y = initMovement.x / 3
			movement.x =0
		else:
			movement.y += initMovement.y
			
	if $TileSlopes2.has_overlapping_bodies():
		if initMovement.x == 0 && initMovement.y != 0:
			movement.x = -initMovement.y / 2
			movement.y = 0
		elif initMovement.y == 0 && initMovement.x != 0:
			movement.y = -initMovement.x / 3
			movement.x =0
		else:
			movement.y += initMovement.y
		
		
	if $TileSlopes3.has_overlapping_bodies():
		if movement.x == 0&& movement.y != 0:
			movement.x = initMovement.y
		movement.y -= initMovement.y
	
	
	if $TileSlopes4.has_overlapping_bodies():
		
		movement.y -= initMovement.y

	if movement.x + (movement.y * 2) != total:
		if movement.x == 0:
			movement.x = total - movement.y
		if movement.y == 0:
			movement.y = total - movement.x
	"""
	

	velocity = movement
	move_and_slide()
