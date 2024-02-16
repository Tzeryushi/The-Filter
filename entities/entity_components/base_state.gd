class_name BaseState
extends Node

@export var animation_type : String = ""

var body: CharacterBody3D
var is_active: bool = false

func on_enter() -> void:
	is_active = true
	pass

func on_exit() -> void:
	is_active = false
	pass

func process_input(_event:InputEvent) -> BaseState:
	#execute when actor receives input
	#returns the state of the actor, which may have changed
	return null

func process_frame(_delta:float) -> BaseState:
	#execute to define process loop functionality in state
	#returns the state of the actor, which may have changed
	return null

func process_physics(_delta:float) -> BaseState:
	#execute to define physics process loop functionality in state
	#returns the state of the actor, which may have changed
	return null
