extends Node3D
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
	scale.y = pressed_height
	global_position.y -= (original_height-pressed_height)/2
	pressed = true
	plate_pressed.emit()
	
