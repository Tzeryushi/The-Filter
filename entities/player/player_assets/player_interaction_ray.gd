extends RayCast3D


signal detected(interacting_object)
signal detections_ceased

var is_detecting: bool = false


func _physics_process(_delta: float) -> void:
	var collision_node = get_collider()
	if collision_node != null and collision_node is InteractionVolume:
		detected.emit(get_collider())
		is_detecting = true
	elif is_detecting and (collision_node == null or !collision_node is InteractionVolume):
		detections_ceased.emit()
		is_detecting = false
