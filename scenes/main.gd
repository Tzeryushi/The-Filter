extends Node

func _ready() -> void:
	SceneManager.set_container(self)
	SceneManager.init()
