extends Node3D

@export var animation_player: AnimationPlayer
@export var is_open: bool = false

func _ready():
	if is_open:
		open_door()


func open_door():
	is_open = true
	animation_player.play("door_open")


func close_door():
	is_open = false
	animation_player.play("door_close")


func toggle_door() -> void:
	if is_open:
		close_door()
	else:
		open_door()


func _on_small_button_pressed():
	toggle_door()


func _on_big_button_pressed():
	toggle_door()
