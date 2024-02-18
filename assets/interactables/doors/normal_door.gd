extends Node3D


@export_range(-PI, PI) var rotation_amount : float
@export var hinge: Node3D

var is_open: bool = false
var rotation_tween: Tween
var closed_rotation := Vector3(0,0,0)

@onready var open_rotation := Vector3(0,rotation_amount,0)


func _on_interaction_volume_interacted(_interacting_node):
	var new_rotation: Vector3 = closed_rotation if is_open else open_rotation
	var time: float = 0.2 if is_open else 1.0
	rotation_tween = create_tween()
	rotation_tween.tween_property(hinge, "rotation", new_rotation, time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	is_open = !is_open
