extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	'############################'
	var player = PlayerManager.get_player()
	if player.get_parent():
		player.get_parent().remove_child(player)
	add_child(player)
	'############################'
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
