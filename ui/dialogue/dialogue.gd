class_name Dialogue extends Panel

@export var dialogue_button_res: PackedScene = preload("res://ui/dialogue/dialogue_button.tscn")

var dialogue_active: bool = false
var state: Dictionary = {}
var dialogue_container: VBoxContainer
var dialogue_text: RichTextLabel

@onready var dialogue_handler: EzDialogue = $EzDialogue

# Called when the node enters the scene tree for the first time.
func _ready():
	dialogue_active = false
	dialogue_container = get_node("DialogueContainer")
	dialogue_text = dialogue_container.get_node("DialogueText")


func clear_dialogue() -> void:
	for child in dialogue_container.get_children():
		if child is Button:
			child.queue_free()
	return


func add_choice(choice_text: String, id: int):
	var dialogue_button: DialogueButton = dialogue_button_res.instantiate()
	dialogue_button.text = choice_text
	dialogue_button.choice_id = id
	dialogue_button.dialogue_selected.connect(_on_dialogue_button_down)
	dialogue_container.add_child(dialogue_button)


func begin_dialogue(dialogue: JSON) -> void:
	dialogue_active = true
	var player: Player = get_tree().get_first_node_in_group("player")
	if player:
		player.set_input_mode(false)
		
	dialogue_handler.start_dialogue(dialogue, state)
	dialogue_handler.next()
	visible = true


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
	dialogue_text.text = response.text
	if response.choices.is_empty():
		add_choice("Say nothing.", 0)
	else:
		for i in response.choices.size():
			add_choice(response.choices[i], i)
