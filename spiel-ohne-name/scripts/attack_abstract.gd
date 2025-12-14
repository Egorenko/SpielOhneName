extends Node2D
class_name attack

@export var stats:attack_stats
var damage:int = 0
var cooldown:float = 0.0
var attack_time:float = 1.0
var hitbox:pHitbox
var animation:Animation
var weapon:Sprite2D

var anim:AnimationPlayer = AnimationPlayer.new()

func _ready() -> void:
	hitbox = $pHitbox
	
	if stats:
		damage = stats.damage
		cooldown = stats.cooldown
		attack_time = stats.attack_time
		hitbox.shape = stats.hitbox
		animation = stats.anim
		weapon.texture = stats.weapon
	
	#anim.add_child(hitbox)
	add_child(anim)
	#weapon.visible = false

func attack() -> void:
	hitbox.attack(attack_time)
	#weapon.visible = true
	
	var a_name = anim.find_animation(animation)
	anim.current_animation = a_name
	anim.speed_scale = anim.current_animation_length / attack_time
	anim.play(a_name)

func _process(_delta: float) -> void:
	'if not anim.is_playing():
		weapon.visible = false'
