extends Node

## The SceneManager is an autoload that can be called to switch between scenes specified
## within its "scenes" dictionary, each of which have string keys to access.
## A scene in the game will initialize the SceneManager by setting itself as the container_scene
## The SceneManager will then handle loading and unloading from this scene

signal transition_started
signal transition_ended

@export_category("SceneManager")
@export var start_scene_name: String = ""
@export_group("Scene Dictionaries")
@export var scenes: Dictionary = {}
@export var transitions: Dictionary = {}

## The container scene is what the scene manager stages from
## If it is null, the manager will do nothing - helpful for running test scenes
var container_scene : Node = null :
	set = set_container

var current_scenes : Array[Node] = []
var current_scene_names : Array[String] = []

var is_switching_scenes : bool = false


func init() -> void:
	if !scenes.has(start_scene_name):
		print_debug("SceneManager: Start scene not in scene dictionary!")
	else:
		add_scene(start_scene_name)


func add_scene(scene_name: String) -> void:
	if !container_scene:
		return
	assert(scenes.has(scene_name), "SceneManager: Bad scene key! Not in scene dictionary.")
	_load_and_instance(scenes[scene_name])
	current_scene_names.append(scene_name)


func remove_all_scenes() -> void:
	for scene in current_scenes:
		scene.queue_free()
	current_scenes.clear()
	current_scene_names.clear()


func switch_scene(scene_name: String) -> void:
	#TODO: Handle transition logic
	if is_switching_scenes:
		return
	is_switching_scenes = true
	
	#transition starts here
	#await transition finished
	remove_all_scenes()
	add_scene(scene_name)
	#await add end
	#transition end
	
	is_switching_scenes = false


func restart_scene(use_transition: bool = true) -> void:
	#TODO: Handle transition logic
	if is_switching_scenes:
		return
	is_switching_scenes = true
	
	for scene in current_scenes:
		scene.queue_free()
	current_scenes.clear()
	for scene_name in current_scene_names:
		_load_and_instance(scenes[scene_name])
	
	is_switching_scenes = false


func set_container(new_container:Node) -> void:
	container_scene = new_container


func get_top_scene() -> Node:
	return current_scenes[0]


func quit_game() -> void:
	get_tree().quit()


func _load_and_instance(scene_path:String) -> void:
	assert(container_scene, "SceneManager: Attempted to add scene to unset container!")
	var scene_instance = load(scene_path).instantiate()
	container_scene.add_child(scene_instance)
	current_scenes.append(scene_instance)
	#scene_instance.process_mode = Node.PROCESS_MODE_PAUSABLE
