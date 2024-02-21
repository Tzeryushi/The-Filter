extends Node3D

@export var time: float = 0.0
@export var time_rate: float = 1.0
@export var clock_sound: AudioStream

var hour_hand: MeshInstance3D
var minute_hand: MeshInstance3D
var timer := Timer.new()

var clock_sound_player: PositionalAudioStreamPlayer
var first_tick: bool = true

const TIME_PERIOD: int = 1  

func _ready():
	hour_hand = get_node("Hour")
	minute_hand = get_node("Minute")
	add_child(timer)
	timer.wait_time = time_rate
	timer.start()
	timer.timeout.connect(func(): add_time(0.0166666))
	update_hand_rotation()


func update_hand_rotation():
	minute_hand.rotation = Vector3(0,(fmod(time, 1.0) * 2 * PI * -1),0)
	hour_hand.rotation = Vector3(0,((time / 12.0) * 2 * PI * -1),0)


func add_time(time_to_add: float):
	if first_tick:
		first_tick = false
		if clock_sound:
			var clock_sound_player_id: int = AudioManager.play_sound_at_location(
				clock_sound,
				global_position,
				AudioManager.Channel.SFX,
				7)
			clock_sound_player = instance_from_id(clock_sound_player_id)
			clock_sound_player.finished.connect(clock_sound_player.play)
	time += time_to_add
	while(time > 12):
		time -= 12
	update_hand_rotation()


func set_time(new_time: float):
	time = new_time
	while(time > 12):
		time -= 12
	update_hand_rotation()
