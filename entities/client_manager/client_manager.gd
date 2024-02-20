class_name ClientManager
extends Node3D


# When spawning, we link our player resource to communication modules,
# update the GUI on the clipboard, and pass pertinent signals that can be listened
# to by environmental nodes, like the clock or the lights.

signal client_launched(type:Array[Attribute])
signal client_terminated

enum Attribute {TIME_DILATION = 0, SECOND_PRESENCE = 1, INEXPLICABLE = 2, AURA = 3, STRANGE_SOUNDS = 4, SHADOWS=5}

@export var test_client: ClientResource
@export var client_scene: PackedScene
@export var spawn_location: Node3D
@export var stand_location: Node3D
@export var reject_location: Node3D
@export var no_light_location: Node3D


var current_client : Client
var hates_light: bool = false
var attribute_array : Array[Attribute] = []


var env_symptoms: Dictionary = {
	"strange_growths": make_growths,	## Can be benign.
	"averse_to_light": avoid_light,	## Usually nothing. Can be a shadowhiker.
	"time_dilation": time_dilation,	## Clock speed is affected at random intervals.
	"too_many_heartbeats": too_many_heartbeats,	## Sometimes a pulse jockey. Sometimes people are just weird.
	"second_presence": second_presence,	## Feels like someone else is around.
	"inexplicable_phenomena": inexplicable_phenomena,	## Something's wrong.
	"manifesting_aura": manifesting_aura,	## A forboding aura emanates. A lingering spirit?
	"strange_sounds": strange_sounds,
	"crickets?": crickets,
	"increased_shadows": increased_shadows,
}


func _ready() -> void:
	await get_tree().process_frame
	client_load(test_client)


func _unhandled_input(event):
	if event.is_action_pressed("crouch"):
		Broadcaster.check_clipboard.emit(current_client.client_resource)


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
			
	client_launched.emit(attribute_array)
	
	#TODO: Set movement to position in navmesh


func make_growths(client: Client) -> void:
	client.make_growths()


func avoid_light(_client: Client) -> void:
	#TODO: Negative flashlight interaction in client
	hates_light = true


func time_dilation(_client: Client) -> void:
	attribute_array.append(Attribute.TIME_DILATION)


func too_many_heartbeats(_client: Client) -> void:
	pass
	

func inexplicable_phenomena(_client: Client) -> void:
	attribute_array.append(Attribute.INEXPLICABLE)


func second_presence(_client: Client) -> void:
	attribute_array.append(Attribute.SECOND_PRESENCE)
	
	
func manifesting_aura(_client: Client) -> void:
	attribute_array.append(Attribute.AURA)
	

func crickets(_client: Client) -> void:
	pass


func strange_sounds(_client: Client) -> void:
	attribute_array.append(Attribute.STRANGE_SOUNDS)
	

func increased_shadows(_client: Client) -> void:
	attribute_array.append(Attribute.SHADOWS)
