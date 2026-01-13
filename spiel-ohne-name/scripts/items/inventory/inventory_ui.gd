class_name Inventory_ui extends Control

@onready var inv:Inventory = owner.inventory
@onready var slots:Array[Node] = $backround/GridContainer.get_children()

var is_open:bool = false
var mouse_inside:bool = false
var selected_slot:Inventory_ui_slot = null

func _input(event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and mouse_inside:
		print(selected_slot.index)

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
	#bind panel to index
	for i in range(min(inv.items.size(), slots.size())):
		slots[i].update(inv.items[i])

func close() -> void:
	visible = false
	is_open = false

func open() -> void:
	visible = true
	is_open = true

func inside() -> void:
	mouse_inside = true
	print("in inventory")

func outside() -> void:
	mouse_inside = false
	print("outside inventory")
