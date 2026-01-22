extends Quest
class_name Quest_item_give

@export var Quest_items:Array[Quest_item]
@export var Item_count_total:int = 0

func test_item(test:Inventory_item) -> bool:
	for el in Quest_items:
		if el == test:
			Item_count_total -= 1
			clamb()
			return true
	return false

func clamb() -> void:
	if Item_count_total <= 0:
		Item_count_total = 0
		on_compleation()

func on_compleation() -> void:
	print("Complete!")
