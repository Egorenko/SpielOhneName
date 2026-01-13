class_name Pick_up_item extends CharacterBody2D

#TODO add Item (resource?)
@export var item:Inventory_stack

func _ready() -> void:
	$Sprite2D.texture = item.item.texture

func on_interact(activator:Node) -> void:
	#TODO load Item in Inventory
	'var inv:Inventory = Inventory.new()
	inv.add_item(item)'
	if activator.get("inventory"):
		for i in range(item.current_stack):
			activator.inventory.add_item(item.item)
			item.decrease_stack()
	if activator.get("inventory_ui"):
		activator.inventory_ui.update_slots()
	queue_free()
	pass
