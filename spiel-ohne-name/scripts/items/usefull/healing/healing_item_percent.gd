class_name healing_item_percent extends healing_item
##From 100.0 to 0.0
@export var healing_percent:float = 0.0

func use() -> void:
	user.stats.health.increase_hp(user.stats.health.get_max_hp() * healing_percent / 100.0)
	update_ui()
