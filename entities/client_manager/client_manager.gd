class_name ClientManager
extends Node3D


# When spawning, we link our player resource to communication modules,
# update the GUI on the clipboard, and pass pertinent signals that can be listened
# to by environmental nodes, like the clock or the lights.

signal client_launched(type_array:Array[Attribute])
signal client_terminated
signal client_primed

enum Attribute {TIME_DILATION = 0, SECOND_PRESENCE = 1, INEXPLICABLE = 2, AURA = 3, STRANGE_SOUNDS = 4, SHADOWS=5}

@export var dialogue_manager: Dialogue
@export var player: Player

@export var test_client: ClientResource
@export var client_scene: PackedScene
@export var spawn_location: Node3D
@export var stand_location: Node3D
@export var reject_location: Node3D
@export var no_light_location: Node3D
@export var look_point: Node3D
@export var window_point: Node3D
@export var approved_point: Node3D
@export var denied_point: Node3D

var current_client : Client = null
var has_client: bool : get = get_has_client
var hates_light: bool = false
var attribute_array : Array[Attribute] = []

@onready var patience_timer: Timer = %PatienceTimer


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
	#await get_tree().create_timer(1.0)
	#client_load(test_client)


func client_load(client_resource:ClientResource) -> void:
	var new_client = client_scene.instantiate()
	new_client = new_client as Client
	client_resource = client_resource.duplicate()
	new_client.client_resource = client_resource
	if SceneManager.has_scenes():
		SceneManager.get_top_scene().add_child(new_client)
	else:
		get_parent().add_child(new_client)
	new_client.global_position = spawn_location.global_position
	if client_resource.texture:
		new_client.set_texture(client_resource.texture)
	new_client = new_client as Client
	current_client = new_client
	
	for symptom in client_resource.env_symptoms:
		if env_symptoms[symptom] is Callable and client_resource.env_symptoms[symptom]:
			env_symptoms[symptom].call(current_client)
			
	client_launched.emit(attribute_array)
	Broadcaster.client_manager_new_resource_used.emit(client_resource)
	
	if client_resource.env_symptoms["too_many_heartbeats"]:
		new_client.make_sound(DetectableSound.SoundType.MULTIPLE_HEARTBEAT)
	else:
		new_client.make_sound(DetectableSound.SoundType.HEARTBEAT)
	
	await get_tree().process_frame
	var walk_position: Vector3
	if hates_light:
		walk_position = no_light_location.global_position
	else:
		walk_position = stand_location.global_position
	new_client.update_target_position(walk_position)
	await new_client.navigation_ended
	new_client.look_at(look_point.global_position)
	
	patience_timer.wait_time = randf_range(60,100)
	patience_timer.start()
	
	client_primed.emit()


## Makes an impatience event occur. May spawn a hostile entity.
func patience_up() -> void:
	pass


func make_growths(client: Client) -> void:
	client.make_growths()


func avoid_light(_client: Client) -> void:
	#TODO: Negative flashlight interaction in client
	hates_light = true


func time_dilation(_client: Client) -> void:
	attribute_array.append(Attribute.TIME_DILATION)


func too_many_heartbeats(_client: Client) -> void:
	# Handled by the client.
	pass
	

func inexplicable_phenomena(_client: Client) -> void:
	attribute_array.append(Attribute.INEXPLICABLE)


func second_presence(_client: Client) -> void:
	attribute_array.append(Attribute.SECOND_PRESENCE)
	
	
func manifesting_aura(_client: Client) -> void:
	current_client.make_aura()
	attribute_array.append(Attribute.AURA)
	

func crickets(_client: Client) -> void:
	current_client.make_sound(DetectableSound.SoundType.CRICKETS)


func strange_sounds(_client: Client) -> void:
	attribute_array.append(Attribute.STRANGE_SOUNDS)
	

func increased_shadows(_client: Client) -> void:
	attribute_array.append(Attribute.SHADOWS)


func start_dialogue(player_ref: Player) -> void:
	if !current_client:
		return
	player_ref.point_to(current_client.neck_node.global_position)
	dialogue_manager.begin_dialogue(current_client.client_resource.dialogue, current_client.client_resource.dialogue_state)


func get_has_client() -> bool:
	if current_client:
		return true
	else:
		return false


func _on_form_submitted() -> void:
	Broadcaster.check_clipboard.emit(current_client.client_resource)


func _on_dialogue_interactable_dialogue_started(player_node):
	start_dialogue(player_node)


func _on_submission_computer_decision_made(results):
	if !current_client:
		return
	
	var end_position: Vector3
	if results["admitted"]:
		end_position = approved_point.global_position
		current_client.client_resource.dialogue_state["approved"] = true
	else:
		end_position = denied_point.global_position
		current_client.client_resource.dialogue_state["denied"] = true
	
	if current_client.client_resource.has_ending_dialogue:
		current_client.update_target_position(window_point.global_position)
		await current_client.navigation_ended
		current_client.look_at(look_point.global_position)
		start_dialogue(player)
		await dialogue_manager.dialogue_ended
	
	current_client.update_target_position(end_position)
	await current_client.navigation_ended
	current_client.queue_free()
	current_client = null
	hates_light = false
	client_terminated.emit()
	

func _on_patience_timer_timeout():
	patience_up()
