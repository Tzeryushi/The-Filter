extends Node

var root: Node
var audio_stream_players: Node
var world_audio_stream_players: Node

var sfx_stream_players: Array = []
var voice_stream_players: Array = []
var music_stream_players: Array = []

var world_sfx_stream_players: Array = []
var world_voice_stream_players: Array = []
var world_music_stream_players: Array = []

enum Channel {SFX, Music, Voice}

const SFX_CHANNELS = 4;
const MUSIC_CHANNELS = 2;
const VOICE_CHANNELS = 2;
const WORLD_SFX_CHANNELS = 4;
const WORLD_MUSIC_CHANNELS = 4;
const WORLD_VOICE_CHANNELS = 4;
const PRIORITY_DEFAULT = 3;

var sort_by_length: Callable = func(a,b):
		return a.stream and b.stream and a.stream.get_length() - a.get_playback_position() < b.stream.get_length() - b.get_playback_position()

var sort_by_distance: Callable = func(a: AudioStreamPlayer3D,b: AudioStreamPlayer3D):
		#return PlayerController.player_node.global_position.distance_to(a.global_position) < PlayerController.player_node.global_position.distance_to(b.global_position)
		return

var sort_by_priority: Callable = func(a, b):
		return a.stream.priority < b.stream.priority


func _ready():
	root = get_tree().root

	# Build player audio players
	for n in SFX_CHANNELS:
		sfx_stream_players.push_back(build_audio_player("SFX", false))
	for n in MUSIC_CHANNELS:
		sfx_stream_players.push_back(build_audio_player("Music", false))
	for n in VOICE_CHANNELS:
		sfx_stream_players.push_back(build_audio_player("Voice", false))

	# Build world audio players
	for n in WORLD_SFX_CHANNELS:
		world_sfx_stream_players.push_back(build_audio_player("SFX", true))
	for n in WORLD_MUSIC_CHANNELS:
		world_sfx_stream_players.push_back(build_audio_player("Music", true, AudioStreamPlayer3D.ATTENUATION_INVERSE_DISTANCE))
	for n in WORLD_VOICE_CHANNELS:
		world_sfx_stream_players.push_back(build_audio_player("Voice", true))
	pass


## Get available player for given channel
func get_free_stream_player(channel: Channel, positional: bool = false, priority: int = PRIORITY_DEFAULT):
	var stream_players: Array
	if positional:
		match channel:
			Channel.SFX:
				stream_players = world_sfx_stream_players
			Channel.Music:
				stream_players = world_music_stream_players
			Channel.Voice:
				stream_players = world_voice_stream_players
	else:
		match channel:
			Channel.SFX:
				stream_players = sfx_stream_players
			Channel.Music:
				stream_players = music_stream_players
			Channel.Voice:
				stream_players = voice_stream_players

	for stream_player in stream_players:
		if !stream_player.is_playing() and !stream_player.stream_paused:
			return stream_player

	stream_players.sort_custom(sort_by_length)
	stream_players.sort_custom(sort_by_priority)

	for stream_player in stream_players:
		if stream_player.priority <= priority:
			return stream_player
	pass


## Builds audio player for playing sound files
# Params
# channel = Channel that player will play sounds on
# positional = Whether the player will be a 3d audio player or not
# attenuation = Attenuation algorithm for determining sound fading over distance
# 
func build_audio_player(
		channel: String,
		positional: bool,
		attenuation: AudioStreamPlayer3D.AttenuationModel = AudioStreamPlayer3D.ATTENUATION_LOGARITHMIC):

	var audio_player

	if positional:
		audio_player = AudioStreamPlayer3D.new()
		root.add_child.call_deferred(audio_player)
		audio_player.attenuation_model = attenuation
	else:
		audio_player = AudioStreamPlayer.new()
		root.add_child.call_deferred(audio_player)

	audio_player.set_bus(channel)

	return audio_player
