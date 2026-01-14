##abstract Every entity has room for stats, inventory, and Array of attack_stats
class_name entity extends CharacterBody2D

@export var stats:entity_stats
@export var inventory:Inventory
@export var attacks:Array[attack_stats]
