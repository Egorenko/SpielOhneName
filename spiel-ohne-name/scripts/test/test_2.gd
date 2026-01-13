extends CharacterBody2D

@export var stats:entity_stats = preload("res://scripts/ressources/entity_stats/test_player_stats.tres")

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB"):
		$AnimationPlayer.play("char_body/death")
		pass
	if event.is_action_pressed("RMB"):
		$AnimationPlayer.play("char_body/appear")
		pass

func _physics_process(_delta: float) -> void:
	pass
