extends CharacterBody2D

var health = 10
var damage = 1
var cooldown = 0.0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB"):
		$attack.attack()
	if event.is_action_pressed("RMB"):
		var a = AnimationPlayer.new()
		add_child(a)
		a
		a.play()

func _physics_process(_delta: float) -> void:
	pass
