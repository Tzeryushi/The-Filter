extends Node3D


signal form_submitted
signal decision_made(results: Dictionary)

@export var content_viewport: SubViewport
@export var screen_material: ShaderMaterial

@export var submit_screen: Control
@export var approve_screen: Control
@export var deny_screen: Control
@export var results_screen: Control
@export var results_text: RichTextLabel

var can_submit: bool = true : set = set_can_submit
var is_submitting: bool = false

func _ready() -> void:
	Broadcaster.clipboard_form_submitted.connect(_on_form_submitted)
	var screen_texture: ViewportTexture = content_viewport.get_texture()
	screen_material.set_shader_parameter("albedo", screen_texture)


func set_can_submit(value: bool) -> void:
	submit_screen.visible = value
	can_submit = value


func _on_form_submitted(result_dict: Dictionary) -> void:
	is_submitting = true
	
	set_can_submit(false)
	if result_dict["admitted"]:
		approve_screen.show()
	else:
		deny_screen.show()
	await get_tree().create_timer(2.0).timeout
	decision_made.emit(result_dict)
	
	results_screen.show()
	results_text.text = str(result_dict)
	await get_tree().create_timer(5.0).timeout
	approve_screen.hide()
	deny_screen.hide()
	results_screen.hide()
	
	is_submitting = false


func _on_interaction_volume_interacted(_interacting_node: Node):
	if can_submit and !is_submitting:
		form_submitted.emit()


func _on_client_manager_client_primed():
	can_submit = true
