extends equipable_item
class_name weapon_item

@export var attacks:Array[attack_stats]
#WIP
var last_attacks:Array[attack_stats]

func use() -> void:
	if is_equiuped:
		deequip()
	else:
		equip()

func equip() -> void:
	last_attacks.resize(attacks.size())
	for i in range(attacks.size()):
		if attacks[i]:
			last_attacks[i] = user.attacks[i] 
			user.attacks[i] = attacks[i]
	pass

func deequip() -> void:
	for i in range(last_attacks.size()):
		user.attacks[i] = last_attacks[i]
	pass
