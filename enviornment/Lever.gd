extends CharacterBody3D

var inSpace: bool = false
var flipped: bool = false

signal pullTheLever
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("RESET")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass#$"CollisionShape3D".global_position = $Area3D/MeshInstance3D.global_position
	
	#pass
func _input(event):
	
	if(event.as_text() == "L" && inSpace):
		if(!flipped):
			$"AnimationPlayer".play("LeverFlip")
			await get_tree().create_timer(.5).timeout
			emit_signal("pullTheLever")
			flipped = true
		elif(flipped):
			$"AnimationPlayer".play_backwards("LeverFlip")
			await get_tree().create_timer(.5).timeout
			flipped = false

func _on_area_3d_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	if(body.name == "Player3D"):
		inSpace = true
		
		


func _on_area_3d_body_shape_exited(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	inSpace = false
	
