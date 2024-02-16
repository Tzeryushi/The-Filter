extends BaseState

##Normal interaction state for player. Stands, walks, sprints, runs.


@export var disconnected_state: BaseState

@export var movement: PlayerMovement
@export var camera: PlayerCamera


func process_input(event:InputEvent) -> BaseState:
	camera.process_input(event)
	return null

func process_frame(_delta: float) -> BaseState:
	if !body.is_receiving_input:
		return disconnected_state
	return null

func process_physics(delta: float) -> BaseState:
	movement.process_physics(delta)
	return null
