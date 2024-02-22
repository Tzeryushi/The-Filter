extends Node


@export var client_manager : ClientManager
@export var dialogue_manager: Dialogue
@export var player: Player
@export var nav_region: NavigationRegion3D
@export var computer: SubmissionComputer

@export var clients: Array[ClientResource]

func _ready() -> void:
	await get_tree().process_frame
	#for client in clients:
		#client_manager.client_load(client)
		#await client_manager.client_terminated
		#await get_tree().create_timer(6.0).timeout


func _unhandled_input(event):
	#if event.is_action_pressed("use"):
		#player.point_to(client_manager.current_client.head_node.global_position)
	pass


func _physics_process(delta) -> void:
	#get_tree().call_group("client", "update_target_position", player.global_position)
	pass


func sort_results(results: Dictionary) -> void:
	pass


#func _on_speaker_dialogue_started(inc_dialogue:JSON, dialogue_dict: Dictionary, speaker: Speaker) ->  void:
	#player.point_to(speaker.global_position)
	#dialogue_manager.begin_dialogue(inc_dialogue, dialogue_dict)
	#await dialogue_manager.dialogue_ended
	#speaker.end_dialogue()

func _on_speaker_dialogue_started(inc_dialogue, dialogue_dict, speaker):
	player.point_to(speaker.global_position)
	dialogue_manager.begin_dialogue(inc_dialogue, dialogue_dict)
	await dialogue_manager.dialogue_ended
	speaker.end_dialogue()


func _on_submission_computer_next_client_sent():
	if client_manager.has_client:
		return
	if !clients.is_empty():
		computer.can_send_in = false
		client_manager.client_load(clients.pop_front())
		await client_manager.client_terminated
		return
	print_debug("end of client list.")
