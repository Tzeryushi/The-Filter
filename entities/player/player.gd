extends CharacterBody3D


@export var state_manager: StateManager

var move_dir: Vector2
var walk_velocity: Vector3
var gravitational_velocity : Vector3

var is_receiving_input : bool = true : set = set_input_mode


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


func set_input_mode(value: bool) -> void:
	is_receiving_input = value
