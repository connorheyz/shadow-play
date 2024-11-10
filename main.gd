extends Node3D
class_name Projector

@export var spotlight: Node3D
@export var player: Node3D
@export var player_mesh: MeshInstance3D
@export var player_shadow: PlayerShadow
@export var player_collider: CollisionShape3D
@onready var back_wall: Node3D = $Stage/BackWall

var shadow_mode: bool = false

func _ready():
	player_shadow.visible = false
	player_shadow.is_active = false
	player_shadow.shadow_exit.connect(shadow_die)

func shadow_die():
	shadow_mode = false
	exit_shadow_mode()

func _physics_process(_delta):
	if (shadow_mode):
		update_shadow_projection(false)
	if Input.is_action_just_pressed("switch_mode"):
		attempt_toggle_shadow_mode()

func get_object_corners(obj: Node3D) -> Array:
	var corners = []
	
	for x in [-0.5, 0.5]:
		for y in [-0.5, 0.5]:
			for z in [-0.5, 0.5]:
				var local_pos = Vector3(x, y, z)
				var world_pos = obj.global_transform * local_pos
				corners.append(world_pos)
	
	return corners


static func project_point_to_wall(spotlight_pos: Vector3, point: Vector3, z_pos: float) -> Vector3:
	
	var light_dir = (point - spotlight_pos).normalized()

	if abs(light_dir.z) < 0.001:
		return point
	
	var t = (z_pos - spotlight_pos.z) / light_dir.z
	var intersection = spotlight_pos + light_dir * t
	
	return Vector3(intersection.x, intersection.y, z_pos)

func can_toggle_shadow_mode() -> bool:
	var shape = player_shadow.get_child(0).shape
	var params = PhysicsShapeQueryParameters3D.new()
	params.shape = shape
	params.transform = player_shadow.global_transform
	params.collision_mask = 2
	
	var space = get_world_3d().direct_space_state
	var collisions = space.intersect_shape(params)
	
	collisions = collisions.filter(func(collision): 
		return collision.collider != player_shadow
	)
	
	return collisions.is_empty()

func attempt_toggle_shadow_mode():
	
	if (!shadow_mode):
		update_shadow_projection(true)
		if (player_shadow.shadow_collider.test_offset(Vector3(0,0,0))):
			return
		shadow_mode = true
		enter_shadow_mode()
	else:
		shadow_mode = false
		exit_shadow_mode()
		

func enter_shadow_mode():
	player_mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_SHADOWS_ONLY
	player_collider.disabled = true
	player.enabled = false
	
	# Enable shadow physics and disable normal collider
	player_shadow.set_physics_process(true)
	player_shadow.visible = true
	player_shadow.is_active = true

func exit_shadow_mode():
	# Calculate new player position
	player_mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
	player_collider.disabled = false
	player.enabled = true
	
	player_shadow.set_physics_process(false)
	player_shadow.visible = false
	player_shadow.is_active = false

func calculate_player_position_from_shadow(shadow_pos: Vector3) -> Vector3:
	var light_pos = spotlight.global_position
	var wall_z = back_wall.global_position.z
	
	# Calculate ray direction from light to shadow
	var to_shadow = shadow_pos - light_pos
	var light_dir = to_shadow.normalized()
	
	# Calculate distance from light to wall
	var wall_dist = abs(wall_z - light_pos.z)
	
	# Scale the direction based on the player's original distance from the wall
	var original_dist = abs(player.global_position.z - wall_z)
	var scale_factor = original_dist / wall_dist
	
	# Calculate new position
	return light_pos + light_dir * (to_shadow.length() * scale_factor)

static func get_negative_z_face(node: Node3D):
	return node.global_position.z + node.scale.z/2

func update_shadow_projection(position: bool):
		
	var corners = get_object_corners(player)
	var projected_corners = []
	var rel_projected_points: Array[Vector3] = []
	
	var center = Vector3(0, 0, 0)
	
	for corner in corners:
		var projected_point = project_point_to_wall(spotlight.global_position, corner, get_negative_z_face(back_wall))
		center += projected_point
		projected_corners.append(projected_point)
		
	center /= len(corners)
	
	for corner in projected_corners:
		rel_projected_points.append(corner - center)
		
	player_shadow.shadow_collider.vertices = rel_projected_points
	
	if (position):
		player_shadow.global_position = Vector3(
			center.x,
			center.y,
			back_wall.global_position.z + back_wall.scale.z/2
		)
