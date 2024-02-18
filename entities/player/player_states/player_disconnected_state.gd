extends PlayerState

@export var normal_state: PlayerState
@export var focused_state: PlayerState


func process_frame(_delta: float) -> BaseState:
	if body.is_receiving_input:
		return normal_state
	return null
