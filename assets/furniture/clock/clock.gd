extends Node3D

@export var time: float = 0.0
@export var time_rate: float = 1.0
@export var clock_sound: AudioStream

@export var hour_hand: MeshInstance3D
@export var minute_hand: MeshInstance3D

var timer := Timer.new()
var temporal_shift_timer := Timer.new()

var clock_sound_player: PositionalAudioStreamPlayer
var first_tick: bool = true

const TIME_PERIOD: int = 1
const MAX_DILATION: float = 2.0
const MIN_DILATION: float = 2.0
const MAX_DILATION_TIME: float = 15.0
const MIN_DILATION_TIME: float = 5.0

func _ready():
	add_child(timer)
	timer.start()
	timer.timeout.connect(func(): add_time(0.0166666))
	temporal_shift_timer.timeout.connect(_on_temporal_shift_timer_timeout)
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


func _on_client_manager_client_launched(attribute_array: Array[ClientManager.Attribute]):
	for attribute in attribute_array:
		if attribute == ClientManager.Attribute.TIME_DILATION:
			time_rate = randf_range(MIN_DILATION, MAX_DILATION)
			timer.set_wait_time(time_rate)
			temporal_shift_timer.wait_time = randf_range(MIN_DILATION_TIME, MAX_DILATION_TIME)
			temporal_shift_timer.start()


func _on_client_manager_client_terminated():
	time_rate = 1
	timer.set_wait_time(time_rate)
	temporal_shift_timer.paused = true


func _on_temporal_shift_timer_timeout():
	time_rate = randf_range(MIN_DILATION, MAX_DILATION)
	timer.set_wait_time(time_rate)
	temporal_shift_timer.wait_time = randf_range(MIN_DILATION_TIME, MAX_DILATION_TIME)
