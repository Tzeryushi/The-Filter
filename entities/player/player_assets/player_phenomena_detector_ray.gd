extends RayCast3D


signal phenomena_detected(interacting_object)
signal phenomena_detections_ceased

var is_detecting: bool = false


func _physics_process(_delta: float) -> void:
	var collision_node = get_collider()
	if collision_node != null:
		phenomena_detected.emit(get_collider())
		is_detecting = true
	elif is_detecting and (collision_node == null):
		phenomena_detections_ceased.emit()
		is_detecting = false
