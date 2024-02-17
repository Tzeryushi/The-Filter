class_name PlayerMovement
extends Node
##Affects the movement of the player body.


@export var speed: float = 3.0
@export var acceleration: float = 30.0
@export var gravity: float = 9.8

@export var body: CharacterBody3D
@export var camera: Camera3D

var move_dir: Vector2
var walk_velocity: Vector3
var gravitational_velocity : Vector3


func _ready():
	set_process(false)
	pass

func process_physics(delta: float):
	body.velocity = _walk(delta) + _gravity(delta)
	body.move_and_slide()


func _walk(delta: float) -> Vector3:
	move_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var actual_speed = speed - (float(Input.is_action_pressed("crouch")) * 0.6 * speed)
	var forward: Vector3 = camera.global_transform.basis * Vector3(move_dir.x, 0, move_dir.y)
	var walk_direction: Vector3 = Vector3(forward.x, 0, forward.z).normalized()
	walk_velocity = walk_velocity.move_toward(walk_direction * actual_speed * move_dir.length(), acceleration * delta)
	return walk_velocity


func _gravity(delta: float) -> Vector3:
	gravitational_velocity = Vector3.ZERO if body.is_on_floor() else gravitational_velocity.move_toward(
				Vector3(0, body.velocity.y - gravity, 0), gravity * delta)
	return gravitational_velocity
