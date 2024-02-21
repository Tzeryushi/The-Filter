extends Node3D

@export var is_enabled: bool = false
@export var on_sound: AudioStream
@export var off_sound: AudioStream
var desk_lamp_bulb: MeshInstance3D
var desk_lamp_light: SpotLight3D

func _ready():
	desk_lamp_bulb = get_node("desk_lamp/desk_lamp_bulb")
	desk_lamp_light = get_node("DeskLampLight")
	update_desk_lamp()

func _on_interaction_volume_interacted(_interacting_node):
	is_enabled = !is_enabled
	if is_enabled:
		AudioManager.play_sound_at_location(on_sound, global_position)
	else:
		AudioManager.play_sound_at_location(off_sound, global_position)
	update_desk_lamp()

func update_desk_lamp():
	if is_enabled:
		desk_lamp_bulb.get_active_material(0).shading_mode = 0
		desk_lamp_light.visible = true
	else:
		desk_lamp_bulb.get_active_material(0).shading_mode = 1
		desk_lamp_light.visible = false
		
