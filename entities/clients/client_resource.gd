class_name ClientResource
extends Resource


enum Personality {NORMAL = 0, GRUMPY = 1, IMPATIENT = 2, QUIET = 3, STOIC = 4, DERANGED = 5, ENTHUSIASTIC = 6, LIAR = 7,}
enum Threat {
	SAFE = 0, OVERSYMPTOMATIC = 1, SHADOWHIKER = 2, FLESHRIDER = 3, DOPPELGANGER = 4,
	PULSEJOCKEY = 5, CHRONOMONON = 6, DISCARNIVORE = 7, UNKNOWN = 8}

@export var client_name: String
@export var client_age: int
@export var client_job: String
@export var travel_reason: String
@export var personality_type: Personality
@export var threat_type: Threat
@export var has_ending_dialogue: bool = false
@export_range(0.0, 100.0) var starting_stress: float = 0.0

@export var dialogue: JSON
@export var dialogue_state: Dictionary = {
	"intro_given" : false,
	"answered_name" : false,
	"answered_age" : false,
	"answered_job" : false,
	"answered_reason" : false,
	"answered_phenom" : false,
	"approved" : false,
	"denied" : false,
}
#@export var model
#@export var skin

# SOME levels of symptoms are okay. Too many indicates a threat.

@export_group("Benign Symptoms")
#@export_subgroup("Dialogue Symptoms")
@export var dialogue_symptoms: Dictionary = {
	"forgetful": false,	## Affects dialogue, forgets details like name, age, background and trip reason
	"headache": false,	## Will complain about headache.
	"irrational": false,	## Will bring up non-sequitirs, ignore questions
	"nauseated": false,	## Will bring up nausea.
	"knows_too_much": false,	## This guy knows my name?
	"unresponsive": false,	## Ignores questions. Never a good sign.
	"hallucinating": false,	## Answers questions you didn't ask.
	"too_polite": false,	## Can't trust this guy.
	"encountered_entity": false,	## I seen it I swears
}

#@export_subgroup("Environment Symptoms")
@export var env_symptoms: Dictionary = {
	"strange_growths": false,	## Can be benign.
	"averse_to_light": false,	## Usually nothing. Can be a shadowhiker.
	"time_dilation": false,	## Clock speed is affected at random intervals.
	"too_many_heartbeats": false,	## Sometimes a pulse jockey. Sometimes people are just weird.
	"second_presence": false,	## Feels like someone else is around.
	"inexplicable_phenomena": false,	## Something's wrong.
	"manifesting_aura": false,	## A forboding aura emanates. A lingering spirit?
	"strange_sounds": false,
	"crickets?": false,
	"increased_shadows": false,
}

@export_group("Visuals")
@export var texture: Texture2D
@export var shader_override: ShaderMaterial
@export var use_override: bool = false
@export var size_scale: float = 0.8


var threat_dict: Dictionary = {
	Threat.OVERSYMPTOMATIC : oversymptomatic,
}

var should_approve: bool = false
var stress: float = 0.0

func _init() -> void:
	dialogue_state["client_name"] = client_name
	dialogue_state["client_age"] = client_age
	dialogue_state["client_job"] = client_job
	dialogue_state["travel_reason"] = travel_reason
	dialogue_state["personality_type"] = personality_type
	dialogue_state["threat_type"] = threat_type
	if threat_type == Threat.SAFE:
		should_approve = true
	stress = starting_stress
	print(starting_stress)
	print(stress)


func oversymptomatic() -> void:
	pass
	

func shadowhiker() -> void:
	dialogue_symptoms["headaches"] = true
	dialogue_symptoms["knows_too_much"] = true
	env_symptoms["averse_to_light"] = true
	env_symptoms["increased_shadows"] = true


func fleshrider() -> void:
	dialogue_symptoms["irrational"] = true
	dialogue_symptoms["nauseated"] = true
	dialogue_symptoms["hallucinating"] = true
	env_symptoms["strange_growths"] = true


func chronomonon() -> void:
	dialogue_symptoms["hallucinating"] = true
	dialogue_symptoms["knows_too_much"] = true
	env_symptoms["time_dilation"] = true
	env_symptoms["manifesting_aura"] = true
	

func doppelganger() -> void:
	dialogue_symptoms["too_polite"] = true
	dialogue_symptoms["forgetful"] = true
	dialogue_symptoms["irrational"] = true
	env_symptoms["crickets"] = true
	

func pulsejockey() -> void:
	dialogue_symptoms["unresponsive"] = true
	dialogue_symptoms["headache"] = true
	dialogue_symptoms["forgetful"] = true
	env_symptoms["too_many_heartbeats"] = true


func disincarnivores() -> void:
	dialogue_symptoms["hallucinating"] = true
	dialogue_symptoms["unresponsive"] = true
	env_symptoms["second_presence"] = true
	env_symptoms["strange_sounds"] = true
	

func unknown() -> void:
	pass
	
