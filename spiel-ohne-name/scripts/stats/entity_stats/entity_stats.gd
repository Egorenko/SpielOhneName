class_name entity_stats extends Resource

@export var health:Health
##should be base
##TODO make Type = Damage
@export var damage:int
##in seconds, until next attack, after key press
@export var cooldown:float
##Movement speed * delta, original SPEED
##Has ro be about 10-times SPEED
@export var speed:int
##Time the attack animation takes * attack_speed
##>1 -> slow; <1 -> fast; <0 -> fast too (?)
@export var attack_speed:float
