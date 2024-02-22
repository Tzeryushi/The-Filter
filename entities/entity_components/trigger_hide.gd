extends Node3D


func hide_trigger(is_hidden: bool) -> void:
	if is_hidden:
		hide()
	else:
		show()


func _on_player_entered(player):
	show()
