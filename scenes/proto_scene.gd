extends Node3D

var sound: AudioStream = preload("res://resources/sounds/sfx/take_me_to_your_leader.ogg")
var proto_dialogue: JSON = preload("res://assets/dialogue/proto_dialogue.json")
var sound_timer := Timer.new()
var player: Player

func _ready():
	#var dialogue: Dialogue = $Player/PlayerCamera/CameraSpace.get_node("Dialogue")
	#dialogue.begin_dialogue(proto_dialogue)
	
	#add_child(sound_timer)
	#sound_timer.wait_time = .25
	#sound_timer.one_shot = true
	#sound_timer.start()
	#sound_timer.timeout.connect(func(): AudioManager.play_sound(sound))
	#sound_timer.timeout.connect(func(): AudioManager.play_sound_at_location(sound, Vector3(10,0,10)))
	#sound_timer.timeout.connect(func(): AudioManager.play_sound_at_node(sound,get_node("Player")))
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
