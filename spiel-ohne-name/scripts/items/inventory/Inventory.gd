class_name Inventory extends Resource

@export var items:Array[Inventory_stack]

func add_item(new_item:Inventory_item) -> void:
	for el:Inventory_stack in items:
		if 
	var stack:Inventory_stack = Inventory_stack.new()
	stack.item = new_item
	items.push_back(stack)
