extends CharacterBody3D

var direction = 1
const SPEED = 2.0
const RANGE = 4.0
var initial_z

func _ready():
	initial_z = global_position.z

func _physics_process(delta):
	var offset = global_position.z - initial_z
	
	if abs(offset) >= RANGE:
		direction *= -1
		
	velocity.z = direction * SPEED
	move_and_slide()
