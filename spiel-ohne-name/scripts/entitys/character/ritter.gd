#extends CharacterBody2D
extends entity
class_name Enemy
#@export var stats:entity_stats
@export var attack_range = 50.0
@onready var agent := $NavigationAgent2D
@export var items:Loot_Table
var pick_up_item:PackedScene = preload("res://scenes/pick_up_item.tscn")

var player_: Node = null
var can_attack := true

func _ready():
	add_to_group("enemy")
	agent.navigation_layers = 0
	items.ready()
	if get_tree().get_first_node_in_group("player"):
		player_ = get_tree().get_first_node_in_group("player")
	#if not player_:
	#	push_warning("Kein Player in Gruppe 'player' gefunden!")

@onready var new_texture:AtlasTexture = $Sprite2D.texture as AtlasTexture

func _physics_process(delta):
	if not player_:
		return

	var dir = (player_.global_position - global_position)
	var distance = dir.length()

	if distance > attack_range:
		velocity = dir.normalized() * stats.speed
	else:
		velocity = Vector2.ZERO
		_attack_player()
	
	if velocity.y < 0:
		new_texture.region = Rect2(60.0, 5.0, 17.0, 22.0)
	elif velocity.y > 0:
		new_texture.region = Rect2(40.0, 5.0, 17.0, 22.0)
	elif velocity.x > 0:
		new_texture.region = Rect2(22.0, 5.0, 17.0, 22.0)
	elif velocity.x < 0:
		new_texture.region = Rect2(4.0, 5.0, 17.0, 22.0)
	move_and_slide()


func _attack_player():
	$attack.rotation = position.angle_to_point(player_.position)
	$attack.attack(attacks[0])

func on_hit(_damage:Damage, attacker:Node) -> void:
	#play hit animation
	$AnimationPlayer.play("hit")
	#knockback
	var attack_dir = position - attacker.position
	velocity = attack_dir.normalized() * _damage.knockback
	#move_and_slide()
	#damage
	stats.health.decrease_hp(_damage.get_damage())
	$healthbar.update()
	pass

func on_death():
	print("ritter dead")
	$AnimationPlayer.play("ritter_death")
	spawn_item()
	queue_free()

func spawn_item() -> void:
	var item_pos:Vector2 = Vector2(position.x + randi_range(-20, 20), position.y + randi_range(-20, 20))
	items.choose_item().on_drop(item_pos, self, pick_up_item)
