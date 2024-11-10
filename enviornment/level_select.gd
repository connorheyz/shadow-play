extends Control
class_name LevelSelectMenu

@export var LevelSelect: Array[String]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_level_1_button_up() -> void:
	get_tree().change_scene_to_file("res://" + LevelSelect[0])


func _on_level_2_button_up() -> void:
	get_tree().change_scene_to_file("res://" + LevelSelect[1])


func _on_level_3_button_up() -> void:
	get_tree().change_scene_to_file("res://" + LevelSelect[2])


func _on_level_4_button_up() -> void:
	get_tree().change_scene_to_file("res://" + LevelSelect[3])


func _on_level_5_button_up() -> void:
	get_tree().change_scene_to_file("res://" + LevelSelect[4])


func _on_back_button_up() -> void:
	get_tree().change_scene_to_file("res://enviornment/" + LevelSelect[5])
