class_name ComplicationBox
extends CheckBox


signal checked(comp:String, value:bool)

@export var complication : String = "headaches"


func _pressed() -> void:
	checked.emit(complication, button_pressed)
