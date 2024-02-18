class_name DialogueButton extends Button

var choice_id = -1
signal dialogue_selected(choice_id: int)

func _ready():
	alignment = HORIZONTAL_ALIGNMENT_LEFT
	pressed.connect(_on_pressed)

func _on_pressed():
	dialogue_selected.emit(choice_id)
