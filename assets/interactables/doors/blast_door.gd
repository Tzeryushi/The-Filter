extends Node3D

#@export var animation_player: AnimationPlayer
@export var is_open: bool = false

@export var open_sound: AudioStream
@export var close_sound: AudioStream

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready():
	if is_open:
		open_door()


func open_door():
	is_open = true
	animation_player.play("door_open")


func close_door():
	is_open = false
	animation_player.play("door_close")


func toggle() -> void:
	if !is_open:
		open_door()
	else:
		close_door()


func set_door_open(state: bool) -> void:
	if state:
		open_door()
	else:
		close_door()


func _on_small_button_pressed():
	toggle()


func _on_env_player_entered(_player):
	toggle()


func _on_area_body_entered(_body):
	open_door()


func _on_area_3d_body_exited(_body):
	close_door()
