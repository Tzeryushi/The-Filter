extends PlayerItem


@export var sound_on: AudioStream = preload("res://entities/player/player_items/flashlight/Flashlight on.wav")
@export var sound_off: AudioStream = preload("res://entities/player/player_items/flashlight/Flashlight off.wav")
@export var sound_default: AudioStream = preload("res://entities/player/player_items/sound_sensor/ScatterNoise1.mp3")
@export var sound_sensor_ray: RayCast3D

var default_sound_stream_player: PrioritizedAudioStreamPlayer
var phenomena_sound_stream_player: PrioritizedAudioStreamPlayer
var is_on : bool = false : set = set_is_on
var is_detected: bool = false


func _ready() -> void:
	is_on = false


func on_exit() -> void:
	stop_default_sensor_sound()
	set_is_on(false)
	sound_sensor_ray.enabled = false


func _on_sound_detected(detected: DetectableSound, magnitude):
	if (!is_detected or (phenomena_sound_stream_player and phenomena_sound_stream_player.stream != detected.active_sound)) and is_on:
		is_detected = true
		play_phenomena_sensor_sound(detected.active_sound)
	phenomena_sound_stream_player.volume_db = magnitude
	default_sound_stream_player.volume_db = -magnitude * 2


func _on_sound_detections_ceased():
	is_detected = false
	if is_on:
		default_sound_stream_player.volume_db = 0
		stop_phenomena_sensor_sound()


func use() -> void:
	is_on = !is_on
	if is_on:
		AudioManager.play_sound(sound_on)
		play_default_sensor_sound()
		sound_sensor_ray.set_enabled(true)
	else:
		AudioManager.play_sound(sound_off)
		sound_sensor_ray.set_enabled(false)
		is_detected = false
		stop_default_sensor_sound()
		stop_phenomena_sensor_sound()


func play_phenomena_sensor_sound(sound: AudioStream):
	if !phenomena_sound_stream_player:
		var stream_player_id = AudioManager.play_sound(sound, AudioManager.Channel.Phenomena_SFX)
		phenomena_sound_stream_player = instance_from_id(stream_player_id)
	else:
		phenomena_sound_stream_player.stream = sound
		phenomena_sound_stream_player.play()
	if !phenomena_sound_stream_player.is_connected("finished", phenomena_sound_stream_player.play):
		phenomena_sound_stream_player.finished.connect(phenomena_sound_stream_player.play)


func stop_phenomena_sensor_sound():
	if phenomena_sound_stream_player:
		if phenomena_sound_stream_player.is_connected("finished", phenomena_sound_stream_player.play):
			phenomena_sound_stream_player.finished.disconnect(phenomena_sound_stream_player.play)
		phenomena_sound_stream_player.stop()


func play_default_sensor_sound():
	if !default_sound_stream_player:
		var stream_player_id = AudioManager.play_sound(sound_default)
		default_sound_stream_player = instance_from_id(stream_player_id)
	else:
		default_sound_stream_player.stream = sound_default
		default_sound_stream_player.play()
	if !default_sound_stream_player.is_connected("finished", default_sound_stream_player.play):
		default_sound_stream_player.finished.connect(default_sound_stream_player.play)


func stop_default_sensor_sound():
	if default_sound_stream_player:
		if default_sound_stream_player.is_connected("finished", default_sound_stream_player.play):
			default_sound_stream_player.finished.disconnect(default_sound_stream_player.play)
		default_sound_stream_player.stop()


func set_is_on(value:bool) -> void:
	is_on = value
