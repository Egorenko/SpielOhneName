extends Node

var player: Node

func get_player() -> Node:
	if player == null:
		player = preload("res://scenes/player.tscn").instantiate()
	return player
