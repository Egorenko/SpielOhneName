class_name Chest extends CharacterBody2D

@export var contains:PackedScene = preload("res://scenes/item.tscn")

@onready var open:AtlasTexture = $Sprite2D.texture as AtlasTexture

func on_interact() -> void:
	open.region = Rect2(16.0, 0.0, 16.0, 16.0)
	$Sprite2D.texture = open
	var item_pos:Vector2 = Vector2(position.x + randi_range(-20, 20), position.y + randi_range(-20, 20))
	var item := contains.instantiate()
	item.position = item_pos
	
	get_tree().root.call_deferred("add_child", item)
