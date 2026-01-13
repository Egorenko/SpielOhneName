class_name Item extends CharacterBody2D

#TODO add Item (resource?)

func on_interact() -> void:
	#TODO load Item in Inventory
	print("pick up")
	queue_free()
	pass
