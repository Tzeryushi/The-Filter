extends Node

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

var sort_by_distance: Callable = func(a: PositionalAudioStreamPlayer, b: PositionalAudioStreamPlayer):
	var player_node = get_tree().get_first_node_in_group("player")
	return a.stream and b.stream and player_node.global_position.distance_to(a.global_position) < player_node.global_position.distance_to(b.global_position)

var sort_by_priority: Callable = func(a, b):
	return a.stream and b.stream and a.priority < b.priority


func _ready():

	# Build player audio players
	for n in SFX_CHANNELS:
		sfx_stream_players.push_back(build_audio_player("SFX", false))
	for n in MUSIC_CHANNELS:
		music_stream_players.push_back(build_audio_player("Music", false))
	for n in VOICE_CHANNELS:
		voice_stream_players.push_back(build_audio_player("Voice", false))

	# Build world audio players
	for n in WORLD_SFX_CHANNELS:
		world_sfx_stream_players.push_back(build_audio_player("SFX", true))
	for n in WORLD_MUSIC_CHANNELS:
		world_music_stream_players.push_back(build_audio_player("Music", true, PositionalAudioStreamPlayer.ATTENUATION_INVERSE_DISTANCE))
	for n in WORLD_VOICE_CHANNELS:
		world_voice_stream_players.push_back(build_audio_player("Voice", true))
	pass

## Play sound
# Params
# stream = AudioStream to play
# channel = Channel to play stream on
# priority = Integer defining priority for stream
# Returns id of audio stream player sound has played on, -1 if sound didn't play
func play_sound(
	stream: AudioStream,
	channel: Channel = Channel.SFX,
	priority: int = PRIORITY_DEFAULT) -> int:

	var stream_player: PrioritizedAudioStreamPlayer = get_free_stream_player(channel, false, priority)
	if stream_player:
		stream_player.stream = stream
		stream_player.priority = priority
		stream_player.play()
		return stream_player.get_instance_id()
	return -1


## Play sound at Vector3 location
# Params
# stream = AudioStream
# position = Vector3 to set as a audio stream player's global position
# channel = Channel to play stream on
# priority = Integer defining priority for stream
# Returns id of audio stream player sound has played on, -1 if sound didn't play
func play_sound_at_location(
	stream: AudioStream,
	position: Vector3,
	channel: Channel = Channel.SFX,
	priority: int = PRIORITY_DEFAULT) -> int:

	print("Playing sounds at " + str(position))
	print("Player location is " + str(get_tree().get_first_node_in_group("player").global_position))
	var stream_player: PositionalAudioStreamPlayer = get_free_stream_player(channel, true, priority)
	if stream_player:
		stream_player.global_position = position
		stream_player.stream = stream
		stream_player.priority = priority
		stream_player.play()
		return stream_player.get_instance_id()
	return -1


## Play sound at Vector3 location
# Params
# stream = AudioStream
# node = Node3D for PositionAudioStreamPlayer to follow
# channel = Channel to play stream on
# priority = Integer defining priority for stream
# Returns id of audio stream player sound has played on, -1 if sound didn't play
func play_sound_at_node(
	stream: AudioStream,
	followed_node: Node3D,
	channel: Channel = Channel.SFX,
	priority: int = PRIORITY_DEFAULT) -> int:

	var stream_player: PositionalAudioStreamPlayer = get_free_stream_player(channel, true, priority)
	if stream_player:
		stream_player.followed_node = followed_node
		stream_player.stream = stream
		stream_player.priority = priority
		stream_player.play()
		return stream_player.get_instance_id()
	return -1


## Get available player for given channel
# Params
# channel = Channel to get a stream player for
# positional = Whether that player needs to be a 3d stream player
# priority = Integer defining priority for stream
# Returns stream_player object of free stream, null if none found
func get_free_stream_player(
	channel: Channel, 
	positional: bool, 
	priority: int = PRIORITY_DEFAULT):

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

	# Sort stream players
	stream_players.sort_custom(sort_by_length)
	if positional:
		stream_players.sort_custom(sort_by_distance)
	stream_players.sort_custom(sort_by_priority)

	for stream_player in stream_players:
		if stream_player.priority <= priority:
			return stream_player
	print_debug("Audio Manager: No player found, not playing audio stream")
	return null


## Builds audio player for playing sound files
# Params
# channel = Channel that player will play sounds on
# positional = Whether the player will be a 3d audio player or not
# attenuation = Attenuation algorithm for determining sound fading over distance
func build_audio_player(
		channel: String,
		positional: bool,
		attenuation: PositionalAudioStreamPlayer.AttenuationModel = PositionalAudioStreamPlayer.ATTENUATION_LOGARITHMIC):

	var audio_player

	if positional:
		audio_player = PositionalAudioStreamPlayer.new()
		add_child.call_deferred(audio_player)
		audio_player.attenuation_model = attenuation
	else:
		audio_player = PrioritizedAudioStreamPlayer.new()
		add_child.call_deferred(audio_player)

	audio_player.set_bus(channel)

	return audio_player
