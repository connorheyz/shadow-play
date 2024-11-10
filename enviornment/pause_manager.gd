extends Node


@export var pause_screen: Resource

var screen_paused: Control
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
	
func _input(event):
	if(event.is_action_pressed("ui_cancel")):
		pause_level()
func pause_level():
	if(get_tree().paused == false):
		var screen: PauseMenu = pause_screen.instantiate()
		screen_paused = screen
		screen.main_scene = get_tree()
		get_tree().root.add_child(screen)
		get_tree().paused = true
		
	elif(get_tree().paused == true):
		if(is_instance_valid(screen_paused)):
			screen_paused.queue_free()
		get_tree().paused = false
	
		

	

	
