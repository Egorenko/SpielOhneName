extends Node2D
class_name attack

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

var animator:AnimationPlayer = AnimationPlayer.new()

func _ready() -> void:
	
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

func attack() -> void:
	hitbox.attack(damage, attack_time, cooldown)
	weapon.visible = true
	
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
	if hitbox.monitoring == false and hitbox.monitorable == false:
		weapon.visible = false
