extends Control
class_name LevelSelectMenu

@export var level_names: Array[String]

@export var level_buttons: Array[Button]

@export var title_button: Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("ready")
	for i in range(len(level_names)):
		print("connected")
		print(level_names[i])
		level_buttons[i].pressed.connect(change_to_level.bind(level_names[i]))
	title_button.pressed.connect(change_to_level.bind("enviornment/title_screen.tscn"))
		
func change_to_level(name: String):
	print(name)
	get_tree().change_scene_to_file("res://" + name)
	
