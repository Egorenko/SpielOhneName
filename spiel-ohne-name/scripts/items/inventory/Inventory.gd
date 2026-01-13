class_name Inventory extends Resource

@export var items:Array[Inventory_stack]

func ready() -> void:
	for i in range(items.size()):
		if not items[i]:
			items[i] = Inventory_stack.new()

func add_item(new_item:Inventory_item) -> void:
	var added:bool = false
	var _1st_empty_pos:int = -1
	#go from end(size()-1) to start(exclusive)(-1 left) in direction negative by 1(-1 right)
	for i in range(items.size()-1, -1, -1):
		if not items[i].item:
			_1st_empty_pos = i
		#search for not full stacks of same item
		if items[i] and not items[i].is_full() and items[i].item == new_item:
			'print(items[i].current_stack, " / ", items[i].stack_max)'
			items[i].increase_stack(new_item)
			added = true
			break
	#if no stack found, use new stack
	if not added and _1st_empty_pos != -1:
		items[_1st_empty_pos].item = new_item
		items[_1st_empty_pos].stack_max = new_item.stack_size
		items[_1st_empty_pos].current_stack = 1

func take_item(search_item:Inventory_item) -> void:
	var found:bool = false
	#search for stacks of same item
	for el:Inventory_stack in items:
		if el.item == search_item:
			el.decrease_stack()
			if el.current_stack <= 0:
				el.item = null
			found = true
			break
	if not found:
		print("not found")

func move_item(from:int, to:int) -> void:
	var help:Inventory_stack = items[from]
	items[from] = items[to]
	items[to] = help
