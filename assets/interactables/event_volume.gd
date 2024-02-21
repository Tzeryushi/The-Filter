class_name EventVolume
extends Area3D
## Area that can pass information through collisions
##
## Can pass text (or not), contains an abstract signal that can be linked
## to a parent node for functionality (like a door being opened, an item being
## picked up, or a NPC interacted with)


signal player_entered(player: Player)
signal player_exited(player: Player)

@export var is_active: bool = true : set = set_active


func _ready() -> void:
	for child in get_children():
		if child is CollisionShape3D:
			child.disabled = !is_active


func set_active(value: bool) -> void:
	if value != is_active:
		for child in get_children():
			if child is CollisionShape3D:
				child.disabled = !value
		is_active = value


func _on_body_entered(body):
	if body is Player:
		player_entered.emit(body)


func _on_body_exited(body):
	if body is Player:
		player_exited.emit(body)
