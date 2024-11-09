# shadow_manager.gd
extends Node3D

@export var spotlight: Node3D
@export var player: Node3D
@export var player_shadow: CharacterBody3D
@onready var back_wall: Node3D = $Stage/BackWall
var shadow_catchers: Array
@onready var player_sprite_texture = preload("res://shadow.png") 

const hell: Vector3 = Vector3(-10000, -1000000, -100000)

var shadow_colliders: Dictionary = {}
var shadow_mode: bool = false

func create_shadow_collider(is_player: bool = false) -> Node3D:
	var body = CharacterBody3D.new() if is_player else StaticBody3D.new()
	body.name = "ShadowCollider"
	
	var collision_shape = CollisionShape3D.new()
	var shape = BoxShape3D.new()
	collision_shape.shape = shape
	
	body.add_child(collision_shape)
	add_child(body)
	
	if is_player:
		body.collision_layer = 0
	else:
		body.collision_layer = 2
	
	return body

func setup_shadow_catchers() -> void:
	var a = get_tree().get_nodes_in_group("ShadowCatcher")
	
	for n in a:
		var pSprite: Sprite3D = Sprite3D.new()
		pSprite.set_texture(player_sprite_texture)
		pSprite.visible = false
		get_tree().root.add_child.call_deferred(pSprite)
		
		var normal = Vector3(0, 0, 1)
		
		shadow_catchers.append({
			"catcher" : n as Node3D,
			"normal" : normal,
			"player" : pSprite
		})

func _ready():
	setup_shadow_colliders()
	
	setup_shadow_catchers()
	
	var player_collider = create_shadow_collider(true)
	shadow_colliders[player] = player_collider
	player_collider.set_physics_process(false)
	player_shadow.visible = false

func _physics_process(_delta):
	update_all_shadows()
	
	if Input.is_action_just_pressed("switch_mode"):
		attempt_toggle_shadow_mode()
		
func setup_shadow_colliders():
	var projectables = get_tree().get_nodes_in_group("Projectable")
	
	for obj in projectables:
		var shadow_collider = create_shadow_collider()
		shadow_colliders[obj] = shadow_collider

func update_all_shadows():
	update_shadow_projection()

func get_object_corners(obj: Node3D) -> Array:
	var corners = []
	
	for x in [-0.5, 0.5]:
		for y in [-0.5, 0.5]:
			for z in [-0.5, 0.5]:
				var local_pos = Vector3(x, y, z)
				var world_pos = obj.global_transform * local_pos
				corners.append(world_pos)
	
	return corners

func project_point_to_wall(point: Vector3, wall: Node3D, normal: Vector3):
	var light_pos = spotlight.global_position
	
	var light_dir: Vector3 = (point - light_pos).normalized()
	
	# this ray is now traced to find the collision point with it and the wall
	var denominator = normal.dot(light_dir)
	var t: float
	if (abs(denominator) > 0.0001):
		var wally = wall.global_position
		wally.z += 0.51
		t = (wally - light_pos).dot(normal) / denominator
	
	if t < 0:
		return null
	
	# we collide, and we know where along the ray this happens
	return light_pos + light_dir * t

func calculate_shadow_bounds(projected_points: Array) -> Dictionary:
	var min_x = INF
	var max_x = -INF
	var min_y = INF
	var max_y = -INF
	var min_z = INF
	var max_z = -INF
	
	var valid: bool = false
	
	for point in projected_points:
		if (point == null):
			continue
		valid = true
		min_x = min(min_x, point.x)
		max_x = max(max_x, point.x)
		min_y = min(min_y, point.y)
		max_y = max(max_y, point.y)
		max_z = max(max_z, point.z)
		min_z = min(min_z, point.z)
	
	var size = Vector3()
	
	return {
		"valid": valid,
		"center": Vector3((min_x + max_x) / 2, (min_y + max_y) / 2, (min_z + max_z) / 2),
		"size": Vector3(max(max_x - min_x, 0.01), max(max_y - min_y, 0.01), max(max_z - min_z, 0.01))
	}

func can_toggle_shadow_mode() -> bool:
	var player_shadow = shadow_colliders[player]
	
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
	if can_toggle_shadow_mode():
		shadow_mode = !shadow_mode
		
		if shadow_mode:
			enter_shadow_mode()
		else:
			exit_shadow_mode()

func enter_shadow_mode():
	player.visible = false
	for c in shadow_colliders:
		c["player"].visible = true
	
	# Transfer collision shape to player shadow
	var shadow_collider = shadow_colliders[player]
	var shape = shadow_collider.get_child(0).shape.duplicate()
	player_shadow.get_child(0).shape = shape
	player_shadow.get_child(1).scale.x = shape.size.x
	player_shadow.get_child(1).scale.y = shape.size.y
	player_shadow.global_position = shadow_collider.global_position
	
	# Enable shadow physics and disable normal collider
	shadow_collider.set_physics_process(false)
	player_shadow.set_physics_process(true)
	player_shadow.visible = true

func exit_shadow_mode():
	# Calculate new player position
	var new_pos = calculate_player_position_from_shadow(player_shadow.global_position)
	
	player.global_position = new_pos
	player.visible = true
	for c in shadow_colliders:
		c["player"].visible = false
	
	player_shadow.set_physics_process(false)
	player_shadow.visible = false
	
	shadow_colliders[player].set_physics_process(true)

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
	for curr_shadow_catcher in shadow_catchers:
		var catcher = curr_shadow_catcher["catcher"]
		var normal: Vector3 = curr_shadow_catcher["normal"]
		var player_sprite: Sprite3D = curr_shadow_catcher["player"]

		if shadow_mode:
			return
		
		var corners = get_object_corners($Player3D)
		var projected_corners = []
		for corner in corners:
			projected_corners.append(project_point_to_wall(corner, catcher, normal))
		
		var bounds = calculate_shadow_bounds(projected_corners)
		print("for ", catcher.name, ", bounds are ", bounds["valid"])
		if (bounds["valid"]):
			print(bounds)
		
		if bounds["valid"]:
			if player_sprite.is_inside_tree():
				player_sprite.global_position = bounds["center"]
				if (normal == Vector3.RIGHT):
					bounds["size"].x = 4
				player_sprite.scale = bounds["size"] * 10
		else:
			if player_sprite.is_inside_tree():
				player_sprite.global_position = hell
				player_sprite.scale = Vector3(0.1, 0.1, 0.1)
	
