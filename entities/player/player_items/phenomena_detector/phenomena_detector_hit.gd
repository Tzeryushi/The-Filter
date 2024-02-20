class_name PhenomenaDetectorHit extends Node3D

var destruct_timer := Timer.new()


func _ready():
	add_child(destruct_timer)
	destruct_timer.one_shot = true
	destruct_timer.wait_time = .5
	destruct_timer.start()
	destruct_timer.timeout.connect(_on_destruct_timer_timeout)
	pass # Replace with function body.


func _on_destruct_timer_timeout():
	queue_free()
