extends PlayerState

##Normal interaction state for player. Stands, walks, sprints, runs.


@export var disconnected_state: PlayerState
@export var focused_state: PlayerState

@export var movement: PlayerMovement
@export var camera: PlayerCamera
@export var interaction_ray: RayCast3D
@export var item_manager: ItemManager


func _notification(what):
	if what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func on_enter() -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func process_input(event:InputEvent) -> BaseState:
	camera.process_input(event)
	if event.is_action_pressed("crouch"):
		camera.set_crouching(true)
	elif event.is_action_released("crouch"):
		camera.set_crouching(false)
	
	if event.is_action_pressed("use"):
		if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			item_manager.use_item()
	elif event.is_action_released("use"):
		item_manager.unuse_item()
	if event.is_action_pressed("drop"):
		item_manager.drop_item()
	
	if event.is_action_pressed("interact"):
		var object = interaction_ray.get_collider()
		if object is InteractionVolume:
			object.interact(body)
	
	item_manager.process_input(event)
	
	return null

func process_frame(_delta: float) -> BaseState:
	if !body.is_receiving_input:
		return disconnected_state
	elif body.is_focused:
		return focused_state
	return null

func process_physics(delta: float) -> BaseState:
	movement.process_physics(delta)
	return null
