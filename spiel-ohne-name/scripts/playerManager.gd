extends Node

var player: player1

func get_player() -> player1:
	if player == null:
		print("-------------------new player------")
		player = preload("res://scenes/player.tscn").instantiate()
	else:
		print("-----------------------------------")
		pass
	#print(player.inventory_ui.get_tree_string_pretty())
	return player
