extends NPC
class_name wip_NPC1

func on_interact(activator:Node) -> void:
	print("talk to ", self)
	if "inventory" in activator:
		for el in Quests:
			if el is Quest_item_give:
				for el_ in el.Quest_items:
					if activator.inventory.take_item(el_):
						activator.inventory_ui.update_slots()
						el.test_item(el_)
						print("Thanks!")
					else:
						print("You don't have anything for me.")
	pass
