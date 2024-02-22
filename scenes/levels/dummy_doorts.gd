extends Node3D


func close_all_doors() -> void:
	for door in get_children():
		door.close_door()
