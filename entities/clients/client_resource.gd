class_name ClientResource
extends Resource


enum Personality {NORMAL = 0, GRUMPY = 1, IMPATIENT = 2, QUIET = 3, STOIC = 4, DERANGED = 5, ENTHUSIASTIC = 6, LIAR = 7,}
enum Threat {
	SAFE = 0, OVERSYMPTOMATIC = 1, SHADOWHIKER = 2, FLESHRIDER = 3, DOPPELGANGER = 4,
	PULSEJOCKEY = 5, CHRONOMONON = 6, LINGERING_SPIRIT = 7, UNKNOWN = 8}

@export var client_name: String
@export var client_age: int
@export var client_job: String
@export var travel_reason: String
@export var personality_type: Personality
@export var threat_type: Threat

@export var dialogue: JSON
@export var dialogue_state: Dictionary = {
	"intro_given" : false,
	"answered_name" : false,
	"answered_age" : false,
	"answered_job" : false,
	"answered_reason" : false,
	"answered_phenom" : false,
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
#@export var forgetful: bool	## Affects dialogue, forgets details like name, age, background and trip reason
#@export var headache: bool	## Will complain about headache.
#@export var irrational: bool	## Will bring up non-sequitirs, ignore questions
#@export var nauseated: bool	## Will bring up nausea.
#@export var knows_too_much: bool	## This guy knows my name?
#@export var unresponsive: bool	## Ignores questions. Never a good sign.
#@export var hallucinating: bool	## Answers questions you didn't ask.
#@export var too_polite: bool	## Can't trust this guy.
#@export var encountered_entity: bool	## I seen it I swears

#@export_subgroup("Environment Symptoms")
@export var env_symptoms: Dictionary = {
	"strange_growths": false,	## Can be benign.
	"averse_to_light": false,	## Usually nothing. Can be a shadowhiker.
	"time_dilation": false,	## Clock speed is affected at random intervals.
	"too_many_heartbeats": false,	## Sometimes a pulse jockey. Sometimes people are just weird.
	"second_presence": false,	## Feels like someone else is around.
	"ineplicable_phenomena": false,	## Something's wrong.
	"manifesting_aura": false,	## A forboding aura emanates. A lingering spirit?
}
#@export var strange_growths: bool	## Can be benign.
#@export var averse_to_light: bool	## Usually nothing. Can be a shadowhiker.
#@export var time_dilation: bool	## Clock speed is affected at random intervals.
#@export var too_many_heartbeats: bool	## Sometimes a pulse jockey. Sometimes people are just weird.
#@export var second_presence: bool	## Feels like someone else is around.
#@export var ineplicable_phenomena: bool	## Something's wrong.
#@export var manifesting_aura: bool	## A forboding aura emanates. A lingering spirit?


func _ready() -> void:
	dialogue_state["client_name"] = client_name
	dialogue_state["client_age"] = client_age
	dialogue_state["client_job"] = client_job
	dialogue_state["travel_reason"] = travel_reason
	dialogue_state["personality_type"] = personality_type
	dialogue_state["threat_type"] = threat_type
