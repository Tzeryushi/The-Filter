class_name ItemManager
extends Node3D


@export var camera: PlayerCamera
@export var anim_player: AnimationPlayer

@export var starter_items: Array[String] # Will likely be empty in most circumstances.
@export var item_ref_array: Array[PlayerItem]

@export var inventory_size: int = 3

var item_list: Dictionary = {}
var current_item: PlayerItem = null
var inventory_array: Array[PlayerItem] = []	## Array of item call strings

var is_swapping: bool = false


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


func swap_forward() -> void:
	if inventory_array.size() <= 1 or is_swapping:
		return
	is_swapping = true
	
	var next_item_index: int = inventory_array.find(current_item) + 1
	if next_item_index >= inventory_array.size():
		next_item_index = 0
	
	deactivate_item()
	await anim_player.animation_finished
	current_item = inventory_array[next_item_index]
	activate_item()
	
	is_swapping = false


func swap_back() -> void:
	if inventory_array.size() <= 1 or is_swapping:
		return
	is_swapping = true
	
	var last_item_index: int = inventory_array.find(current_item) - 1
	if last_item_index < 0:
		last_item_index = inventory_array.size() - 1
	
	deactivate_item()
	await anim_player.animation_finished
	current_item = inventory_array[last_item_index]
	activate_item()
	
	is_swapping = false


func process_input(event: InputEvent) -> void:
	if event.is_action_pressed("swap_forward"):
		swap_forward()
	elif event.is_action_pressed("swap_back"):
		swap_back()
	
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


func drop_item(index: int = 0) -> void:
	pass


# Calls the current item's use function
func use_item() -> void:
	pass
