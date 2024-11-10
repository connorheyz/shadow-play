extends CharacterBody3D

var direction = 1
const SPEED = 2.0
const RANGE = 4.0
var initial_x
var initial_z

func _ready():
	initial_x = global_position.x
	initial_z = global_position.z

func _physics_process(delta):
	var offset = global_position.x - initial_x
	var offset = global_position.z - initial_z
	
	if abs(offset) >= RANGE:
		direction *= -1
		
	velocity.x = direction * SPEED
	velocity.z = direction * SPEED
	move_and_slide()
