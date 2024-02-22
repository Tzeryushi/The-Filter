extends Control


signal complications_changed(complication:String, value:bool)
signal submitted(results: Dictionary)


@export var check_refs: Array[ComplicationBox]
@export var approve_box: CheckBox
@export var deny_box: CheckBox
@export var threat_field: OptionButton


var current_client: ClientResource


func _ready() -> void:
	Broadcaster.check_clipboard.connect(compare)
	Broadcaster.client_manager_new_resource_used.connect(load_details)
	
	for threat in ClientResource.Threat:
		threat_field.add_item(str(threat), ClientResource.Threat[threat])


func load_details(resource: ClientResource) -> void:
	current_client = resource
	%NameField.text = resource.client_name
	%AgeField.text = str(resource.client_age)
	%OccupationField.text = resource.client_job
	%ReasonField.text = resource.travel_reason


func clear_checks() -> void:
	for check in check_refs:
		check.button_pressed = false
	approve_box.button_pressed = false
	deny_box.button_pressed = false
	threat_field.selected = 0


func compare(resource: ClientResource) -> void:
	var result_dict: Dictionary = {
		"correct" : 0,
		"incorrect" : 0,
		"total_complications" : 0,
		"total_count" : 0,
		"threat_type" : resource.threat_type,
		"is_threat" : false,
		"identified_threat" : false,
		"admitted" : false,
		"admitted_correctly" : false,
	}
	
	var client_dictionary : Dictionary = {}
	client_dictionary.merge(resource.dialogue_symptoms)
	client_dictionary.merge(resource.env_symptoms)
	
	for box in check_refs:
		if client_dictionary[box.complication]:
			result_dict["total_complications"] += 1
		if box.button_pressed == client_dictionary[box.complication]:
			result_dict["correct"] += 1
		else:
			result_dict["incorrect"] += 1
		result_dict["total_count"] += 1
	
	result_dict["is_threat"] = resource.threat_type != ClientResource.Threat.SAFE
	result_dict["identified_threat"] = resource.threat_type == threat_field.selected
	result_dict["admitted"] = approve_box.button_pressed
	result_dict["admitted_correctly"] = resource.should_approve == approve_box.button_pressed
	if !approve_box.button_pressed and !deny_box.button_pressed:
		result_dict["admitted_correctly"] = false
	
	submitted.emit(result_dict)
	Broadcaster.clipboard_form_submitted.emit(result_dict)
	clear_checks()


func _on_checked(comp:String, value:bool):
	complications_changed.emit(comp, value)
	Broadcaster.clipboard_form_changed.emit(comp, value)


func _on_approve_toggled(toggled_on):
	if toggled_on and deny_box.button_pressed:
		deny_box.button_pressed = false


func _on_deny_toggled(toggled_on):
	if toggled_on and approve_box.button_pressed:
		approve_box.button_pressed = false
