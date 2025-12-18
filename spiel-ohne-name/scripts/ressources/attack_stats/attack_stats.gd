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
@export var weapon:CompressedTexture2D
@export var offset:Vector2
@export var sprite_rotation:float
@export var hitbox_rotation:float
@export var rotation:float
