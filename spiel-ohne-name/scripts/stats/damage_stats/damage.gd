class_name Damage extends Resource

@export var _damage:float = 0.0
@export var crit_rate:float = 0.0
@export var crit_mult:float = 1.0

func get_damage() -> float:
	return  _damage * crit_mult if randf() < crit_rate else _damage
