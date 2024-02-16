extends Node3D
## Sends an item reference to a player script that interacts with it


@export var item_name: String = "base_item"

func _on_interaction_volume_interacted(interacting_node):
	if interacting_node is Player:
		interacting_node.add_item(item_name)
