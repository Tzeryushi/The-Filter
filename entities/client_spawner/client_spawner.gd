extends Node3D


# When spawning, we link our player resource to communication modules,
# update the GUI on the clipboard, and pass pertinent signals that can be listened
# to by environmental nodes, like the clock or the lights.

signal launch_client(type:Array[Attribute])
signal terminate_client

enum Attribute {}

@export var client_scene : PackedScene


func client_load(client_resource:ClientResource) -> void:
	var new_client = client_scene.instantiate()
	new_client = new_client as Client
	
