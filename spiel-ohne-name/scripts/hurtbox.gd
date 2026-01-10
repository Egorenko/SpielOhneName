class_name Hurtbox extends Area2D

var effect:Array[effects]

var healthbar:Healthbar

#actually no clue what that does
func _ready() -> void:
	monitoring = false#?
	set_collision_mask_value(1, false)#?
	set_collision_layer_value(1, true)#?
	
	#uses heathbar if existend
	if owner.get("healthbar"):
		print("has healthbar")
		healthbar = owner.healthbar
	else:
		#if not existend searches in tree
		for node:Object in owner.get_children():
			if node is Healthbar:
				print("new healthbar")
				healthbar = node
				break
	#if not "healthbar" not existend and no heltbar in tree -> create new
	if not healthbar:
		var help:Healthbar = Healthbar.new()
		owner.add_child.call_deferred(help)
		#help.owner = owner
		healthbar = help

func on_death() -> void:
	if owner.has_method("on_death"):
		owner.on_death()
	print(owner, " is dead")
	pass

##returns if object dead (true) or alife (false)
func take_damage(_damage:float) -> bool:
	#unsure
	owner.stats.health.decrease_hp(_damage)
	if owner.stats.health.got_changed():
		healthbar.update()
	print(owner.stats.health.hp)
	#print(get_parent().name, owner_stats.health.get_hp())
	if owner.stats.health.is_dead():
		on_death()
		return true
	return false
	
	'#==_W_I_P_==#'
	#effects
	for el in effect:
		el.activate_effect()
'#=====================================_W_I_P_==================================#'

##WIP
func add_effect(_effect) -> void:
	if _effect is not Array:
		_effect = [_effect]
	if _effect is Array[effects]:
		effect.append_array(_effect)
	effect.sort_custom(func(a,b): return a.priority > b.priority)

##WIP
func delete_effect_front() -> void:
	effect.pop_front()

##WIP
func delete_effect_back() -> void:
	effect.pop_back()
