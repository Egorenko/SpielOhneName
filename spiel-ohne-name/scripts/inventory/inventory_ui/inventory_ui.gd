extends Control
class_name Inventory_ui

@onready var inv:Inventory = owner.inventory
@onready var slots:Array[Node] = $backround/GridContainer.get_children()

var is_open:bool = false
var mouse_inside:bool = false
var in_slot:Inventory_ui_slot = null
var selected_slot:Inventory_ui_slot = null

func _input(event: InputEvent) -> void:
	if not mouse_inside:
		self.modulate = Color(modulate[0], modulate[1], modulate[3], 0.392)
	else:
		self.modulate = Color(modulate[0], modulate[1], modulate[3], 1.0)
		if selected_slot and selected_slot.stack.item is use_item:
			if event.is_action_pressed(selected_slot.stack.item.key_string):
				selected_slot.stack.item.user = owner
				selected_slot.stack.item.use()
				print("use ", selected_slot.stack.item.name)
				selected_slot.stack.decrease_stack()
				update_slots()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if in_slot:
			if selected_slot:
				inv.move_item(selected_slot.index, in_slot.index)
				update_slots()
				if in_slot != selected_slot:
					reset_selection()
			elif in_slot.item_visual.visible:
				selected_slot = in_slot
				selected_slot.selected()
		else:
			reset_selection()

func reset_selection() -> void:
	if selected_slot:
		selected_slot.deselected()
	selected_slot = null

func _ready() -> void:
	mouse_entered.connect(inside)
	mouse_exited.connect(outside)
	for i in range(min(inv.items.size(), slots.size())):
		map_slots_to_index(i,i)
	inv.ready()
	update_slots()
	close()

func map_slots_to_index(slot_index:int, inventory_index:int) -> void:
	if slots[slot_index] is Inventory_ui_slot:
		slots[slot_index].index = inventory_index
		slots[slot_index].inventory = self

func update_slots() -> void:
	#if empty, reset selected_slot
	if selected_slot and selected_slot.stack.item == null:
		selected_slot.deselected()
		selected_slot = null
	#bind panel to index
	for i in range(min(inv.items.size(), slots.size())):
		slots[i].update(inv.items[i])

func close() -> void:
	mouse_inside = false
	in_slot = null
	if selected_slot:
		selected_slot.deselected()
	selected_slot = null
	visible = false
	is_open = false

func open() -> void:
	visible = true
	is_open = true

func inside() -> void:
	mouse_inside = true

func outside() -> void:
	mouse_inside = false
