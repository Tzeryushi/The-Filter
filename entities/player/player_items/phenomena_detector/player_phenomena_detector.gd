extends PlayerItem


@export var sound_on: AudioStream = preload("res://entities/player/player_items/flashlight/Flashlight on.wav")
@export var sound_off: AudioStream = preload("res://entities/player/player_items/flashlight/Flashlight off.wav")
@export var phenomena_detector_rays: Array[RayCast3D]
@export var hit_scene: PackedScene = preload("res://entities/player/player_items/phenomena_detector/phenomena_detector_hit.tscn")

var active_stream_player: PrioritizedAudioStreamPlayer
var is_on : bool = false : set = set_is_on
var is_detected: bool = false
var game_scene: Node3D
var phenomena_gem: MeshInstance3D
var phenomena_screen: MeshInstance3D
var phenomena_gem_off: MeshInstance3D
var phenomena_screen_off: MeshInstance3D

const DETECTOR_SPREAD = .4;


func _ready() -> void:
	game_scene = get_tree().get_first_node_in_group("game_space")
	is_on = false
	phenomena_gem = get_node("phenomena_detector/Gem")
	phenomena_screen = get_node("phenomena_detector/Screen")
	phenomena_gem_off = get_node("phenomena_detector/Gem_Off")
	phenomena_screen_off = get_node("phenomena_detector/Screen_Off")
	get
	
	
func _physics_process(delta):
	if is_on:
		var camera_transform: Transform3D = get_viewport().get_camera_3d().global_transform
		for phenomena_detector_ray in phenomena_detector_rays:
			phenomena_detector_ray.set_global_transform(camera_transform)
			var x_deviation = randf_range(DETECTOR_SPREAD * -1, DETECTOR_SPREAD)
			var y_deviation = randf_range(DETECTOR_SPREAD * -1, DETECTOR_SPREAD)
			var z_deviation = randf_range(DETECTOR_SPREAD * -1, DETECTOR_SPREAD)
			phenomena_detector_ray.rotate_x(x_deviation)
			phenomena_detector_ray.rotate_y(y_deviation)
			phenomena_detector_ray.rotate_z(z_deviation)


func on_exit() -> void:
	set_is_on(false)


func use() -> void:
	is_on = !is_on
	if is_on:
		AudioManager.play_sound(sound_on)
		
		phenomena_gem.set_visible(true)
		phenomena_gem_off.set_visible(false)
		phenomena_screen.set_visible(true)
		phenomena_screen_off.set_visible(false)
		
		for phenomena_detector_ray in phenomena_detector_rays:
			phenomena_detector_ray.set_enabled(true)
	else:
		AudioManager.play_sound(sound_off)
		
		phenomena_gem.set_visible(false)
		phenomena_gem_off.set_visible(true)
		phenomena_screen.set_visible(false)
		phenomena_screen_off.set_visible(true)
		
		for phenomena_detector_ray in phenomena_detector_rays:
			phenomena_detector_ray.set_enabled(false)


func set_is_on(value:bool) -> void:
	is_on = value


func _on_phenomena_detector_ray_phenomena_detected(collision_point: Vector3):
	if is_on:
		var hit: PhenomenaDetectorHit = hit_scene.instantiate()
		game_scene.add_child(hit)
		hit.global_position = collision_point
	pass # Replace with function body.


func _on_phenomena_detector_ray_phenomena_detections_ceased():
	is_detected = false
	pass # Replace with function body.
