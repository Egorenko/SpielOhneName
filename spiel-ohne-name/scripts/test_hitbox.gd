#tutorial by Queble
#https://www.youtube.com/watch?v=cX-vzfmzjnE
class_name Hitbox extends Area2D

var damage:int
var hitbox_lifetime:float #?
var shape:Shape2D
var hit_log:HitLog

#constructor?
func _init(_damage:int, _hitbox_lifetime:float, _shape:Shape2D, _hit_log:HitLog = null) -> void:
	damage = _damage
	hitbox_lifetime = _hitbox_lifetime
	shape = _shape
	hit_log = _hit_log#=null -> doesn't have do be used

#see if hit?
func _ready() -> void:
	monitorable = false #only needs to see what it can damage / does not need to be seen
	area_entered.connect(_on_area_entered)
	
	if hitbox_lifetime > 0.0:
		var timer = Timer.new()
		add_child(timer)
		timer.timeout.connect(queue_free)
		timer.call_deferred("start", hitbox_lifetime)
	
	if shape:
		var collision_shape = CollisionShape2D.new()
		collision_shape.shape = shape
		add_child(collision_shape)
	
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	
	set_collision_mask_value(1, true)

#do when hit
func _on_area_entered(area:Area2D) -> void:
	if self.scene_file_path == area.scene_file_path:
		return
	
	if not area.has_method("take_damage"):#equals "check if hurtbox"
		return
	var hurtbox_owner = area.owner
	if hit_log:
		print(hit_log.hit_log)
		if hit_log.has_hit(hurtbox_owner):
			return #ignore if already hit
		else:
			hit_log.log_hit(hurtbox_owner)
	area.take_damage(damage)
