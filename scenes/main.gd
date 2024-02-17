extends Node

@export var sub_view : SubViewport

func _ready() -> void:
	SceneManager.set_container(self)
	SceneManager.init()
