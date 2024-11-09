extends CharacterBody3D

@export var SPEED = 10.0
@export var JUMP_FORCE = 7.0
var JUMP_SPEED = 0
@export var GRAVITY_ACCEL = 15
var GRAVITY_SPEED = 0
@export var shadow_collider: ShadowCollider

var object_should_move = false
var normal

func _ready() -> void:
	shadow_collider.body_collided.connect(_move_object)
	
func _move_object(hit_normal: Vector3):
	object_should_move = true
	normal = hit_normal

func _physics_process(delta):
	
	if (object_should_move):
		position += normal * delta
		object_should_move = false
	
	if Input.is_action_just_pressed("jump"):
		JUMP_SPEED = JUMP_FORCE
	
	var offset = Vector3(0, 0, 0)
	
	GRAVITY_SPEED += GRAVITY_ACCEL * delta
	offset.y -= GRAVITY_SPEED * delta
	offset.y += JUMP_SPEED * delta
	
	if (!shadow_collider.test_offset(offset)):
		position = position + offset
	else:
		GRAVITY_SPEED = 0
		JUMP_SPEED = 0
		
	offset = Vector3(0, 0, 0)
	
	var direction = Input.get_axis("move_left", "move_right")
	offset.x = direction * SPEED * delta
	
	if (!shadow_collider.test_offset(offset)):
		position = position + offset
		
	offset = Vector3(0, 0, 0)
		
	if (!shadow_collider.test_offset(offset)):
		position = position + offset
	
	
	
	
