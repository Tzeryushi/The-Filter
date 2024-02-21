extends Node3D


@export var sound_scene: PackedScene
@export var valid_sounds: Array[DetectableSound.SoundType]

var sound_refs: Array[Node3D]


func spawn_sounds() -> void:
	var sound_type: DetectableSound.SoundType = valid_sounds.pick_random()
	for i in range(0, 6):
		var sound = sound_scene.instantiate()
		add_child(sound)
		sound_refs.append(sound)
		sound.set_sensor_sound(sound_type)
		sound.position = Vector3(randf_range(-3,3), randf_range(0,4), randf_range(-2,2))


func remove_sounds() -> void:
	for sound in sound_refs:
		queue_free()


func _on_client_manager_client_launched(type_array: Array[ClientManager.Attribute]):
	if type_array.has(ClientManager.Attribute.STRANGE_SOUNDS):
		spawn_sounds()


func _on_client_manager_client_terminated():
	remove_sounds
