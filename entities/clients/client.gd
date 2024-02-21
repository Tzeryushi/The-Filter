class_name Client
extends CharacterBody3D


signal navigation_ended

@export var client_mesh : MeshInstance3D
@export var client_skeleton : Skeleton3D

@export var growth_scene: PackedScene
@export var sound_scene: PackedScene

@export var growth_nodes: Array[Node3D]
@export var head_node: Node3D
@export var neck_node: Node3D
@export var heart_node: Node3D

@export var animation_tree: AnimationTree
@export var nav_agent: NavigationAgent3D

const TOP_SPEED: float = 6.0

var client_resource: ClientResource
var speed: float = 2.0
var is_targeting: bool = false : set = set_is_targeting

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	var blend_dist = move_toward(animation_tree.get("parameters/movement/blend_position"), velocity.length()/TOP_SPEED, delta)
	animation_tree.set("parameters/movement/blend_position", blend_dist)


func _physics_process(delta: float) -> void:
	if !nav_agent.is_navigation_finished():
		var current_location = global_transform.origin
		var next_location = nav_agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * speed
		velocity = new_velocity
	else:
		if is_targeting:
			is_targeting = false
		velocity = Vector3.ZERO
	if velocity.length() != 0:
		global_transform = global_transform.looking_at(transform.origin + velocity, Vector3.UP)
		
	move_and_slide()


func update_target_position(target: Vector3) -> void:
	is_targeting = true
	nav_agent.set_target_position(target)


## Set up visual modifications, 
func propagate() -> void:
	pass


func make_growths() -> void:
	for i in randi_range(1,3):
		var bone : Node3D = growth_nodes.pick_random()
		bone.add_child(growth_scene.instantiate())
		growth_nodes.erase(bone)


func make_sound(sound_type: DetectableSound.SoundType = DetectableSound.SoundType.HEARTBEAT) -> void:
	var new_sound = sound_scene.instantiate()
	new_sound = new_sound as DetectableSound
	var parent_node : Node3D
	if new_sound == DetectableSound.SoundType.CRICKETS or new_sound == DetectableSound.SoundType.SCREAM:
		parent_node = head_node
	else:
		parent_node = heart_node
	parent_node.add_child(new_sound)
	new_sound.set_sensor_sound(sound_type)


func make_aura() -> void:
	var colorer = Color.from_hsv(randf_range(0, 1.0), 1, 1)
	print(colorer)
	%Aura.light_color = colorer
	%Aura.show()


func set_is_targeting(value: bool) -> void:
	if is_targeting and !value:
		navigation_ended.emit()
	is_targeting = value


func set_texture(new_texture: Texture2D) -> void:
	if client_mesh.material_override is ShaderMaterial:
		client_mesh.material_override.set_shader_parameter("albedo", new_texture)
