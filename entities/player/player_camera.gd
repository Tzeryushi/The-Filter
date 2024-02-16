extends Camera3D

var camera_sens: float = 1

var look_dir: Vector2 # Input direction for look/aim


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_dir = event.relative * 0.001
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			_rotate_camera()

func _rotate_camera(sens_mod: float = 1.0) -> void:
	rotation.y -= look_dir.x * camera_sens * sens_mod
	rotation.x = clamp(rotation.x - look_dir.y * camera_sens * sens_mod, -1.5, 1.5)
