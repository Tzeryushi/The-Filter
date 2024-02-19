extends PlayerItem

@export var sound_on: AudioStream = preload("res://entities/player/player_items/flashlight/Flashlight on.wav")
@export var sound_off: AudioStream = preload("res://entities/player/player_items/flashlight/Flashlight off.wav")
@export var sound_default: AudioStream = preload("res://entities/player/player_items/sound_sensor/ScatterNoise1.mp3")

var active_stream_player: PrioritizedAudioStreamPlayer
var is_on : bool = false : set = set_is_on

func _ready() -> void:
	is_on = false


func on_exit() -> void:
	stop_sensor_sound()
	set_is_on(false)

func _on_sound_detected(sound: AudioStream):
	play_sensor_sound(sound)

func _on_sound_undetected():
	play_sensor_sound(sound_default)

func use() -> void:
	is_on = !is_on
	if is_on:
		AudioManager.play_sound(sound_on)
		play_sensor_sound(sound_default)
	else:
		AudioManager.play_sound(sound_off)
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
		active_stream_player.finished.disconnect(active_stream_player.play)
		active_stream_player.stop()

func set_is_on(value:bool) -> void:
	is_on = value
