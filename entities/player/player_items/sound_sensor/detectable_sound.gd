class_name DetectableSound
extends Area3D

signal detected(sound: AudioStream)

@export var sensor_sound_resource: AudioStream = preload("res://resources/sounds/sfx/take_me_to_your_leader.ogg")
