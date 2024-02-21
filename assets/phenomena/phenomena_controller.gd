class_name PhenomenaController
extends Node3D

@export var phenomena_spawners: Array[PhenomenaSpawner]


func _ready():
	for spawner in phenomena_spawners:
		spawner.despawn_model()


func spawn_new_phenomena():
	for spawner in phenomena_spawners:
		spawner.despawn_model()
	var index = randi_range(0, phenomena_spawners.size() - 1)
	var spawner = phenomena_spawners[index]
	spawner.random_model()


func _on_client_manager_client_launched(attribute_array: Array[ClientManager.Attribute]):
	for attribute in attribute_array:
		if attribute == ClientManager.Attribute.SECOND_PRESENCE:
			spawn_new_phenomena()


func _on_client_manager_client_terminated():
	for spawner in phenomena_spawners:
		spawner.despawn_model()
