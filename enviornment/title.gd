extends VBoxContainer

@export var screenSelect: Array[String]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event):
	pass
	


func _on_level_select_button_up() -> void:
	get_tree().change_scene_to_file("res://" + screenSelect[0])


func _on_credits_button_up() -> void:
	get_tree().change_scene_to_file("res://" + screenSelect[1])
