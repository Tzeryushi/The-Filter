extends PlayerItem


@export var spotlight : SpotLight3D
var flashlight_on_sound: AudioStream = preload("res://entities/player/player_items/flashlight/Flashlight on.wav")
var flashlight_off_sound: AudioStream = preload("res://entities/player/player_items/flashlight/Flashlight off.wav")

var is_on : bool = false : set = set_is_on

func _ready() -> void:
	is_on = false


func on_exit() -> void:
	set_is_on(false)


func use() -> void:
	is_on = !is_on


func set_is_on(value:bool) -> void:
	is_on = value
	spotlight.visible = is_on
	if is_on:
		AudioManager.play_sound(flashlight_on_sound)
	else:
		AudioManager.play_sound(flashlight_off_sound)
