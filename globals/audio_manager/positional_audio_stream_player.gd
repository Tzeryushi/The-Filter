class_name PositionalAudioStreamPlayer extends AudioStreamPlayer3D

signal finished_with_reference(instance: PrioritizedAudioStreamPlayer)

@export var priority := 1

var followed_node: Node3D = null


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta) -> void:
	if followed_node:
		global_position = followed_node.global_position
	pass


## Set node for positional audio player to follow
# Params
# followed_node = Node3D for PositionalAudioStreamPlayer instance to follow
func set_followed_node(new_followed_node: Node3D) -> void:
	followed_node = new_followed_node
	followed_node.tree_exiting.connect(_on_followed_node_exit_tree)
	pass

## Clear followed node when tree_exiting signal emitted
func _on_followed_node_exit_tree() -> void:
	followed_node = null
	pass


func _ready():
	finished.connect(_on_finished)


func _on_finished():
	finished_with_reference.emit(self)
