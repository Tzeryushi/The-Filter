extends Node

@export var speed: float = 10.0
@export var acceleration: float = 30.0

@export var body: CharacterBody3D
@export var camera: Camera3D

var move_dir: Vector2
var walk_velocity: Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	body.velocity = _walk(delta)
	body.move_and_slide()

func _walk(delta: float) -> Vector3:
	move_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var forward: Vector3 = camera.global_transform.basis * Vector3(move_dir.x, 0, move_dir.y)
	var walk_direction: Vector3 = Vector3(forward.x, 0, forward.z).normalized()
	walk_velocity = walk_velocity.move_toward(walk_direction * speed * move_dir.length(), acceleration * delta)
	return walk_velocity
