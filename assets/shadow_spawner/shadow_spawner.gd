extends Node3D


@export var creeper_scene: PackedScene
@export var timer: Timer

var is_active: bool = false



func activate() -> void:
	is_active = true
	timer.start()


func deactivate() -> void:
	is_active = false
	timer.stop()


func spawn_shadow() -> void:
	var shadow = creeper_scene.instantiate()
	add_child(shadow)
	shadow.position = Vector3(randf_range(-3,3), randf_range(-1,3), randf_range(-2,2))


func _on_timer_timeout():
	if is_active:
		spawn_shadow()
	timer.wait_time = randf_range(6.0, 12.0)
	timer.start()


func _on_client_manager_client_launched(type_array: Array[ClientManager.Attribute]):
	if type_array.has(ClientManager.Attribute.SHADOWS):
		activate()


func _on_client_manager_client_terminated():
	if is_active:
		deactivate()
