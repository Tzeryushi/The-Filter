extends PlayerState


@export var normal_state: PlayerState
@export var disconnected_state: PlayerState

@export var movement: PlayerMovement
@export var camera: PlayerCamera
@export var interaction_ray: RayCast3D
@export var item_manager: ItemManager


func on_enter() -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	camera.set_crouching(false)


func process_input(event:InputEvent) -> BaseState:
	if event.is_action_pressed("crouch"):
		camera.set_crouching(true)
	elif event.is_action_released("crouch"):
		camera.set_crouching(false)
	
	if event.is_action_pressed("use"):
		if Input.mouse_mode != Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
	if event.is_action_pressed("interact"):
		var object = interaction_ray.get_collider()
		if object is InteractionVolume:
			object.interact(body)
	
	item_manager.process_input(event)
	
	return null


func process_frame(_delta: float) -> BaseState:
	if !body.is_receiving_input:
		return disconnected_state
	elif !body.is_focused:
		return normal_state
	return null


func process_physics(delta: float) -> BaseState:
	movement.process_physics(delta)
	return null
