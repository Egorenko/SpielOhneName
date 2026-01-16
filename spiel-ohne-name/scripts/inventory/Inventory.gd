extends Resource
class_name Inventory 

@export var items:Array[Inventory_stack]
var full:bool = false

func ready() -> void:
	for i in range(items.size()):
		if not items[i]:
			items[i] = Inventory_stack.new()

func add_stack(new_stack:Inventory_stack) -> void:
	while new_stack.item != null:
			if not add_item(new_stack.item):
				print("can't adda all of stack")
				break
			new_stack.decrease_stack()

##returns if item could be added
func add_item(new_item:Inventory_item) -> bool:
	var _1st_empty_pos:int = -1
	#go from end(size()-1) to start(exclusive)(-1 left) in direction negative by 1(-1 right)
	for i in range(items.size()-1, -1, -1):
		if not items[i].item:
			_1st_empty_pos = i
		#search for not full stacks of same item
		if items[i] and not items[i].is_full() and items[i].item == new_item:
			'print(items[i].current_stack, " / ", items[i].stack_max)'
			items[i].increase_stack(new_item)
			#cancel if added
			return true
	#if no stack found, use new stack
	if _1st_empty_pos != -1:
		print("new stack")
		items[_1st_empty_pos].item = new_item
		items[_1st_empty_pos].stack_max = new_item.stack_size
		items[_1st_empty_pos].current_stack = 1
		#cancel if new added
		return true
	#if no where added
	return false

##returns if item taken
func take_item(search_item:Inventory_item) -> bool:
	#search for stacks of same item
	for el:Inventory_stack in items:
		if el.item == search_item:
			el.decrease_stack()
			if el.current_stack <= 0:
				el.item = null
				#cancle if found and taken
			return true
	print("not found")
	return false

func move_item(from:int, to:int) -> void:
	var help:Inventory_stack = items[from]
	items[from] = items[to]
	items[to] = help

func is_full() -> bool:
	return full

func test_fullness() -> void:
	full = true
	#only test until one stack has room
	for el:Inventory_stack in items:
		if not el.is_full():
			full = false
			break
