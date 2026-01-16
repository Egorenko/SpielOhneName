extends Resource
class_name Inventory_stack 

@export var item:Inventory_item
var stack_max:int = 0
@export var current_stack:int = 0
var drop_scene:PackedScene = preload("res://scenes/pick_up_item.tscn")

func _init(_item = null, _current_stack = null) -> void:
	if _item and _item is Inventory_item:
		item = _item
		stack_max = _item.stack_size
	if _current_stack and _current_stack is int:
		current_stack = _current_stack
	clamb()

func change_item(new:Inventory_item) -> void:
	item = new
	stack_max = new.stack_size

func increase_stack(new_item:Inventory_item) -> void:
	#just extra safety
	if new_item == item:
		current_stack += 1
	clamb()

func decrease_stack() -> void:
	current_stack -= 1
	clamb()

func clamb() -> void:
	if current_stack > stack_max:
		current_stack = stack_max 
	if current_stack <= 0:
		on_empty()

func is_full() -> bool:
	return current_stack >= stack_max

func on_empty() -> void:
	item = null
	pass

func load_drop(scene:PackedScene) -> void:
	drop_scene = scene

func on_drop(pos:Vector2, dropper:Node2D, scene = null) -> void:
	var scene_root:Node2D = null
	if scene and scene is PackedScene:
		scene_root = scene.instantiate()
	else:
		scene_root = drop_scene.instantiate()
	scene_root.position = pos
	#TODO wtf y not find item?
	if "stack" in scene_root:
		scene_root.stack = self
	else:
		print("not found 'stack' in scene")
	dropper.get_tree().root.call_deferred_thread_group("add_child", scene_root)
