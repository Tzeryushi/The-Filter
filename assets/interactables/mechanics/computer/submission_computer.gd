extends Node3D


@export var content_viewport: SubViewport
@export var screen_material: ShaderMaterial


func _ready() -> void:
	Broadcaster.clipboard_form_submitted.connect(form_submitted)
	var screen_texture: ViewportTexture = content_viewport.get_texture()
	screen_material.set_shader_parameter("albedo", screen_texture)

func form_submitted(result_dict) -> void:
	pass


func _on_interaction_volume_interacted(interacting_node):
	pass # Replace with function body.
