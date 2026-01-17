#extends CharacterBody2D
extends entity
class_name Enemy
#@export var stats:entity_stats
@export var attack_range = 50.0
@onready var agent := $NavigationAgent2D
@export var items:Loot_Table
var pick_up_item:PackedScene = preload("res://scenes/pick_up_item.tscn")


var player: Node = null
var can_attack := true

func _ready():
	agent.navigation_layers = 0
	items.ready()
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
	$attack.attack(attacks[0])


func on_death():
	$AnimationPlayer.play("ritter_death")
	spawn_item()
	queue_free()

func spawn_item() -> void:
	var item_pos:Vector2 = Vector2(position.x + randi_range(-20, 20), position.y + randi_range(-20, 20))
	items.choose_item().on_drop(item_pos, self, pick_up_item)
