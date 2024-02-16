extends RayCast3D


signal interacted(interacting_object)
signal interactions_ceased()

var is_interacting: bool = false


func _physics_process(_delta: float) -> void:
	if get_collider() != null:
		interacted.emit(get_collider())
		is_interacting = true
	elif is_interacting and get_collider() == null:
		interactions_ceased.emit()
		is_interacting = false
