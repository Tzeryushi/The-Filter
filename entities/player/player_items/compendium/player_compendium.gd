extends PlayerItem

@export var content_viewport: SubViewport
@export var paper_mesh : MeshInstance3D
@export var pages: Array[CompendiumPage]

func _ready() -> void:
	var paper_texture: ViewportTexture = content_viewport.get_texture()
	var paper_material = paper_mesh.get_active_material(0)
	paper_material = paper_material as StandardMaterial3D
	if paper_material:
		paper_material.albedo_texture = paper_texture
