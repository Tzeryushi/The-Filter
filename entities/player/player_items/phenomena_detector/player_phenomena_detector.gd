extends PlayerItem


@export var sound_on: AudioStream = preload("res://entities/player/player_items/flashlight/Flashlight on.wav")
@export var sound_off: AudioStream = preload("res://entities/player/player_items/flashlight/Flashlight off.wav")
@export var phenomena_detector_rays: Array[RayCast3D]

var active_stream_player: PrioritizedAudioStreamPlayer
var is_on : bool = false : set = set_is_on
var is_detected: bool = false


func _ready() -> void:
	is_on = false


func on_exit() -> void:
	set_is_on(false)


func _on_sound_detected(detected: DetectableSound):
	if !is_detected and is_on:
		is_detected = true


func _on_sound_detections_ceased():
	is_detected = false


func use() -> void:
	is_on = !is_on
	if is_on:
		AudioManager.play_sound(sound_on)
	else:
		AudioManager.play_sound(sound_off)


func set_is_on(value:bool) -> void:
	is_on = value
