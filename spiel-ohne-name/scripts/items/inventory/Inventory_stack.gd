class_name Inventory_stack extends Resource

@export var item:Inventory_item
@export var stack_max:int = 1
@export var current_stack:int = 0

func increase_stack(new_item:Inventory_item) -> void:
	if new_item == item:
		current_stack += 1
	clamb()

func decrease_stack() -> void:
	current_stack -= 1
	clamb()

func clamb() -> void:
	current_stack = stack_max if current_stack > stack_max else current_stack
	

func is_full() -> bool:
	return current_stack == stack_max

func on_empty() -> void:
	pass
