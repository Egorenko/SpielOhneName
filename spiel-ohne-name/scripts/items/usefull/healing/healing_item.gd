extends use_item
class_name healing_item 

func update_ui() -> void:
	if "healthbar" in user:
		user.healthbar.update()
