extends Node

@export var sub_view : SubViewport

func _ready() -> void:
	
	print(sub_view.size)
	SceneManager.set_container($SubViewportContainer/SubViewport/GameSpace)
	SceneManager.init()
