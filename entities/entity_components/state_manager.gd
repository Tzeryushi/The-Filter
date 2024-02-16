class_name StateManager
extends Node

@export var first_state: BaseState
#@export var animation : AnimatedSprite2D

var current_state: BaseState

func swap_state(new_state: BaseState) -> void:
	if current_state:
		if current_state == new_state:
			assert(current_state == new_state, "StateManager: Actor state swapped to itself!")
		current_state.on_exit()
	current_state = new_state
	#animation.play(new_state.animation_type)
	current_state.on_enter()


func init_state(body:CharacterBody3D) -> void:
	for state in get_children():
		if state is BaseState:
			state.body = body
	
	swap_state(first_state)


func process_input(event:InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		swap_state(new_state)


func process_frame(delta:float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		swap_state(new_state)


func process_physics(delta:float) -> void:
	var new_state = current_state.process_physics(delta)
	if new_state:
		swap_state(new_state)
