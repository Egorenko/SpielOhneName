extends ProgressBar 
class_name Healthbar

func default() -> void:
	#default
	show_percentage = false
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	z_index = 1
	add_theme_stylebox_override("background", load("res://assets/healthbar1_outer.tres"))
	add_theme_stylebox_override("fill", load("res://assets/healthbar1_inner.tres"))
	#size = Vector2(72.0, 16.0)
	#position = Vector2(-9.0, -21.0)
	scale = Vector2(0.25, 0.25)

func _ready() -> void:
	if not owner:
		owner = get_parent()
		print("owner: ", owner)
	if "stats" in owner:
		max_value = owner.stats.health.get_max_hp()
		value = owner.stats.health.get_hp()
		update()
	else:
		print("no stats for healtbar")
	pass
	

func update() -> void:
	max_value = owner.stats.health.get_max_hp()
	value = owner.stats.health.get_hp()
