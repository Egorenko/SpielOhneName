extends Resource
class_name Inventory_item 

@export var name:String = ''
@export var texture:Texture2D
@export var stack_size:int = 1

var drop_scene:PackedScene = preload("res://scenes/pick_up_item.tscn")

func load_drop(scene:PackedScene) -> void:
	drop_scene = scene

func on_drop(pos:Vector2, count:int,dropper:Node, scene = null) -> void:
	if scene and scene is PackedScene:
		drop_scene = scene
	var stack:Inventory_stack = Inventory_stack.new(self, count)
	stack.load_drop(drop_scene)
	stack.on_drop(pos, dropper, drop_scene)
