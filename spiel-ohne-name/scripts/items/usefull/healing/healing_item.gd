class_name healing_item extends use_item

func update_ui() -> void:
	var healthbar:Healthbar
	if user.get("healthbar"):
		healthbar = user.healthbar
		healthbar.update()
