extends Trigger
class_name ShadowPlate

var pressed_height = 0.2
var original_height

var pressed = false

signal plate_pressed

func _ready() -> void:
	original_height = scale.y

func _press_plate():
	if (pressed == true):
		return
	set_collision_layer_value(3, false)
	scale.y = pressed_height
	global_position.y -= (original_height-pressed_height)/2
	pressed = true
	plate_pressed.emit()
	trigger.emit()
	
