extends Node3D


signal dialogue_started(player_node: Player)


func _on_interaction_volume_interacted(interacting_node):
	if interacting_node is Player:
		dialogue_started.emit(interacting_node)
