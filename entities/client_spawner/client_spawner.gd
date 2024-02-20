extends Node3D


# When spawning, we link our player resource to communication modules,
# update the GUI on the clipboard, and pass pertinent signals that can be listened
# to by environmental nodes, like the clock or the lights.

signal launch_client(type:Array[Attribute])
signal terminate_client

enum Attribute {}

@export var test_client: ClientResource
@export var client_scene: PackedScene
@export var spawn_location: Node3D
@export var stand_location: Node3D
@export var reject_location: Node3D
@export var no_light_location: Node3D

var current_client : Client
var hates_light: bool = false

var env_symptoms: Dictionary = {
	"strange_growths": make_growths,	## Can be benign.
	"averse_to_light": avoid_light,	## Usually nothing. Can be a shadowhiker.
	"time_dilation": false,	## Clock speed is affected at random intervals.
	"too_many_heartbeats": false,	## Sometimes a pulse jockey. Sometimes people are just weird.
	"second_presence": false,	## Feels like someone else is around.
	"ineplicable_phenomena": false,	## Something's wrong.
	"manifesting_aura": false,	## A forboding aura emanates. A lingering spirit?
	"strange_sounds": false,
	"crickets?": false,
}


func _ready() -> void:
	await get_tree().process_frame
	client_load(test_client)


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
	
	for symptom in client_resource.env_symptoms:
		if env_symptoms[symptom] is Callable:
			env_symptoms[symptom].call(current_client)


func make_growths(client: Client) -> void:
	client.make_growths()


func avoid_light(_client: Client) -> void:
	hates_light = true
