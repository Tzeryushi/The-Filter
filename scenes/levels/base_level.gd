extends Node


signal monster_spawn_finished

@export var client_manager : ClientManager
@export var dialogue_manager: Dialogue
@export var player: Player
@export var nav_region: NavigationRegion3D
@export var computer: SubmissionComputer

@export var clients: Array[ClientResource]

@export var monster_scene: PackedScene
@export var monster_spawn_point1: Node3D
@export var game_space: Node3D

var monster_tracking: bool = false
var monster: Node3D

func _ready() -> void:
	await get_tree().process_frame
	#for client in clients:
		#client_manager.client_load(client)
		#await client_manager.client_terminated
		#await get_tree().create_timer(6.0).timeout


func _unhandled_input(_event):
	#if event.is_action_pressed("use"):
		#player.point_to(client_manager.current_client.head_node.global_position)
	pass


func _physics_process(_delta) -> void:
	if monster_tracking:
		get_tree().call_group("monster", "update_target_position", player.global_position)


func spawn_monster() -> void:
	var new_monster = monster_scene.instantiate()
	game_space.add_child(new_monster)
	new_monster.global_position = monster_spawn_point1.global_position
	new_monster.look_at(Vector3(player.global_position.x, 0, player.global_position.z))
	new_monster.spawn()
	monster = new_monster
	await get_tree().create_timer(10.0).timeout
	
	# turn out lights
	$SubViewportContainer/SubViewport/GameSpace/Lights/IntLights.hide()
	$SubViewportContainer/SubViewport/GameSpace/EnvironmentItems/Doors/BlastDoor.close_door()
	$"SubViewportContainer/SubViewport/GameSpace/DecorativeItems/lamp 2 copy/bulb".hide()
	$SubViewportContainer/SubViewport/GameSpace/EnvironmentItems/SirenLight.set_siren_light_enabled(true)
	
	await get_tree().create_timer(1.0).timeout
	monster_spawn_finished.emit()
	$SubViewportContainer/SubViewport/GameSpace/EventAreas/Monster_Run.is_active = true
	

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
	spawn_monster()


func _on_monster_run_player_entered(player):
	monster_tracking = true
	$SubViewportContainer/SubViewport/GameSpace/EnvironmentItems/Doors/BlastDoor.open_door()
	$SubViewportContainer/SubViewport/GameSpace/EnvironmentItems/BigButton.set_button_active(true)


func _on_big_button_pressed():
	if !monster:
		return
	if (monster.global_position - player.global_position).length() >= 3:
		await get_tree().process_frame
		monster.queue_free()
		await get_tree().create_timer(4.0).timeout
		var tween : Tween = create_tween()
		$GUI/EndGood.show()
		$GUI/EndGood.modulate.a = 0.0
		$GUI/EndGood/RichTextLabel.show()
		$GUI/EndGood/RichTextLabel.modulate.a = 0.0
		tween.tween_property($GUI/EndGood, "modulate:a", 1.0, 4.0)
		tween.tween_property($GUI/EndGood/RichTextLabel, "modulate:a", 1.0, 2.0)
		await get_tree().create_timer(4.0).timeout
		SceneManager.switch_scene("end_scene")
		
