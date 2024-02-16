class_name InteractionVolume
extends Node3D
## Area that can pass information through collisions
##
## Can pass text (or not), contains an abstract signal that can be linked
## to a parent node for functionality (like a door being opened, an item being
## picked up, or a NPC interacted with)


signal interacted(interacting_body)

@export var interaction_text: String = "Interact With"
