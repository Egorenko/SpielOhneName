class_name Attack extends Node2D

@onready var owner_stats:entity_stats = owner.stats
@export var stats:attack_stats

var damage:int = 0
var cooldown:float = 0.0
var attack_time:float = 1.0
var hitbox:pHitbox = pHitbox.new()
var hitbox_shape:CollisionShape2D = CollisionShape2D.new()
var animation:Animation
var weapon:Sprite2D = Sprite2D.new()
var offset:Vector2
var sprite_rot:float
var hitbox_rotation:float
var rot:float

var effect:Array[effects]

var animator:AnimationPlayer = AnimationPlayer.new()

func _ready() -> void:
	weapon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	weapon.z_index = -1
	
	if stats:
		damage = stats.damage
		cooldown = stats.cooldown
		attack_time = stats.attack_time
		hitbox_shape.shape = stats.hitbox
		animation = stats.anim
		weapon.texture = stats.weapon
		offset = stats.offset
		sprite_rot = stats.sprite_rotation
		hitbox_rotation = stats.hitbox_rotation
		rot = stats.rotation
	#prepare hitbox
	add_child(hitbox)
	hitbox.owner = self.get_parent()
	hitbox.add_child(hitbox_shape)
	hitbox.off()
	hitbox.rotate(hitbox_rotation)
	#prepare sprite
	add_child(weapon)
	weapon.visible = false
	move_attack(offset)
	weapon.rotate(sprite_rot)
	
	rotate_attack(rot)

func make_invisible()->void:
	weapon.visible = false

func attack() -> void:
	hitbox.attack(damage * owner_stats.damage, attack_time, effect, cooldown)
	print(weapon.visible)
	weapon.visible = true
	print(weapon.visible)
	var help:Timer = Timer.new()
	add_child(help)
	help.one_shot = true
	help.timeout.connect(make_invisible)
	help.call_deferred("start", attack_time)
	
	'var a_name = anim.find_animation(animation)
	anim.current_animation = a_name
	anim.speed_scale = anim.current_animation_length / attack_time
	anim.play(a_name)'

func move_attack(vec_from_owner:Vector2) -> void:
	weapon.position += vec_from_owner
	hitbox.position += vec_from_owner

func rotate_attack(_rot:float) -> void:
	weapon.rotate(_rot)
	hitbox.rotate(_rot)

func _process(_delta: float) -> void:
	'if not anim.is_playing():
		weapon.visible = false'
	#turn off if hitbox off
	'if hitbox.monitoring == false and hitbox.monitorable == false:
		weapon.visible = false'
	pass

func add_effect(_effect) -> void:
	if _effect is not Array:
		_effect = [_effect]
	effect.append_array(_effect)
	effect.sort_custom(func(a,b): return a.priority > b.priority)

func delete_effect_front() -> void:
	effect.pop_front()

func delete_effect_back() -> void:
	effect.pop_back()
