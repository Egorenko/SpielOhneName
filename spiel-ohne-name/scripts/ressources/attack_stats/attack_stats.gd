extends Resource
class_name attack_stats

@export var damage:int
##Starts by attacking
##If cooldown < attacktime -> spamable
@export var cooldown:float
##Time (in %) of the original animation-time
@export var attack_time:float
@export var hitbox:Shape2D
@export var anim:Animation
@export var weapon:Texture2D
