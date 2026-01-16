extends healing_item
class_name healing_item_flat 

@export var heal:float = 0.0

func use() -> void:
	user.stats.health.increase_hp(heal)
	update_ui()
