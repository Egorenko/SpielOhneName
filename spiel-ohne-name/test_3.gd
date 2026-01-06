extends CharacterBody2D
@export var stats:entity_stats 
var healthbar:Healthbar = Healthbar.new()

func _ready() -> void:
	
	add_child(healthbar)
	healthbar.owner = self

func on_interact() -> void:
	print("interact")

func on_death() -> void:
	$AnimationPlayer.play("char_body/death")
