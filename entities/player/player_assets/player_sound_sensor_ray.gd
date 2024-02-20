extends RayCast3D


signal sound_detected(interacting_object, magnitude: float)
signal sound_detections_ceased

var is_detecting: bool = false


func _physics_process(_delta: float) -> void:
	var collision_node: CollisionObject3D = get_collider()
	if collision_node != null and collision_node is DetectableSound:
		var distance = (global_position.angle_to(collision_node.global_position) - global_position.angle_to(get_collision_point())) * 500
		distance *= distance
		distance *= distance
		sound_detected.emit(get_collider(), clamp(distance, 0, 6))
		is_detecting = true
	elif is_detecting and (collision_node == null or !collision_node is DetectableSound):
		sound_detections_ceased.emit()
		is_detecting = false
