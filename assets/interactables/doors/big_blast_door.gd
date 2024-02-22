extends Node3D

@export var animation_player: AnimationPlayer
@export var is_open: bool = false

@export var close_sound: AudioStream
@export var open_sound: AudioStream

func _ready():
	if is_open:
		open_door()


func open_door():
	is_open = true
	animation_player.play("door_open")
	AudioManager.play_sound_at_location(open_sound, global_position)


func close_door():
	is_open = false
	animation_player.play("door_close")
	await get_tree().create_timer(0.5).timeout
	AudioManager.play_sound_at_location(close_sound, global_position)


func toggle_door() -> void:
	if is_open:
		close_door()
	else:
		open_door()


func _on_small_button_pressed():
	toggle_door()


func _on_big_button_pressed():
	close_door()


func _on_door_open_volume_player_entered(_player):
	open_door()
