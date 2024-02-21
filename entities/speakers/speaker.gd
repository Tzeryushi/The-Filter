class_name Speaker
extends Node3D


signal dialogue_started(dialogue:JSON, dialogue_dict: Dictionary, speaker: Speaker)

@export var dialogue: JSON
@export var dialogue_dict: Dictionary = {}

var is_speaking: bool = false : set = set_speaking

@onready var animator: AnimationPlayer = $SpeakerPos/SpeakerAnim


func start_dialogue() -> void:
	if is_speaking:
		return
	dialogue_started.emit(dialogue, dialogue_dict, self)
	is_speaking = true


func end_dialogue() -> void:
	if is_speaking:
		is_speaking = false


func set_speaking(value: bool) -> void:
	if value != is_speaking:
		if value:
			animator.play("speaking")
		else:
			animator.stop()
	is_speaking = value
