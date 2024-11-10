extends Trigger
class_name PressurePlate

var pressed = false

@onready var pressed_node: Area3D = $PressedNode
@onready var pressed_collider: CollisionShape3D = $PressedNode/CollisionShape3D
@onready var unpressed_node: Area3D = $UnpressedNode
@onready var unpressed_collider: CollisionShape3D = $UnpressedNode/CollisionShape3D

@export var unpress_trigger: Trigger

func _ready() -> void:
	
	unpressed_node.body_entered.connect(_collide)
	toggle_node(pressed_node, pressed_collider, false)
	
	if (unpress_trigger):
		unpress_trigger.trigger.connect(_unpress_plate)
		
func _collide(other: Node3D):
	if other is Player3D:
		_press_plate()

func toggle_node(node: CollisionObject3D, collider: CollisionShape3D, enabled: bool):
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
	
