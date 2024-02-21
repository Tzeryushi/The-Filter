extends Node3D

@export var light : OmniLight3D

# Called when the node enters the scene tree for the first time.
func _ready():
	var tween: Tween = create_tween()
	tween.tween_property(light, "omni_range", randf_range(0.3,2.0), 5.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(light, "omni_range", 0.0, 5.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CIRC)
	tween.tween_callback(queue_free)
