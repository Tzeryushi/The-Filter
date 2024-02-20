extends Node3D

var reel1: MeshInstance3D
var reel2: MeshInstance3D

@export var rotation_speed: float = 1.0
@export var offset_degrees: float = randf_range(0.0, 60.0)
@export var initial_rotation_degrees: float = randf_range(0.0, 60.0)

# Called when the node enters the scene tree for the first time.
func _ready():
	reel1 = get_node("reel_computer/Reel1")
	reel2 = get_node("reel_computer/Reel2")
	reel1.rotate_x(deg_to_rad(-initial_rotation_degrees))
	reel2.rotate_x(deg_to_rad(-1 * (initial_rotation_degrees + offset_degrees)))

func _physics_process(delta):
	reel1.rotate_x(-rotation_speed * delta)
	reel2.rotate_x(-rotation_speed * delta)
