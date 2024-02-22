extends CharacterBody3D


signal navigation_ended
signal touched_player

@export var animation_tree: AnimationTree
@export var nav_agent: NavigationAgent3D

const TOP_SPEED: float = 2.6

var speed: float = 2.5
var is_targeting: bool = false : set = set_is_targeting


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	var blend_dist = move_toward(animation_tree.get("parameters/move/blend_position"), velocity.length()/TOP_SPEED, delta)
	animation_tree.set("parameters/move/blend_position", blend_dist)


func _physics_process(_delta: float) -> void:
	if !nav_agent.is_navigation_finished():
		var current_location = global_transform.origin
		var next_location = nav_agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * speed
		velocity = new_velocity
	else:
		if is_targeting:
			is_targeting = false
		velocity = Vector3.ZERO
	if velocity.length() != 0:
		global_transform = global_transform.looking_at(transform.origin + velocity, Vector3.UP)
		
	move_and_slide()


func update_target_position(target: Vector3) -> void:
	is_targeting = true
	nav_agent.set_target_position(target)


func set_is_targeting(value: bool) -> void:
	if is_targeting and !value:
		navigation_ended.emit()
	is_targeting = value


func _on_killbox_body_entered(body):
	touched_player.emit()
