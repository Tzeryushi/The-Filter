extends CharacterBody3D


signal navigation_ended
signal touched_player

@export var animation_tree: AnimationTree
@export var nav_agent: NavigationAgent3D

@export var monster_sound: AudioStream

const TOP_SPEED: float = 3.0
const MIN_SPEED: float = 1.0

var speed: float = 3.5
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
		if (nav_agent.target_position - global_position).length() < 10.5:
			speed = lerpf(MIN_SPEED, TOP_SPEED, (max((nav_agent.target_position - global_position).length(),1)-1)/9.5)
		var new_velocity = (next_location - current_location).normalized() * speed
		velocity = new_velocity
	else:
		if is_targeting:
			is_targeting = false
		velocity = Vector3.ZERO
	if velocity.length() != 0:
		global_transform = global_transform.looking_at(transform.origin + velocity, Vector3.UP)
	move_and_slide()


func spawn() -> void:
	var id = AudioManager.play_sound_at_node(monster_sound, self)
	var audio_player = instance_from_id(id)
	audio_player.finished.connect(func(): audio_player.play())
	position.y = position.y - 3.0
	var tween : Tween = create_tween()
	tween.tween_property(self, "position:y", position.y+3.0, 8.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)


func update_target_position(target: Vector3) -> void:
	is_targeting = true
	nav_agent.set_target_position(target)


func set_is_targeting(value: bool) -> void:
	if is_targeting and !value:
		navigation_ended.emit()
	is_targeting = value


func _on_killbox_body_entered(body):
	touched_player.emit()
	SceneManager.switch_scene("end_scene")
