class_name Inventory_ui_slot extends Panel

@onready var item_visual:Sprite2D = $backround/CenterContainer/Panel/Item_dysplay
@onready var default_texture:Texture2D = $backround.texture
@onready var default_scale:Vector2 = $backround.scale
@onready var default_modulate:Color = $backround.modulate
var inventory:Inventory_ui = null
var index:int = -1
var mouse_in_slot:bool = false

func _ready() -> void:
	mouse_entered.connect(inside)
	mouse_exited.connect(outside)

func update(item_stack:Inventory_stack) -> void:
	if not item_stack.item:
		item_visual.visible = false
		$backround/text.visible = false
		$backround/text.text = str(0)
	else:
		item_visual.visible = true
		item_visual.texture = item_stack.item.texture
		
		if item_stack.item.stack_size > 1:
			$backround/text.visible = true
			$backround/text.text = str(item_stack.current_stack)

func inside() -> void:
	$backround.scale = default_scale * 1.2
	$backround.self_modulate = default_modulate.darkened(0.5)
	mouse_in_slot = true
	inventory.inside()
	inventory.selected_slot = self

func outside() -> void:
	$backround.scale = default_scale
	$backround.self_modulate = default_modulate
	mouse_in_slot = false
	inventory.selected_slot = null

func _gui_input(_event: InputEvent) -> void:
	pass
