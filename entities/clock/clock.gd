extends Node

@export var time: float = 0.0
var hour_hand: MeshInstance3D
var minute_hand: MeshInstance3D


func _ready():
	hour_hand = get_node("Hour")
	minute_hand = get_node("Minute")
	update_hand_rotation()


func update_hand_rotation():
	minute_hand.rotation = Vector3(0,(fmod(time, 1.0) * 2 * PI * -1),0)
	hour_hand.rotation = Vector3(0,((time / 12.0) * 2 * PI * -1),0)


func add_time(time_to_add: float):
	time += time_to_add
	while(time > 12):
		time -= 12
	update_hand_rotation()


func set_time(new_time: float):
	time = new_time
	while(time > 12):
		time -= 12
	update_hand_rotation()
