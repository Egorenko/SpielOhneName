extends CharacterBody2D
class_name Enemy

@export var speed := 50.0
@export var attack_range := 50.0
@export var attack_cooldown := 1.0
@export var damage := 10

var health : int = 10 

var player: Node = null
var can_attack := true

func _ready():
	player = get_tree().get_first_node_in_group("player")
	if not player:
		push_warning("Kein Player in Gruppe 'player' gefunden!")

func _physics_process(delta):
	if not player:
		return

	var dir = (player.global_position - global_position)
	var distance = dir.length()

	if distance > attack_range:
		velocity = dir.normalized() * speed
	else:
		velocity = Vector2.ZERO
		_attack_player()

	move_and_slide()


func _attack_player():
	if not can_attack:
		return


	if player.has_method("take_damage"):
		player.take_damage(damage)

	can_attack = false
	await get_tree().create_timer(attack_cooldown) 
	can_attack = true
