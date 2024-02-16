extends CharacterBody3D


@export var state_manager: StateManager

var move_dir: Vector2
var walk_velocity: Vector3
var gravitational_velocity : Vector3


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	state_manager.init_state(self)


func _unhandled_input(event:InputEvent) -> void:
	state_manager.process_input(event)
	if event.is_action_pressed("esc"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _process(delta: float) -> void:
	state_manager.process_frame(delta)


func _physics_process(delta: float) -> void:
	state_manager.process_physics(delta)

#func _physics_process(delta: float):
	#velocity = _walk(delta) + _gravity(delta)
	#move_and_slide()
#
#
#func _walk(delta: float) -> Vector3:
	#move_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	#var forward: Vector3 = camera.global_transform.basis * Vector3(move_dir.x, 0, move_dir.y)
	#var walk_direction: Vector3 = Vector3(forward.x, 0, forward.z).normalized()
	#walk_velocity = walk_velocity.move_toward(walk_direction * speed * move_dir.length(), acceleration * delta)
	#return walk_velocity
#
#
#func _gravity(delta: float) -> Vector3:
	#gravitational_velocity = Vector3.ZERO if is_on_floor() else gravitational_velocity.move_toward(
			#Vector3(0, velocity.y - gravity, 0), gravity * delta)
	#return gravitational_velocity
