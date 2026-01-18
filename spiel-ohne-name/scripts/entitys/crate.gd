extends CharacterBody2D
class_name crate 

var pick_up_item:PackedScene = preload("res://scenes/pick_up_item.tscn")
@export var items:Loot_Table
@export var hits:int = 1

func _ready() -> void:
	add_to_group("item")
	items.ready()

func on_hit() -> void:
	hits -= 1
	if hits <= 0:
		destroy()

func destroy() -> void:
	spawn_item()
	queue_free()

func spawn_item() -> void:
	var item_pos:Vector2 = Vector2(position.x + randi_range(-20, 20), position.y + randi_range(-20, 20))
	items.choose_item().on_drop(item_pos, self, pick_up_item)
