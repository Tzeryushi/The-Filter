class_name ClientResource
extends Resource


enum Personality {NORMAL = 0, GRUMPY = 1, IMPATIENT = 2, QUIET = 3, STOIC = 4, DERANGED = 5, ENTHUSIASTIC = 6, LIAR = 7,}
enum Threat {
	SAFE = 0, OVERSYMPTOMATIC = 1, SHADOWHIKER = 2, FLESHRIDER = 3, DOPPELGANGER = 4,
	PULSEJOCKEY = 5, CHRONOMONON = 6, LINGERING_SPIRIT = 7, UNKNOWN = 8}

@export var client_name: String
@export var client_age: int
@export var client_profession: String
@export var travel_reason: String
@export var personality_type: Personality
@export var threat_type: Threat

@export var dialogue : JSON
#@export var model
#@export var skin

# SOME levels of symptoms are okay. Too many indicates a predator.

@export_group("Benign Symptoms")
@export var forgetful: bool	## Affects dialogue, forgets details like name, age, background and trip reason
@export var headache: bool	## Will complain about headache.
@export var irrational: bool	## Will bring up non-sequitirs, ignore questions
@export var nauseated: bool	## Will bring up nausea.
@export var manifesting_aura: bool	## A forboding aura emanates. A lingering spirit?
@export var unresponsive: bool	## Ignores questions. Never a good sign.
@export var averse_to_light: bool	## Usually nothing. Can be a shadowhiker.
@export var time_dilation: bool	## Clock speed is affected at random intervals.
@export var too_many_heartbeats: bool	## Sometimes a pulse jockey. Sometimes people are just weird.
@export var strange_growths: bool	## Can be benign.
@export var hallucinating: bool	## Answers questions you didn't ask.
@export var too_polite: bool	## Can't trust this guy.
@export var encountered_entity: bool	## I seen it I swears
@export var second_presence: bool	## Feels like someone else is around.
@export var ineplicable_phenomena: bool	## Something's wrong.
