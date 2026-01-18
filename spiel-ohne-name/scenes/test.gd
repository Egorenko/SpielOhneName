extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = PlayerManager.get_player()
	if player.get_parent():
		player.get_parent().remove_child(player)
	get_tree().root.add_child(player)
	print(get_tree_string_pretty())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
