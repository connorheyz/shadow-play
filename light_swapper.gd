extends Node

@export var trigger: Trigger
@export var spotlight: SpotLight3D

@onready var first: Node3D = $First
@onready var second: Node3D = $Second
@onready var target: Node3D = $Target

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	trigger.trigger.connect(enable_second)
	trigger.untrigger.connect(enable_first)
	enable_first()

func enable_first():
	spotlight.global_position = first.global_position
	spotlight.look_at(target.global_position)
	
func enable_second():
	spotlight.global_position = second.global_position
	spotlight.look_at(target.global_position)
