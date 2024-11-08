extends CharacterBody3D

var direction = 1
const SPEED = 2.0
const RANGE = 4.0
var initial_x

func _ready():
	initial_x = global_position.x

func _physics_process(delta):
	var offset = global_position.x - initial_x
	
	if abs(offset) >= RANGE:
		direction *= -1
		
	velocity.x = direction * SPEED
	move_and_slide()
