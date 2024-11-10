extends CharacterBody3D
class_name LinearMovingPlatform

@export var direction: Vector3
@export var speed = 2.0
@export var range = 4.0
@export var trigger: Trigger
var initial_position: Vector3

var enabled = true

func _ready():
	if (trigger):
		enabled = false
		trigger.trigger.connect(enable)
		trigger.untrigger.connect(disable)
	initial_position = global_position
	direction = direction.normalized()

func enable():
	enabled = true
	
func disable():
	enabled = false

func _physics_process(delta):
	if (!enabled):
		return
	var offset = (global_position - initial_position).length()
	
	if abs(offset) >= range:
		direction *= -1
		
	velocity = direction * speed
	move_and_slide()
