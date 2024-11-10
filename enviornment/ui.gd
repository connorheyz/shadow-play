extends Control

@export var MenuSelect: Array[String]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_play_button_up() -> void:
	print(MenuSelect[0])
	get_tree().change_scene_to_file("res://" + MenuSelect[0])


func _on_level_select_button_up() -> void:
	get_tree().change_scene_to_file("res://enviornment/" + MenuSelect[1])


func _on_controls_button_up() -> void:
	get_tree().change_scene_to_file("res://enviornment/" + MenuSelect[2])


func _on_credits_button_up() -> void:
	get_tree().change_scene_to_file("res://enviornment/" + MenuSelect[3])
