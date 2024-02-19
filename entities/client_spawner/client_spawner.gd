extends Node3D


# When spawning, we link our player resource to communication modules,
# update the GUI on the clipboard, and pass pertinent signals that can be listened
# to by environmental nodes, like the clock or the lights.

signal launch_client(type:Array[Attribute])
signal terminate_client

enum Attribute {}

@export var client_scene : PackedScene
@export var spawn_location : Node3D

var current_client : Client


func client_load(client_resource:ClientResource) -> void:
	var new_client = client_scene.instantiate()
	new_client = new_client as Client
	new_client.client_resource = client_resource
	if SceneManager.has_scenes():
		SceneManager.get_top_scene().add_child(new_client)
	else:
		get_parent().add_child(new_client)
	new_client.global_position = spawn_location.global_position
	current_client = new_client
