extends CharacterBody3D
class_name Player3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var enabled = true

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func set_orientation(direction: Vector3):
	rotation = Vector3.ZERO
	if (abs(direction.x) > 0):
		rotation.y = deg_to_rad(90 * ((direction.x)/(abs(direction.x))))
	if (abs(direction.z) > 0):
		rotation.y = deg_to_rad((90 * -(direction.z)/(abs(direction.z))) + 90)

func _physics_process(delta):
	if not enabled:
		return
		
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if (!Input.is_action_pressed("manipulate_camera")):
		var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		var direction = Vector3(input_dir.x, 0, input_dir.y)
		
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			set_orientation(direction)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
