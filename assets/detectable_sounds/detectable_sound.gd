class_name DetectableSound
extends Area3D

@export var type: SoundType = SoundType.HEARTBEAT
@export var radius: float = 0.2
@export var collision_shape: CollisionShape3D
@export var creepy_sound: AudioStream
@export var crickets_sound: AudioStream
@export var ghosts_sound: AudioStream
@export var heartbeat_sound: AudioStream
@export var multiple_heartbeat_sound: AudioStream
@export var scream_sound: AudioStream

var active_sound: AudioStream

enum SoundType {CREEPY, CRICKETS, GHOSTS, HEARTBEAT, MULTIPLE_HEARTBEAT, SCREAM}


func _ready():
	set_sensor_sound(type)
	collision_shape.shape.radius = radius


func set_sensor_sound(new_type: SoundType):
	match new_type:
		SoundType.CREEPY:
			active_sound = creepy_sound
		SoundType.CRICKETS:
			active_sound = crickets_sound
		SoundType.GHOSTS:
			active_sound = ghosts_sound
		SoundType.HEARTBEAT:
			active_sound = heartbeat_sound
		SoundType.MULTIPLE_HEARTBEAT:
			active_sound = multiple_heartbeat_sound
		SoundType.SCREAM:
			active_sound = scream_sound
