##abstract Every entity has room for stats, inventory, and Array of attack_stats
extends CharacterBody2D
class_name entity 

@export var stats:entity_stats
@export var inventory:Inventory
@export var attacks:Array[attack_stats]
