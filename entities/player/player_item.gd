class_name PlayerItem
extends Node
## Virtuals for individual player item implementations.


@export var item_resource: ItemResource

var item_name: String : get = get_item_name

func on_enter() -> void:
	pass


func on_exit() -> void:
	pass


func process_input(_event: InputEvent) -> void:
	pass


func process_frame(_delta: float) -> void:
	pass


func process_physics(_delta: float) -> void:
	pass


func use() -> void:
	pass


func unuse() -> void:
	pass


func get_item_name() -> String:
	return item_resource.item_name
