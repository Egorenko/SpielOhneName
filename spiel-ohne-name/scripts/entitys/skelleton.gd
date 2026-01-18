#extends Enemy
extends entity
class_name PatrolEnemy

@export var patrol_radius := 100.0
var start_position := Vector2.ZERO
var patrol_target := Vector2.ZERO
#@export var stats:entity_stats
var player = null
var attack_range = 30.0
@export var items:Loot_Table
var pick_up_item:PackedScene = preload("res://scenes/pick_up_item.tscn")


func _ready():
	add_to_group("enemy")
	items.ready()
	player = get_tree().get_first_node_in_group("player")
	if not player:
		push_warning("Kein Player in Gruppe 'player' gefunden!")
	start_position = global_position
	_set_new_patrol_point()

func _physics_process(delta):
	if not player:
		return

	var to_player = player.global_position - global_position
	var distance_to_player = to_player.length()

	# Verhalten abhängig vom Abstand
	if distance_to_player <= attack_range:
		_attack_player()
	elif distance_to_player <= 200.0:
		velocity = to_player.normalized() * stats.speed
	else:
		# Patrouille
		var to_patrol = patrol_target - global_position
		if to_patrol.length() < 5.0:
			_set_new_patrol_point()
		else:
			velocity = to_patrol.normalized() * stats.speed

	move_and_slide()

func _set_new_patrol_point():
	var angle = randf() * PI * 2
	var radius = randf() * patrol_radius
	patrol_target = start_position + Vector2(cos(angle), sin(angle)) * radius

func _attack_player():
	$attack.rotation = position.angle_to_point(player.position)
	$attack.attack(attacks[0])

func on_death():
	$AnimationPlayer.play("ritter_death")
	spawn_item()
	queue_free()

func spawn_item() -> void:
	var item_pos:Vector2 = Vector2(position.x + randi_range(-20, 20), position.y + randi_range(-20, 20))
	items.choose_item().on_drop(item_pos, self, pick_up_item)
