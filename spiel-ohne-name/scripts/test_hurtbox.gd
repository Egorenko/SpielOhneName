#tutorial by Queble
#https://www.youtube.com/watch?v=cX-vzfmzjnE
class_name Hurtbox extends Area2D

@onready var health:int = owner.health

func _ready() -> void:
	monitoring = false
	
	set_collision_mask_value(1, false)
	set_collision_layer_value(1, true)

func take_damage(damage:int) -> void:
	health -= damage
	print(get_parent().name, health)
	if health <= 0:
		print(get_parent().name, " is dead")
		self.get_parent().queue_free()
