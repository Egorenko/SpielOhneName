extends CharacterBody2D
class_name Chest 

var contains:PackedScene = preload("res://scenes/pick_up_item.tscn")
@export var items:Loot_Table

func _ready() -> void:
	items.ready()

func on_interact(_activator:Node) -> void:
	open()
	spawn_item()

#change from atlas to region_rect
#because changeing position on atlas is done everywhere
func open() -> void:
	$Sprite2D.region_rect = Rect2(16.0, 0.0, 16.0, 16.0)

func spawn_item() -> void:
	var item_pos:Vector2 = Vector2(position.x + randi_range(-20, 20), position.y + randi_range(-20, 20))
	var item := contains.instantiate()
	item.position = item_pos
	
	item.item = items.choose_item()
	get_tree().root.call_deferred("add_child", item)
