class_name InteractionVolume
extends Area3D
## Area that can pass information through collisions
##
## Can pass text (or not), contains an abstract signal that can be linked
## to a parent node for functionality (like a door being opened, an item being
## picked up, or a NPC interacted with)


signal interacted(interacting_node)

@export var interaction_text: String = "Interact With" : get = get_interaction_text
@export var is_active: bool = true : set = set_active

const base_text: String = "[center]"


func _ready() -> void:
	for child in get_children():
		if child is CollisionShape3D:
			child.disabled = !is_active


func get_interaction_text() -> String:
	return base_text + interaction_text


## pseudo-virtual function given purpose by inheritors
func interact(node: Node = null) -> void:
	interacted.emit(node)
	pass


func set_active(value: bool) -> void:
	if value != is_active:
		for child in get_children():
			if child is CollisionShape3D:
				child.set_deferred("disabled", !value)
		is_active = value
