extends Cooldown_Area
class_name Interact_Area

##In seconds. If _lifetime is < 0.0, the lifetime is infinite until activated again.
func interact(_lifetime = null, _cooldown = null) -> void:
	if _lifetime and (_lifetime is float or _lifetime is int):
		lifetime = _lifetime
	if lifetime < 0.0:
		on()
	
	if _cooldown and (_cooldown is float or _cooldown is int):
		cooldown = _cooldown
	if cooldown < 0.0:
		pass
	
	if not cooldown_over:
		print("on cooldown")
		return
	
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
	pass

func _on_area_entered(area:Area2D) -> bool:
	'if self.owner == area.owner:
		return false'
	if not area.has_method("interact_"):
		return false
	area.interact_(self.owner)
	return true
