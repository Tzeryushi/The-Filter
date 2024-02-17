extends PlayerState

##Normal interaction state for player. Stands, walks, sprints, runs.


@export var disconnected_state: BaseState

@export var movement: PlayerMovement
@export var camera: PlayerCamera
@export var interaction_ray: RayCast3D
@export var item_manager: ItemManager


func process_input(event:InputEvent) -> BaseState:
	camera.process_input(event)
	if event.is_action_pressed("crouch"):
		camera.set_crouching(true)
	elif event.is_action_released("crouch"):
		camera.set_crouching(false)
	
	if event.is_action_pressed("use"):
		if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
	if event.is_action_pressed("interact"):
		var object = interaction_ray.get_collider()
		if object is InteractionVolume:
			object.interact(body)
	
	item_manager.process_input(event)
	
	return null

func process_frame(_delta: float) -> BaseState:
	if !body.is_receiving_input:
		return disconnected_state
	return null

func process_physics(delta: float) -> BaseState:
	movement.process_physics(delta)
	return null
