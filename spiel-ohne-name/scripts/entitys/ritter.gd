extends CharacterBody2D
class_name Enemy
@export var stats:entity_stats
@export var attack_range = 50.0


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
		velocity = dir.normalized() * stats.speed
	else:
		velocity = Vector2.ZERO
		_attack_player()

	move_and_slide()


func _attack_player():
	$thrust_attack.attack()

func on_death():
	$AnimationPlayer.play("Enemy/death")
	queue_free()
