extends Node3D

signal pressed

@export var press_on_sound: AudioStream
@export var press_off_sound: AudioStream
@export var case_sound: AudioStream

var glass_case: MeshInstance3D
var button: MeshInstance3D
var animation_player: AnimationPlayer
var button_interact_shape: CollisionShape3D
var case_interact_shape: CollisionShape3D
var button_pressed: bool = false


func _ready():
	glass_case = get_node("big_button/Glass")
	animation_player = get_node("AnimationPlayer")
	button_interact_shape = get_node("ButtonInteract/CollisionShape3D")
	case_interact_shape = get_node("CaseInteract/CollisionShape3D")


func _on_glass_case_interacted(_interacting_node):
	case_interact_shape.disabled = true
	if case_sound:
		AudioManager.play_sound_at_location(case_sound, global_position)
	animation_player.play("case_open")


func _on_button_interacted(_interacting_node):
	button_interact_shape.disabled = true
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
		button_interact_shape.disabled = false
