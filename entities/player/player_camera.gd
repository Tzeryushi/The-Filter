class_name PlayerCamera
extends Camera3D

@export var camera_sensitivity: float = 1
@export var crouch_distance := Vector3(0,-0.7,0)

var look_dir: Vector2 ## Input direction for look/aim
var is_crouching: bool = false : set = set_crouching

var crouch_tween: Tween = null
var look_tween: Tween = null

@onready var base_position: Vector3 = position
@onready var interaction_text: RichTextLabel = $CameraSpace/InteractionText


func process_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_dir = event.relative * 0.001
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			_rotate_camera()


func set_crouching(value: bool = false) -> void:
	if value != is_crouching:
		if crouch_tween:
			crouch_tween.kill()
		crouch_tween = create_tween()
		crouch_tween.tween_property(self, "position", base_position + crouch_distance * int(value), 0.15)
	is_crouching = value
	

func _rotate_camera(sensitivity_modifier: float = 1.0) -> void:
	rotation.y -= look_dir.x * camera_sensitivity * sensitivity_modifier
	rotation.x = clamp(rotation.x - look_dir.y * camera_sensitivity * sensitivity_modifier, -1.5, 1.5)


func _on_interaction_ray_detected(interacting_object):
	if interacting_object is InteractionVolume:
		interaction_text.text = interacting_object.get_interaction_text()


func _on_interaction_ray_detections_ceased():
	interaction_text.text = "[center]"


func _on_player_look_at_point(location: Vector3):
	look_tween = create_tween()
	look_tween.tween_property(self, "global_transform", global_transform.looking_at(location), 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	#look_at(location)
