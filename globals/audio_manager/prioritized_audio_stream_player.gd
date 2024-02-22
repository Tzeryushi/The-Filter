class_name PrioritizedAudioStreamPlayer extends AudioStreamPlayer

signal finished_with_reference(instance: PrioritizedAudioStreamPlayer)

@export var priority := 1


func _ready():
	finished.connect(_on_finished)


func _on_finished():
	finished_with_reference.emit(self)
