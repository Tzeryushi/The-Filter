class_name PlayerState
extends BaseState

@export var state_type : Player.State
static var last_state : Player.State = Player.State.DISCONNECTED

func on_exit() -> void:
	super()
	last_state = state_type
