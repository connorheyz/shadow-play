extends Node

@export var camera: Camera3D
@export var radius: float = 10
@export var max_theta_hori = PI/4
@export var max_theta_vert = PI/6
@export var min_theta_vert = -PI/30

@export var min_y: float
@export var max_y: float

@export 

var origin: Vector3

@export var theta_hori: float = 0
@export var theta_vert: float = 0

var theta_speed = 0.6
var move_speed = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	origin = camera.global_position + (Vector3(0, 0, -1) * radius)
	_draw_camera(theta_hori, theta_vert)

func _move_camera(delta: float):
	var direction_hori = Input.get_axis("move_left", "move_right")
	var direction_vert = Input.get_axis("move_down", "move_up")
	
	if (abs(theta_hori + direction_hori * theta_speed * delta) <= max_theta_hori):
		theta_hori += direction_hori * theta_speed * delta
		
	theta_vert += direction_vert * theta_speed * delta	
	if (theta_vert < min_theta_vert):
		theta_vert = min_theta_vert
	if (theta_vert > max_theta_vert):
		theta_vert = max_theta_vert
		
	_draw_camera(theta_hori, theta_vert)
		
func _draw_camera(theta_hori: float, theta_vert: float):
	camera.global_position = origin + (Vector3(sin(theta_hori), 0, cos(theta_hori)) * radius)
	camera.global_position += Vector3(0, sin(theta_vert), 0) * radius
	camera.rotation.y = theta_hori
	camera.rotation.x = -theta_vert * cos(theta_vert)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_pressed("manipulate_camera")):
		_move_camera(delta)
