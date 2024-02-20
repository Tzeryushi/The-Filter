extends Node


@export var client_manager : ClientManager

func _ready() -> void:
	Broadcaster.clipboard_form_submitted.connect(sort_results)

func sort_results(results: Dictionary) -> void:
	print(results)
