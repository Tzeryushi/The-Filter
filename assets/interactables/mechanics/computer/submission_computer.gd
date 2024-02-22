class_name SubmissionComputer
extends Node3D


signal form_submitted
signal next_client_sent
signal decision_made(results: Dictionary)

@export var content_viewport: SubViewport
@export var screen_material: ShaderMaterial

@export var approved_sound: AudioStream
@export var denied_sound: AudioStream

@export var submit_screen: Control
@export var approve_screen: Control
@export var deny_screen: Control
@export var results_screen: Control
@export var send_in_screen: Control
@export var results_text: RichTextLabel

var results_tween : Tween

var can_submit: bool = false : set = set_can_submit
var can_send_in: bool = false : set = set_send_in
var is_submitting: bool = false

@onready var interaction_volume : InteractionVolume = $InteractionVolume

func _ready() -> void:
	Broadcaster.clipboard_form_submitted.connect(_on_form_submitted)
	var screen_texture: ViewportTexture = content_viewport.get_texture()
	screen_material.set_shader_parameter("albedo", screen_texture)
	can_send_in = true


func set_can_submit(value: bool) -> void:
	submit_screen.visible = value
	can_submit = value
	if value:
		interaction_volume.interaction_text = "Submit form"
	else:
		interaction_volume.interaction_text = ""


func set_send_in(value: bool) -> void:
	send_in_screen.visible = value
	can_send_in = value
	if value:
		interaction_volume.interaction_text = "Send in client"
	else:
		interaction_volume.interaction_text = ""


func _on_form_submitted(result_dict: Dictionary) -> void:
	is_submitting = true
	set_can_submit(false)
	
	if result_dict["admitted"]:
		approve_screen.show()
		AudioManager.play_sound(approved_sound)
	else:
		deny_screen.show()
		AudioManager.play_sound(denied_sound)
	await get_tree().create_timer(2.0).timeout
	decision_made.emit(result_dict)
	
	#results_screen.show()
	#results_text.text = str(result_dict)
	show_results(result_dict)

func show_results(result_dict: Dictionary) -> void:
	results_text.text = ""
	results_screen.show()
	var accuracy = float(result_dict["correct"])/float(result_dict["total_count"])
	var new_text: String = "Total complications: " + str(result_dict["total_complications"]) + "\n"
	new_text += "Diagnosis accuracy: " + str(int(accuracy*100.0)) + "%\n"
	new_text += "Threat: " + str(ClientResource.Threat.keys()[result_dict["threat_type"]]) + "\n"
	new_text += "Threat identified: " + ("YES" if result_dict["identified_threat"] else "NO") + "\n"
	new_text += "Pay docked: " + str(int(lerpf(75, 0, accuracy) + int(!result_dict["identified_threat"]) * 50)) + " crebbits"
	results_tween = create_tween()
	results_tween.tween_property(results_text, "text", new_text, 3.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_interaction_volume_interacted(_interacting_node: Node):
	if can_submit and !is_submitting:
		form_submitted.emit()
	elif can_send_in:
		next_client_sent.emit()


func _on_speaker_finished():
	set_send_in(true)


func _on_client_manager_client_terminated():
	approve_screen.hide()
	deny_screen.hide()
	if results_tween.is_running():
		await results_tween.finished
	results_screen.hide()
	is_submitting = false
	set_send_in(true)


func _on_client_manager_client_primed():
	can_submit = true
