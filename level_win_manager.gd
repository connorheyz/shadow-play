extends Node

@export var win_trigger: Trigger

@export var next_level: String

@export var current_level: String

@export var player: Player3D

@export var player_shadow: PlayerShadow

@export var win_screen: Resource
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	win_trigger.trigger.connect(win_level)
	
func win_level():
	player.enabled = false
	player_shadow.enabled = false
	var screen: WinScreen = win_screen.instantiate()
	screen.next_level = next_level
	screen.current_level = current_level
	add_child(screen)
	
func go_to_next_scene():
	get_tree().change_scene_to_file("res://" + next_level)
	
