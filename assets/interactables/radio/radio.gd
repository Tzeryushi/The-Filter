extends Node3D

@export var is_enabled: bool = false
@export var on_sound: AudioStream
@export var off_sound: AudioStream
@export var radio_song: AudioStream = preload("res://assets/interactables/radio/freejazz_medley.ogg")

var radio_stream_player: PositionalAudioStreamPlayer

func _on_interaction_volume_interacted(_interacting_node):
	is_enabled = !is_enabled
	if is_enabled:
		AudioManager.play_sound_at_location(on_sound, global_position)
	else:
		AudioManager.play_sound_at_location(off_sound, global_position)
	update_radio()

func update_radio():
	if is_enabled:
		if !radio_stream_player:
			var stream_player_id = AudioManager.play_sound_at_location(
				radio_song, global_position, AudioManager.Channel.Music, 7)
			radio_stream_player = instance_from_id(stream_player_id)
		else:
			radio_stream_player.stream = radio_song
			radio_stream_player.play()
		if !radio_stream_player.is_connected("finished", radio_stream_player.play):
			radio_stream_player.finished.connect(radio_stream_player.play)
	else:
		if radio_stream_player:
			if radio_stream_player.is_connected("finished", radio_stream_player.play):
				radio_stream_player.finished.disconnect(radio_stream_player.play)
			radio_stream_player.stop()
		radio_stream_player = null

		
