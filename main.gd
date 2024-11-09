extends Node3D

@export var spotlight: Node3D
@export var player: Node3D
@export var player_shadow: CharacterBody3D
@export var player_sprite: Sprite3D
@export var shadow_collider: ShadowCollider
@onready var back_wall: Node3D = $Stage/BackWall

var shadow_mode: bool = false

func _ready():
	player_shadow.visible = false

func _physics_process(_delta):
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

func project_point_to_wall(point: Vector3) -> Vector3:
	var light_pos = spotlight.global_position
	var wall_z = back_wall.global_position.z
	
	var light_dir = (point - light_pos).normalized()
	
	if abs(light_dir.z) < 0.001:
		return point
	
	var t = (wall_z - light_pos.z) / light_dir.z
	var intersection = light_pos + light_dir * t
	
	return Vector3(intersection.x, intersection.y, 0)

func calculate_shadow_bounds(projected_points: Array) -> Dictionary:
	var min_x = INF
	var max_x = -INF
	var min_y = INF
	var max_y = -INF
	
	for point in projected_points:
		min_x = min(min_x, point.x)
		max_x = max(max_x, point.x)
		min_y = min(min_y, point.y)
		max_y = max(max_y, point.y)
	
	return {
		"center": Vector2((min_x + max_x) / 2, (min_y + max_y) / 2),
		"size": Vector2(max_x - min_x, max_y - min_y)
	}

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
	
	update_shadow_projection()
	shadow_mode = !shadow_mode
		
	if shadow_mode:
		enter_shadow_mode()
	else:
		exit_shadow_mode()

func enter_shadow_mode():
	player.visible = false
	
	# Enable shadow physics and disable normal collider
	player_shadow.set_physics_process(true)
	player_shadow.visible = true

func exit_shadow_mode():
	# Calculate new player position
	var new_pos = calculate_player_position_from_shadow(player_shadow.global_position)
	
	player.global_position = new_pos
	player.visible = true
	
	player_shadow.set_physics_process(false)
	player_shadow.visible = false

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

func update_shadow_projection():
		
	var corners = get_object_corners(player)
	var projected_corners = []
	
	for corner in corners:
		var projected_point = project_point_to_wall(corner)
		projected_corners.append(projected_point)
		shadow_collider.vertices.append(projected_point)
	
	var bounds = calculate_shadow_bounds(projected_corners)
	
	player_shadow.global_position = Vector3(
		bounds.center.x,
		bounds.center.y,
		back_wall.global_position.z + back_wall.scale.z/2
	)
	
	player_shadow.scale = Vector3(bounds.size.x, bounds.size.y, 0.1)
