extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if Input.mouse_mode != Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
