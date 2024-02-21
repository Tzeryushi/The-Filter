extends Node3D

signal pressed

@export var is_active: bool = false

@export var press_on_sound: AudioStream
@export var press_off_sound: AudioStream
@export var case_sound: AudioStream

var glass_case: MeshInstance3D
var button: MeshInstance3D
var animation_player: AnimationPlayer
var button_interact: InteractionVolume
var case_interact: InteractionVolume
var button_pressed: bool = false


func _ready():
	glass_case = get_node("big_button/Glass")
	animation_player = get_node("AnimationPlayer")
	button_interact = get_node("ButtonInteract")
	case_interact = get_node("CaseInteract")
	
	button_interact.set_active(false)
	case_interact.set_active(is_active)


func set_button_active(value: bool) -> void:
	case_interact.set_active(value)


func _on_glass_case_interacted(_interacting_node):
	case_interact.set_active(false)
	if case_sound:
		AudioManager.play_sound_at_location(case_sound, global_position)
	animation_player.play("case_open")


func _on_button_interacted(_interacting_node):
	button_interact.set_active(false)
	button_pressed = true
	if press_on_sound:
		AudioManager.play_sound_at_location(press_on_sound, global_position)
	animation_player.play("button_press")
	pressed.emit()


func _on_animation_player_animation_finished(_anim_name):
	if button_pressed:
		if press_off_sound:
			AudioManager.play_sound_at_location(press_off_sound, global_position)
	else:
		button_interact.set_active(true)
