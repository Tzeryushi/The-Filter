extends PlayerState

@export var normal_state: PlayerState
@export var focused_state: PlayerState


func on_enter() -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func process_frame(_delta: float) -> BaseState:
	if body.is_receiving_input:
		if body.is_focused:
			return focused_state
		return normal_state
	return null
