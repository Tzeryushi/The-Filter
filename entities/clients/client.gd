class_name Client
extends Node


@export var client_mesh : MeshInstance3D
@export var client_skeleton : Skeleton3D
@export var growth_scene: PackedScene
@export var growth_nodes: Array[Node3D]
@export var head_node: Node3D


var client_resource: ClientResource


func _ready() -> void:
	pass


## Set up visual modifications, 
func propagate() -> void:
	pass


func make_growths() -> void:
	for i in randi_range(1,3):
		var bone : Node3D = growth_nodes.pick_random()
		bone.add_child(growth_scene.instantiate())
		growth_nodes.erase(bone)


func set_texture(new_texture: Texture2D) -> void:
	if client_mesh.material_override is ShaderMaterial:
		client_mesh.material_override.set_shader_parameter("albedo", new_texture)
