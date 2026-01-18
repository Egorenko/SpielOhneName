extends CharacterBody2D
class_name Chest 

var pick_up_item:PackedScene = preload("res://scenes/pick_up_item.tscn")
@export var items:Loot_Table = preload("res://scripts/loottables/chest1.tres")

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
	items.choose_item().on_drop(item_pos, self, pick_up_item)
