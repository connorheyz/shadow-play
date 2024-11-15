extends Node3D
class_name ShadowCollider

@export var spotlights: Array[Node3D]
@export var vertices: Array[Vector3] = []
@export var back_wall: Node3D
var bounds_2d: Rect2

signal body_collided(normal: Vector3, other: Node3D)

var is_in_wall = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func project_ray_to_vertices(origin: Vector3) -> Array:
	for vertex in vertices:
		var result = project_ray_to_point(origin, vertex)
		if result:
			var other = result.collider
			var hit_position = result.position
			if (other is CharacterBody3D):
				var normal = Projector.project_point_to_wall(origin, hit_position + other.velocity, Projector.get_negative_z_face(back_wall))
				normal -= Projector.project_point_to_wall(origin, hit_position, Projector.get_negative_z_face(back_wall))
				return [normal, other]
			return [Vector3(0, 0, 0), other]
	return []
	
func reduce_z_axis(vector: Vector3):
	return Vector2(vector.x, vector.y)

func test_offset(offset: Vector3):
	if (!bounds_2d.has_point(reduce_z_axis(global_position + offset))):
		return true
	for spotlight in spotlights:
		for vertex in vertices:
			var result = project_ray_to_point(spotlight.global_position, vertex + offset)
			if result:
				body_collided.emit(Vector3.ZERO, result.collider)
				return true
	return false
	
func project_ray_to_point(from: Vector3, target: Vector3):
	var space_state = get_world_3d().get_direct_space_state()
	var params = PhysicsRayQueryParameters3D.new()
	params.from = from
	params.to = global_position + target
	params.exclude = [self, get_parent()]
	params.collision_mask = 0b00000000_00000000_00000000_00000100
	var result = space_state.intersect_ray(params)
	return result
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	is_in_wall = false
	for spotlight in spotlights:
		var normal = project_ray_to_vertices(spotlight.global_position)
		if (len(normal) == 2):
			is_in_wall = true
			body_collided.emit(normal[0], normal[1])
