class_name Healthbar extends ProgressBar


func _ready() -> void:
	
	show_percentage = false
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_theme_stylebox_override("background", load("res://assets/healthbar1_outer.tres"))
	add_theme_stylebox_override("fill", load("res://assets/healthbar1_inner.tres"))
	size = Vector2(72.0, 16.0)
	scale = Vector2(0.25, 0.25)
	position = Vector2(-9.0, -14.0)
	
	if not owner:
		owner = get_parent()
	if owner.get("stats") and owner.stats is entity_stats:
		max_value = owner.stats.health.get_max_hp()
		value = owner.stats.health.get_hp()
	else:
		print("no stats for healtbar")
	pass
	

func update() -> void:
	if owner.stats.health.got_changed():
		max_value = owner.stats.health.get_max_hp()
		value = owner.stats.health.get_hp()
	pass
