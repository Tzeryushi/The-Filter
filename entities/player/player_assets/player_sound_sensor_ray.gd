extends RayCast3D


signal sound_detected(interacting_object, magnitude: float)
signal sound_detections_ceased

var is_detecting: bool = false


func _physics_process(_delta: float) -> void:
	var collision_node: CollisionObject3D = get_collider()
	if collision_node != null and collision_node is DetectableSound:
		var sound: DetectableSound = collision_node
		var angle = (sound.global_position - global_position).angle_to(get_collision_point() - global_position)
		var camera = get_viewport().get_camera_3d()
		var projected_transform = camera.global_transform
		var up_vector: Vector3 = Vector3.UP * projected_transform.basis
		up_vector *= sound.radius
		up_vector += sound.global_position
		var max_angle = (sound.global_position - global_position).angle_to(up_vector - global_position)
		sound_detected.emit(get_collider(), clamp(1-(angle / max_angle), 0, 1))
		is_detecting = true
	elif is_detecting and (collision_node == null or !collision_node is DetectableSound):
		sound_detections_ceased.emit()
		is_detecting = false
