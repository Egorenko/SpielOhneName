class_name attack_stats extends Resource

##Basedamage * (this)damage = damage dealt
@export var damage:int
##Starts by attacking
##If cooldown < attacktime -> spamable
@export var cooldown:float
##Time the hitbox is active 
@export var attack_time:float

@export var hitbox:Shape2D

##TODO
@export var anim:Animation

##Weapon-Sprite (diagonal)
@export var weapon:CompressedTexture2D
@export var offset:Vector2
@export var sprite_rotation:float
@export var hitbox_rotation:float
@export var rotation:float
