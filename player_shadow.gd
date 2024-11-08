extends CharacterBody3D

@export var SPEED = 300.0
@export var JUMP_VELOCITY = 400.0
@export var GRAVITY = 9.8

func _physics_process(delta):
	if not is_visible_in_tree():
		return
	
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY * delta
			
	var direction = Input.get_axis("move_left", "move_right")
	velocity.x = direction * SPEED * delta
	
	move_and_slide()
