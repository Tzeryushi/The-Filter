class_name Dialogue extends Panel

@export var dialogue_button_res: PackedScene

@export var dialogue_container: VBoxContainer
@export var button_container: GridContainer
@export var dialogue_text: RichTextLabel

var dialogue_active: bool = false
var default_state: Dictionary = {}
var current_state: Dictionary
var custom_functions : Dictionary = {
	"set" : set_variable,
	"set_int" : set_int,
	"set_bool" : set_bool,
	"set_random_int" : set_random_int
}

@onready var dialogue_handler: EzDialogue = $EzDialogue

# Called when the node enters the scene tree for the first time.
func _ready():
	dialogue_active = false
	randomize()


func clear_dialogue() -> void:
	for child in button_container.get_children():
		if child is Button:
			child.queue_free()


func add_choice(choice_text: String, id: int):
	var dialogue_button: DialogueButton = dialogue_button_res.instantiate()
	dialogue_button.text = choice_text
	dialogue_button.choice_id = id
	dialogue_button.dialogue_selected.connect(_on_dialogue_button_down)
	button_container.add_child(dialogue_button)


func begin_dialogue(dialogue: JSON, dialogue_state: Dictionary = default_state) -> void:
	dialogue_active = true
	var player: Player = get_tree().get_first_node_in_group("player")
	if player:
		player.set_input_mode(false)
	
	current_state = dialogue_state
	dialogue_handler.start_dialogue(dialogue, current_state)
	dialogue_handler.next()
	visible = true


func set_variable(variable, value) -> void:
	current_state[variable] = value


func set_int(variable, value) -> void:
	current_state[variable] = int(value)


func set_bool(variable, value) -> void:
	if ["false", "False", "f", "F","0"].has(value):
		current_state[variable] = bool(0)
		return
	elif ["true", "True", "t", "T","1"].has(value):
		current_state[variable] = bool(1)
		return
	current_state[variable] = false


func set_random_int(variable, from, to) -> void:
	current_state[variable] = randi_range(int(from), int(to))


func _on_dialogue_button_down(choice_id: int):
	clear_dialogue()
	if dialogue_active:
		dialogue_handler.next(choice_id)
	else:
		visible = false
		var player: Player = get_tree().get_first_node_in_group("player")
		if player:
			player.set_input_mode(true)


func _on_ez_dialogue_end_of_dialogue_reached():
	dialogue_active = false


func _on_ez_dialogue_dialogue_generated(response: DialogueResponse):
	var tween : Tween = create_tween()
	tween.tween_property(dialogue_text, "text", response.text, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	await tween.finished
	dialogue_text.text = response.text
	if response.choices.is_empty():
		add_choice(" ... ", 0)
	else:
		for i in response.choices.size():
			add_choice(response.choices[i], i)


func _on_ez_dialogue_custom_signal_received(value):
	var parameters = value.split(",")
	if !parameters.size() > 0:
		return
	custom_functions[parameters[0]].callv(parameters.slice(1))
