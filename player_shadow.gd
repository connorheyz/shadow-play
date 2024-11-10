extends CharacterBody3D
class_name PlayerShadow

@export var SPEED = 10.0
@export var JUMP_FORCE = 12
@onready var shadow_collider: ShadowCollider = $ShadowCollider
@export var GRAVITY_ACCEL = 20.0
@export var spotlight: SpotLight3D
@onready var playerbody: Player3D = get_parent().get_child(0)

var playerbody_linked = true

var enabled = false

var wall_frames = 0
var GRAVITY_SPEED = 0
var JUMP_SPEED = 0

var object_should_move = false
var normal

signal shadow_exit

func _ready() -> void:
	shadow_collider.body_collided.connect(_move_object)
	
func _move_object(hit_normal: Vector3, other: Node3D):
	object_should_move = true
	normal = Vector2(hit_normal.x, hit_normal.y) * 2.5
	if (other.get_parent() is ShadowPlate):
		other.get_parent()._press_plate()
	
func move_in_pieces(direction: Vector2):
	var x_direction = Vector3(direction.x, 0, 0)
	if (!shadow_collider.test_offset(x_direction)):
		position = position + x_direction
		if (playerbody_linked):
			move_playerbody(x_direction)
	var y_direction = Vector3(0, direction.y, 0)
	if (!shadow_collider.test_offset(y_direction)):
		position = position + y_direction
		if (playerbody_linked):
			move_playerbody(y_direction)
	
func move_step(direction: Vector2):
	var new_dimension = Vector3(direction.x, direction.y, 0)
	if (!shadow_collider.test_offset(new_dimension)):
		position = position + new_dimension
		if (playerbody_linked):
			move_playerbody(new_dimension)
		return true
	return false
	
func move_playerbody(direction: Vector3):
	var vel_scale = (playerbody.global_position-spotlight.global_position).length()/(global_position - spotlight.global_position).length()
	playerbody.position += direction * vel_scale
	
func _physics_process(delta):
	
	if (!enabled):
		return
		
	if (shadow_collider.is_in_wall):
		wall_frames += 1
	else:
		wall_frames = 0
		
	if (wall_frames >= 20):
		shadow_exit.emit()
	
	if (object_should_move):
		move_in_pieces(normal * delta)
		object_should_move = false
		
	if (!Input.is_action_pressed("manipulate_camera")):
		var mov_dir = Vector2(0, 0)
		mov_dir.x = Input.get_axis("move_left", "move_right") * SPEED * delta
		move_step(mov_dir)
	
	if Input.is_action_just_pressed("jump"):
		JUMP_SPEED = JUMP_FORCE
	
	var jump_dir = Vector2(0, 0)
	
	GRAVITY_SPEED += GRAVITY_ACCEL * delta
	jump_dir.y -= GRAVITY_SPEED * delta
	jump_dir.y += JUMP_SPEED * delta
	
	if (!move_step(jump_dir)):
		GRAVITY_SPEED = 0
		JUMP_SPEED = 0
