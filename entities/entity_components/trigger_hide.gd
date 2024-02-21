extends Node3D


func hide_trigger(is_hidden: bool) -> void:
	hide()


func _on_player_entered(player):
	show()
