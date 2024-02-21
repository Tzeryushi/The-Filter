class_name Player
extends CharacterBody3D

signal look_at_point(location: Vector3)
signal clipboard_acquired

enum State {NORMAL = 0, DISCONNECTED = 1, FOCUSED = 2}

@export var state_manager: StateManager
@export var item_manager: ItemManager

var move_dir: Vector2
var walk_velocity: Vector3
var gravitational_velocity : Vector3

var is_receiving_input : bool = true : set = set_input_mode
var is_focused: bool = false : set = set_focus_mode


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


func set_focus_mode(value: bool) -> void:
	is_focused = value


func add_item(item_name: String) -> bool:
	return item_manager.pickup_item(item_name)


func point_to(location: Vector3) -> void:
	look_at_point.emit(location)


func _on_item_manager_clipboard_held(is_held):
	set_focus_mode(is_held)


func _on_item_manager_clipboard_acquired():
	clipboard_acquired.emit()
