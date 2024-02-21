extends Node


@export var client_manager : ClientManager
@export var dialogue: Dialogue
@export var player: Player
@export var nav_region: NavigationRegion3D

@export var clients: Array[ClientResource]

func _ready() -> void:
	await get_tree().process_frame
	for client in clients:
		client_manager.client_load(client)
		await client_manager.client_terminated


func _unhandled_input(event):
	#if event.is_action_pressed("use"):
		#player.point_to(client_manager.current_client.head_node.global_position)
	pass


func _physics_process(delta) -> void:
	#get_tree().call_group("client", "update_target_position", player.global_position)
	pass


func sort_results(results: Dictionary) -> void:
	pass
