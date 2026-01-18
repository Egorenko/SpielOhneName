extends CharacterBody2D
class_name bush1 

@export var items:Loot_Table# = preload("res://scripts/loottables/bush1.tres")
@export var max_fill:int = 0
@export var fill:int = 0
@export var spawn_time: float = 0.0
var spawn_timer:Timer = Timer.new()

func _ready() -> void:
	items.ready()
	add_child(spawn_timer)
	spawn_timer.timeout.connect(refill)
	if fill < max_fill:
		if fill < 0:
			fill = 0
		spawn_timer.start(spawn_time)
	else:
		fill = max_fill
	$Label.text = str(fill)

func on_interact(activator:Node) -> void:
	if fill <= 0:
		fill = 0
		print("nothing to collect")
		return
	for i in range(fill):
		var drop:Inventory_stack = items.choose_item()
		if "inventory" in activator:
			activator.inventory.add_stack(drop)
		if "inventory_ui" in activator:
			activator.inventory_ui.update_slots()
		$Label.text = str(fill)
	fill = 0
	spawn_timer.start(spawn_time)

func refill() -> void:
	#print("refill")
	if fill >= max_fill:
		fill = max_fill
		spawn_timer.stop()
	else:
		fill += 1
		$Label.text = str(fill)
