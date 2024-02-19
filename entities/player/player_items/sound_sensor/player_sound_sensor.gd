extends PlayerItem


@export var sound_on: AudioStream = preload("res://entities/player/player_items/flashlight/Flashlight on.wav")
@export var sound_off: AudioStream = preload("res://entities/player/player_items/flashlight/Flashlight off.wav")
@export var sound_default: AudioStream = preload("res://entities/player/player_items/sound_sensor/ScatterNoise1.mp3")
@export var sound_sensor_ray: RayCast3D

var active_stream_player: PrioritizedAudioStreamPlayer
var is_on : bool = false : set = set_is_on
var is_detected: bool = false


func _ready() -> void:
	is_on = false


func on_exit() -> void:
	stop_sensor_sound()
	set_is_on(false)
	sound_sensor_ray.enabled = false


func _on_sound_detected(detected: DetectableSound):
	if !is_detected and is_on:
		is_detected = true
		play_sensor_sound(detected.sensor_sound)


func _on_sound_detections_ceased():
	is_detected = false
	if is_on:
		play_sensor_sound(sound_default)


func use() -> void:
	is_on = !is_on
	if is_on:
		AudioManager.play_sound(sound_on)
		play_sensor_sound(sound_default)
		sound_sensor_ray.set_enabled(true)
	else:
		AudioManager.play_sound(sound_off)
		sound_sensor_ray.set_enabled(false)
		is_detected = false
		stop_sensor_sound()


func play_sensor_sound(sound: AudioStream):
	if !active_stream_player:
		var stream_player_id = AudioManager.play_sound(sound)
		active_stream_player = instance_from_id(stream_player_id)
	else:
		active_stream_player.stream = sound
		active_stream_player.play()
	if !active_stream_player.is_connected("finished", active_stream_player.play):
		active_stream_player.finished.connect(active_stream_player.play)


func stop_sensor_sound():
	if active_stream_player:
		if active_stream_player.is_connected("finished", active_stream_player.play):
			active_stream_player.finished.disconnect(active_stream_player.play)
		active_stream_player.stop()


func set_is_on(value:bool) -> void:
	is_on = value
