extends CharacterBody2D
class_name Pick_up_item 

#TODO add Item (resource?)
@export var item:Inventory_stack = Inventory_stack.new()

func _ready() -> void:
	if item.item:
		$Sprite2D.texture = item.item.texture
	else:
		print("empty stack")

func on_interact(activator:Node) -> void:
	if activator.get("inventory"):
		activator.inventory.add_stack(item)
	if activator.get("inventory_ui"):
		activator.inventory_ui.update_slots()
	queue_free()
	pass
