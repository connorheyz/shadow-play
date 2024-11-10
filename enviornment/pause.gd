extends Control
class_name PauseMenu

@export var main_screen: Resource
var main_scene: SceneTree

var level_active: Control
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_resume_button_up() -> void:
	main_scene.paused = false
	queue_free()
	

func _on_level_select_button_up() -> void:
	queue_free()
	var screen: Control = main_screen.instantiate()
	
	#screen.main_scene = get_tree()
	get_tree().root.add_child(screen)
	level_active = screen
