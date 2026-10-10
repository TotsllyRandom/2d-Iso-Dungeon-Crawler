extends CharacterBody2D


const SPEED = 30.0

@onready var armL = $"VisualContainer/Skeleton2D/hip/torso/left shoulder/left arm"
@onready var armR = $"VisualContainer/Skeleton2D/hip/torso/right shoulder/right arm"

@onready var anim_tree: AnimationTree = $VisualContainer/AnimationTree

func _ready() -> void:
	anim_tree.mixer_applied.connect(_aim_arm)

func _physics_process(_delta: float) -> void:
	var mouse_pos = get_local_mouse_position()
	if mouse_pos.x > to_local(position).x:
		$VisualContainer.scale.x = 1
	if mouse_pos.x < to_local(position).x:
		$VisualContainer.scale.x = -1
	
	var inputX :float= Input.get_axis("plr_move_left", "plr_move_right")
	var inputY :float= Input.get_axis("plr_move_up", "plr_move_down")
	
	
	var inputAxis = [inputX,inputY]
	if inputAxis[0] == 0 && inputAxis[1] == 0:
		var s = ($VisualContainer/AnimationTree.get("parameters/moving?/blend_amount") * .65)
		if s <= .1:
			s = 0
		$VisualContainer/AnimationTree.set("parameters/moving?/blend_amount", s)
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
	
	dir[0] = clamp(dir[0],-1,1)
	dir[1] = clamp(dir[1],-1,1)
	if dir[0] == 0 || dir[1] == 0:
		dir = [0,0]
	if inputX == dir[1] && inputY==dir[0] || inputX == 0-dir[1] && inputY==0-dir[0]:
		if dir[0] == -1:
			movement.y = abs(movement.x) * inputY
		else:
			movement.y = 0
	else:
		if inputX == 0 && dir[1]!=0:
			var s = dir[1]
			if inputY == -(dir[0]):
				s = -(dir[1])
			movement.x += s * abs(movement.y) / 1.8
			
		if inputY == 0 && dir[0]!=0:
			var s = dir[0]
			if inputX == -(dir[1]):
				s = -(dir[0])
			movement.y += s * abs(movement.x) / 1.8
		print(str(dir) + " " + str(movement))
			
	
	
	velocity = movement
	if velocity != Vector2(0,0):
		var s = ($VisualContainer/AnimationTree.get("parameters/moving?/blend_amount") / .8)
		if s == 0:
			s = .1
		if s >= 1:
			s = 1
		$VisualContainer/AnimationTree.set("parameters/moving?/blend_amount", 1)
	move_and_slide()
	
func _aim_arm() -> void:
	var mouse_pos = get_global_mouse_position()
	var facing_right = mouse_pos.x >= global_position.x

	$VisualContainer.scale.x = 1 if facing_right else -1

	var arm: Bone2D = armR if facing_right else armL

	# Convert the mouse position into the arm parent's coordinate space.
	var parent := arm.get_parent() as Node2D
	var target_pos := parent.to_local(mouse_pos)

	# Override only the aiming arm's rotation.
	arm.rotation = (target_pos - arm.position).angle() - PI / 2
