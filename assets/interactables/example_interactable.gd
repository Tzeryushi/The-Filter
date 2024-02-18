extends Node3D

@export var hinge: Node3D

var closed_rotation := Vector3(0,0,0)
var open_rotation := Vector3(0,-1.74,0)

var is_open: bool = false
var rotation_tween: Tween

func _on_interaction_volume_interacted(_interacting_node):
	var new_rotation: Vector3 = closed_rotation if is_open else open_rotation
	var time: float = 0.2 if is_open else 1.0
	rotation_tween = create_tween()
	rotation_tween.tween_property(hinge, "rotation", new_rotation, time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	is_open = !is_open
