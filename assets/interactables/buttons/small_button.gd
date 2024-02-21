extends Node3D

signal pressed

@export var press_on_sound: AudioStream
@export var press_off_sound: AudioStream

var animation_player: AnimationPlayer
var is_pressed: bool = false

func _ready():
	animation_player = get_node("AnimationPlayer")


func _on_button_interact_interacted(_interacting_node):
	if !is_pressed:
		animation_player.play("button_press")
		if press_on_sound:
			AudioManager.play_sound_at_location(press_on_sound, global_position)
		pressed.emit()
		is_pressed = true


func _on_animation_player_animation_finished(_anim_name):
	if press_off_sound:
		AudioManager.play_sound_at_location(press_off_sound, global_position)
	is_pressed = false
