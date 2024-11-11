extends Trigger
class_name ShadowPlate

var pressed = false

@onready var pressed_node: Node3D = $PressedNode
@onready var pressed_collider: CollisionShape3D = $PressedNode/CollisionShape3D
@onready var unpressed_node: Node3D = $UnpressedNode
@onready var unpressed_collider: CollisionShape3D = $UnpressedNode/CollisionShape3D

@export var unpress_trigger: Trigger

@export var start_toggled: bool = false

func _ready() -> void:
	
	if (start_toggled):
		toggle_node(unpressed_node, unpressed_collider, false)
		pressed = true
	else:
		toggle_node(pressed_node, pressed_collider, false)
	
	if (unpress_trigger):
		unpress_trigger.trigger.connect(_unpress_plate)

func toggle_node(node: Node3D, collider: CollisionShape3D, enabled: bool):
	node.visible = enabled
	collider.set_deferred("disabled", !enabled)
	
func _unpress_plate():
	if (pressed == false):
		return
	toggle_node(unpressed_node, unpressed_collider, true)
	toggle_node(pressed_node, pressed_collider, false)
	pressed = false
	untrigger.emit()

func _press_plate():
	if (pressed == true):
		return
	toggle_node(unpressed_node, unpressed_collider, false)
	toggle_node(pressed_node, pressed_collider, true)
	pressed = true
	trigger.emit()
	
