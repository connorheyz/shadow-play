extends Node3D
class_name Player

@export var shadow: PlayerShadow
@export var meshes: Array[MeshInstance3D]
@export var player_3d: Player3D
@export var player_collider_3d: CollisionShape3D
@export var spotlight: SpotLight3D
@export var back_wall: Node3D
@export var bounds: Rect2
# Called when the node enters the scene tree for the first time.
func _ready():
	shadow.playerbody = player_3d
	shadow.spotlight = spotlight
	shadow.shadow_collider.back_wall = back_wall
	shadow.shadow_collider.spotlights = [spotlight]
	shadow.shadow_collider.bounds_2d = bounds
