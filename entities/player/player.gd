class_name Player
extends CharacterBody3D


enum State {NORMAL = 0, DISCONNECTED = 1, FOCUSED = 2}

@export var state_manager: StateManager
@export var item_manager: ItemManager

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


func add_item(item_name: String) -> bool:
	if !item_manager.is_inventory_full:
		item_manager.pickup_item(item_name)
		return true
	return false
