extends Node2D
class_name Attack 

@onready var owner_stats:entity_stats = owner.stats

var hitbox:pHitbox = pHitbox.new()
var hitbox_shape:CollisionShape2D = CollisionShape2D.new()
var weapon:Sprite2D = Sprite2D.new()

var effect:Array[effects]
#var animation:Animation
#var animator:AnimationPlayer = AnimationPlayer.new()

func _ready() -> void:
	hitbox.add_child(hitbox_shape)
	add_child(hitbox)
	hitbox.owner = owner
	
	add_child(weapon)

func load_stats(stats:attack_stats) -> void:
	#animation = stats.anim
	
	#prepare hitbox
	hitbox.position = Vector2(0.0, 0.0)
	hitbox.rotation = 0.0
	hitbox_shape.shape = stats.hitbox
	hitbox.off()
	hitbox.rotate(stats.hitbox_rotation)
	
	#prepare sprite
	weapon.position = Vector2(0.0, 0.0)
	weapon.rotation = 0.0
	weapon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	weapon.z_index = -1
	weapon.texture = stats.weapon
	weapon.rotate(stats.sprite_rotation)
	weapon.visible = false
	
	move_attack(stats.offset)
	rotate_attack(stats.rotation)

func make_invisible()->void:
	weapon.visible = false

func attack(stats:attack_stats) -> void:
	load_stats(stats)
	hitbox.attack(stats.damage * owner_stats.damage, stats.attack_time, effect, stats.cooldown)
	weapon.visible = true
	var help:Timer = Timer.new()
	add_child(help)
	help.one_shot = true
	help.timeout.connect(make_invisible)
	help.call_deferred("start", stats.attack_time)
	
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

'func _process(_delta: float) -> void:
	if not anim.is_playing():
		weapon.visible = false
	#turn off if hitbox off
	if hitbox.monitoring == false and hitbox.monitorable == false:
		weapon.visible = false
	pass

func add_effect(_effect) -> void:
	if _effect is not Array:
		_effect = [_effect]
	effect.append_array(_effect)
	effect.sort_custom(func(a,b): return a.priority > b.priority)

func delete_effect_front() -> void:
	effect.pop_front()

func delete_effect_back() -> void:
	effect.pop_back()'
