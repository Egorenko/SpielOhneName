class_name hitbox_and_hurtbox extends Area2D

#-------------------------------------------------------------------------------hitbox
@export var damage:int = 1 : set = set_damage, get = get_damage

func set_damage(value:int):
	damage = value

func get_damage() -> int:
	return damage

#-------------------------------------------------------------------------------hurtbox

signal take_damage(damage:int)

@export var health:int = 1
