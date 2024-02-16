extends BaseState

##Normal interaction state for player. Stands, walks, sprints, runs.


@export var disconnected_state : BaseState

@export var movement : PlayerMovement


func process_input(_event:InputEvent) -> BaseState:
	#execute when actor receives input
	#returns the state of the actor, which may have changed
	return null

func process_frame(_delta: float) -> BaseState:
	return null

func process_physics(delta: float) -> BaseState:
	movement.process_physics(delta)
	return null
