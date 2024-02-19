extends PlayerItem


@export var spotlight : SpotLight3D

var is_on : bool = false : set = set_is_on

func _ready() -> void:
	is_on = false


func on_exit() -> void:
	set_is_on(false)


func use() -> void:
	is_on = !is_on


func set_is_on(value:bool) -> void:
	is_on = value
	spotlight.visible = is_on
