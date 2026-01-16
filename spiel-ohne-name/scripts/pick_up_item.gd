extends CharacterBody2D
class_name Pick_up_item 

#TODO add Item (resource?)
@export var stack:Inventory_stack = Inventory_stack.new()

func _ready() -> void:
	if stack.item:
		$Sprite2D.texture = stack.item.texture
	else:
		print("empty stack")

func on_interact(activator:Node) -> void:
	if "inventory" in activator:
		activator.inventory.add_stack(stack)
	if "inventory_ui" in activator:
		activator.inventory_ui.update_slots()
	#if stack empty
	if not stack.item:
		queue_free()
	pass
