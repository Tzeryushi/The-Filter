class_name ItemManager
extends Node3D


signal swapping_finished

@export var camera: PlayerCamera
@export var anim_player: AnimationPlayer

@export var starter_items: Array[String] # Will likely be empty in most circumstances.
@export var item_ref_array: Array[PlayerItem]

@export var inventory_size: int = 3

var item_list: Dictionary = {}
var current_item: PlayerItem = null
var inventory_array: Array[PlayerItem] = []	## Array of item call strings

var is_swapping: bool = false
var is_inventory_full : get = get_is_inventory_full


func _ready() -> void:
	# Creates a dictionary with item name string keys
	for item in item_ref_array:
		item_list[item.item_name] = item
	
	for i_name in starter_items:
		inventory_array.append(item_list[i_name])
	
	if inventory_array.size() > 0:
		current_item = inventory_array.front()
		activate_item()


func activate_item() -> void:
	current_item.on_enter()
	anim_player.queue(current_item.item_resource.activate_anim)


func deactivate_item() -> void:
	current_item.on_exit()
	anim_player.play(current_item.item_resource.deactivate_anim)


func swap_to_index(index: int) -> void:
	if (inventory_array.size() <= 1 or is_swapping or
			index >= inventory_array.size() or index < 0):
		return
	is_swapping = true
	deactivate_item()
	await anim_player.animation_finished
	current_item = inventory_array[index]
	activate_item()
	is_swapping = false
	swapping_finished.emit()


func swap_forward() -> void:
	var next_item_index: int = inventory_array.find(current_item) + 1
	if next_item_index >= inventory_array.size():
		next_item_index = 0
	
	swap_to_index(next_item_index)


func swap_back() -> void:
	var last_item_index: int = inventory_array.find(current_item) - 1
	if last_item_index < 0:
		last_item_index = inventory_array.size() - 1
	
	swap_to_index(last_item_index)


func process_input(event: InputEvent) -> void:
	if event.is_action_pressed("swap_forward"):
		swap_forward()
	elif event.is_action_pressed("swap_back"):
		swap_back()
	
	if event.is_action_pressed("use"):
		use_item()
	if event.is_action_pressed("drop"):
		drop_item()
	
	if current_item:
		current_item.process_input(event)


func process_frame(delta: float) -> void:
	if current_item:
		current_item.process_frame(delta)


func process_physics(delta: float) -> void:
	if current_item:
		current_item.process_frame(delta)


func pickup_item(item_name: String) -> void:
	inventory_array.append(item_list[item_name])
	current_item = inventory_array.back()
	activate_item()


func drop_item(index: int = -1) -> void:
	if !current_item:
		return
	var new_item = current_item.item_resource.item_scene.instantiate()
	SceneManager.get_top_scene().add_child(new_item)
	new_item.global_position = get_tree().get_first_node_in_group("player").global_position
	deactivate_item()
	inventory_array.erase(current_item)
	if !inventory_array.is_empty():
		current_item = inventory_array.front()
		activate_item()
	else:
		current_item = null


# Calls the current item's use function
func use_item() -> void:
	if current_item:
		current_item.use()


func get_is_inventory_full() -> bool:
	return inventory_array.size() >= inventory_size
