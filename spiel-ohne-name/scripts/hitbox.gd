extends Cooldown_Area
class_name pHitbox 


var damage:int
var effect:Array[effects]

func attack(_damage:int, hitbox_lifetime = null, _cooldown = null, _effect = null) -> void:
	damage = _damage
	if hitbox_lifetime and hitbox_lifetime is float:
		lifetime = hitbox_lifetime
	
	if _cooldown and _cooldown is float:
		cooldown = _cooldown
	else:
		cooldown = 0.0
	
	#=========================_W_I_P_==========================================#
	if _effect:
		if _effect is not Array:
			_effect = [_effect] 
		if _effect is Array[effects]:
			effect = _effect
	#=========================_W_I_P_==========================================#
	
	if not cooldown_over:
		#print("still on cooldown")
		return
	
	#print("attack")
	
	#is active as long as
	if lifetime > 0.0:
		on()
		var timer = Timer.new()
		add_child(timer)
		timer.one_shot = true
		#IDEA 'off' starts cooldown
		timer.timeout.connect(off)
		timer.call_deferred("start", lifetime)
	
	#unable to activate as long as
	if cooldown > 0.0:
		#only start if exist
		cooldown_start()
		var ctimer = Timer.new()
		add_child(ctimer)
		ctimer.one_shot = true
		ctimer.timeout.connect(cooldown_end)
		ctimer.call_deferred("start", cooldown)

#do when hit
func _on_area_entered(area:Area2D) -> bool:
	if self.owner == area.owner:
		print("CAN'T HIT IT SELF")
		return false
	#print(self.owner)
	#print(area.owner)
	if not area.has_method("take_damage"):#equals "check if hurtbox"
		return false
	print(area.owner, " got hit")
	area.take_damage(damage)
	'if effect:
		area.take_damage(effect)'
	return true
