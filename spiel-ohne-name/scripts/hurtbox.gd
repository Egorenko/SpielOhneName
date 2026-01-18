extends Area2D
class_name Hurtbox

var has_healthbar:bool = false
var owner_healthbar:Healthbar
#var effect:Array[effects]

#actually no clue what that does
func _ready() -> void:
	monitoring = false#?
	set_collision_mask_value(1, false)#?
	set_collision_layer_value(1, true)#?
	
	#uses heathbar if existend
	if "healthbar" in owner:
		has_healthbar = true
	else:
		#if not existend searches in tree
		for node:Object in owner.get_children():
			if node is Healthbar:
<<<<<<< Updated upstream
				print(node.name)
				print(owner, " got new healthbar")
=======
				#print(owner, " found healthbar")
>>>>>>> Stashed changes
				owner_healthbar = node
				print(owner_healthbar)
				has_healthbar = true
				break
	'#if not "healthbar" not existend and no heltbar in tree -> create new
	if not healthbar:
		var help:Healthbar = Healthbar.new(self.owner)
		owner.add_child.call_deferred(help)
		#help.owner = owner
		owner_healthbar = help'

func on_hit(_damage:float) -> void:
	if owner.has_method("on_hit"):
		owner.on_hit()
	else:
		owner.stats.health.decrease_hp(_damage)
		if has_healthbar and owner.stats.health.got_changed():
			if owner_healthbar :
				owner_healthbar.update()
			else:
				owner.healthbar.update()
		#print(owner, ", has no on_hit")
	pass

func on_death() -> void:
	if owner.has_method("on_death"):
		owner.on_death()
	else:
		#print(owner, ", has no on_death")
		pass
	pass

##returns if object dead (true) or alife (false)
func take_damage(_damage:float) -> bool:
	on_hit(_damage)
	if "stats" in owner and owner.stats.health.is_dead():
		on_death()
		return true
	return false
'
	#==_W_I_P_==#
	#effects
	for el in effect:
		el.activate_effect()
#=====================================_W_I_P_==================================#

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
'
