extends Quest_item
class_name On_pickup_item

##WIP add default like Win-Scene
@export var Quest_compleation_scene:PackedScene

func on_pick_up(collecter:Node) -> void:
	print("pick up")
	if Quest_compleation_scene:
		collecter.call_deferred_thread_group("add_child", Quest_compleation_scene.instantiate())
