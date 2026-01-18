extends Panel
class_name Inventory_ui_slot 

@onready var item_visual:Sprite2D = $backround/CenterContainer/Panel/Item_dysplay
@onready var default_texture:Texture2D = $backround.texture
@onready var default_scale:Vector2 = $backround.scale
@onready var default_modulate:Color = $backround.modulate
var stack:Inventory_stack = null
var inventory:Inventory_ui = null
var index:int = -1
var mouse_in_slot:bool = false

func _ready() -> void:
	mouse_entered.connect(inside)
	mouse_exited.connect(outside)

func update(new_stack:Inventory_stack) -> void:
	if not new_stack.item:
		stack = null
		item_visual.visible = false
		$backround/CenterContainer/Panel/text.visible = false
		$backround/CenterContainer/Panel/text.text = str(0)
	else:
		stack = new_stack
		item_visual.visible = true
		item_visual.texture = new_stack.item.texture
		
		if new_stack.item.stack_size > 1:
			$backround/CenterContainer/Panel/text.visible = true
			$backround/CenterContainer/Panel/text.text = str(new_stack.current_stack)

func inside() -> void:
	$backround.scale = default_scale * 1.2
	$backround.self_modulate = default_modulate.darkened(0.5)
	mouse_in_slot = true
	inventory.in_slot = self
	inventory.inside()

func outside() -> void:
	$backround.scale = default_scale
	$backround.self_modulate = default_modulate
	mouse_in_slot = false
	inventory.in_slot = null

func selected() -> void:
	$backround.material.shader = load("res://shaders/black_to_color.gdshader")

func deselected() -> void:
	$backround.material.shader = null
