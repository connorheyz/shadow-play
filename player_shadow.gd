extends CharacterBody3D

@export var SPEED = 10.0
@export var JUMP_FORCE = 7.0
@export var JUMP_FORCE = 10.0
var JUMP_SPEED = 0
@export var GRAVITY_ACCEL = 15
var GRAVITY_SPEED = 0
@export var shadow_collider: ShadowCollider
@export var spotlight: SpotLight3D

@export var playerbody: Player3D
var playerbody_linked = true

var is_active = false

var object_should_move = false
var normal

func _ready() -> void:
	shadow_collider.body_collided.connect(_move_object)
	
func _move_object(hit_normal: Vector3):
	print("object hit with normal = ", normal)
func _move_object(hit_normal: Vector3, other: Node3D):
	object_should_move = true
	normal = hit_normal

	normal = Vector2(hit_normal.x, hit_normal.y)
	
func move_step(direction: Vector2, override: bool):
	var new_dimension = Vector3(direction.x, direction.y, 0)
	if override:
		position = position + new_dimension
		move_playerbody(direction)
		return true
	if (!shadow_collider.test_offset(new_dimension)):
		position = position + new_dimension
		if (playerbody_linked):
			move_playerbody(direction)
		return true
	return false
	
func move_playerbody(direction: Vector2):
	var vel_scale = (playerbody.global_position-spotlight.global_position).length()/(global_position - spotlight.global_position).length()
	playerbody.position += Vector3(direction.x, direction.y, 0) * vel_scale
	
func _physics_process(delta):
	
	if (!is_active):
		return
	
	if (object_should_move):
		move_step(normal * delta, true)
		object_should_move = false
	
	if Input.is_action_just_pressed("jump"):
		JUMP_SPEED = JUMP_FORCE
	
	var jump_dir = Vector2(0, 0)
	
	GRAVITY_SPEED += GRAVITY_ACCEL * delta
	jump_dir.y -= GRAVITY_SPEED * delta
	jump_dir.y += JUMP_SPEED * delta
	
	if (!move_step(jump_dir, false)):
		GRAVITY_SPEED = 0
		JUMP_SPEED = 0
	
	var mov_dir = Vector2(0, 0)
	mov_dir.x = Input.get_axis("move_left", "move_right") * SPEED * delta
	move_step(mov_dir, false)
	
	
	
	
