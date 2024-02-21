class_name PhenomenaSpawner
extends Node3D

@export var type: PhenomenaType = PhenomenaType.ANGEL
@export var angel_model: PackedScene
@export var centipede_model: PackedScene
@export var face_model: PackedScene
@export var star_model: PackedScene

var active_model: PackedScene

enum PhenomenaType {ANGEL, CENTIPEDE, FACE, STAR}


func _ready():
	active_model = set_phenomena_model(type)


func random_model():
	var new_type = PhenomenaSpawner.PhenomenaType[
		PhenomenaSpawner.PhenomenaType.keys()[
			randi() % PhenomenaSpawner.PhenomenaType.size()
			]
		]
	set_phenomena_model(new_type)


func set_phenomena_model(new_type: PhenomenaType):
	match new_type:
		PhenomenaType.ANGEL:
			active_model = angel_model
		PhenomenaType.CENTIPEDE:
			active_model = centipede_model
		PhenomenaType.FACE:
			active_model = face_model
		PhenomenaType.STAR:
			active_model = star_model
	for child in get_children():
		remove_child(child)
		child.queue_free()
	add_child(active_model.instantiate())
	rotate_y(randf() * 2 * PI)


func despawn_model():
	for child in get_children():
		remove_child(child)
		child.queue_free()
