extends Control

@export var try_again_button: Button
@export var level_select_button: Button
@export var title_screen_button: Button

@export var current_level: String
@export var level_select_scene: String
@export var title_screen_scene: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	try_again_button.pressed.connect(go_to_level.bind(current_level))
	level_select_button.pressed.connect(go_to_level.bind(level_select_scene))
	title_screen_button.pressed.connect(go_to_level.bind(title_screen_scene))

func go_to_level(level_name: String):
	get_tree().change_scene_to_file("res://" + level_name)
