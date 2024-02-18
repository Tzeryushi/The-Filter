extends Node3D

@export var is_enabled: bool = false
var desk_lamp_bulb: MeshInstance3D
var desk_lamp_light: SpotLight3D
var on_sound: AudioStream = preload("res://assets/interactables/lighting/desk_lamp/desk_lamp_assets/UI_Press_1.ogg")
var off_sound: AudioStream = preload("res://assets/interactables/lighting/desk_lamp/desk_lamp_assets/UI_Press_2.ogg")

func _ready():
	desk_lamp_bulb = get_node("desk_lamp/desk_lamp_bulb")
	desk_lamp_light = get_node("DeskLampLight")
	update_desk_lamp()

func _on_interaction_volume_interacted(_interacting_node):
	is_enabled = !is_enabled
	update_desk_lamp()

func update_desk_lamp():
	if is_enabled:
		desk_lamp_bulb.get_active_material(0).shading_mode = 0
		desk_lamp_light.visible = true
		AudioManager.play_sound_at_location(on_sound, global_position)
	else:
		desk_lamp_bulb.get_active_material(0).shading_mode = 1
		desk_lamp_light.visible = false
		AudioManager.play_sound_at_location(off_sound, global_position)
		
