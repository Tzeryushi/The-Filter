extends BaseState

@export var normal_state: BaseState


func process_frame(_delta: float) -> BaseState:
	if body.is_receiving_input:
		return normal_state
	return null
