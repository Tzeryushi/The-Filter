extends Node


@export var client_manager : ClientManager
@export var dialogue: Dialogue
@export var player: Player

func _ready() -> void:
	pass


func _unhandled_input(event):
	if event.is_action_pressed("use"):
		player.point_to(client_manager.current_client.head_node.global_position)
	pass


func sort_results(results: Dictionary) -> void:
	pass
