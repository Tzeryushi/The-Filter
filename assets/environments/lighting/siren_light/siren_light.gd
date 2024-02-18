class_name SirenLight extends Node3D

@export var rotation_speed := 6.28
@export var enabled := false

var rotation_timer := Timer.new()
var spotlight: SpotLight3D

# Called when the node enters the scene tree for the first time.
func _ready():
	spotlight = get_node("SirenSpotlight")
	spotlight.visible = enabled
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if enabled:
		spotlight.rotate_y(rotation_speed * delta)
	pass


func set_siren_light_enabled(enabled: bool) -> void:
	self.enabled = enabled
	spotlight.visible = enabled
