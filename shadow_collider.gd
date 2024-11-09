extends Node3D
class_name ShadowCollider

@export var spotlights: Array[Node3D] = []
@export var vertices: Array[Vector3] = []

signal body_collided
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func project_ray_to_vertices(origin: Vector3) -> bool:
	for vertex in vertices:
		var result = project_ray_to_point(origin, vertex)
		if result:
			return true
	return false
	
func test_offset(offset: Vector3):
	for spotlight in spotlights:
		for vertex in vertices:
			var result = project_ray_to_point(spotlight.global_position, vertex + offset)
			if result:
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
	for spotlight in spotlights:
		if (project_ray_to_vertices(spotlight.global_position)):
			body_collided.emit()
