extends Control
class_name WinScreen

@export var next_level: String
@export var current_level: String
@export var title_scene: String
@export var level_select_scene: String

@export var next_level_button: Button
@export var retry_level_button: Button
@export var level_select_button: Button
@export var title_screen_button: Button
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	next_level_button.pressed.connect(go_to_level.bind(next_level))
	retry_level_button.pressed.connect(go_to_level.bind(current_level))
	level_select_button.pressed.connect(go_to_level.bind(level_select_scene))
	title_screen_button.pressed.connect(go_to_level.bind(title_scene))
	
func go_to_level(level_name: String):
	get_tree().change_scene_to_file("res://" + level_name)
