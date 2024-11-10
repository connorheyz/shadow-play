extends RigidBody3D

@export var X: int
@export var Y: int
@export var Z: int
@onready var PathBlock: RigidBody3D = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(X!=0):
		PathBlock.axis_lock_linear_x = true
	if(Y!=0):
		PathBlock.axis_lock_linear_y = true
	if(Z!=0):
		PathBlock.axis_lock_linear_z = true
