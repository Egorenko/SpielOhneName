extends Node

var player_:player

func get_player() -> player:
	if player_ == null:
		player_ = preload("res://scenes/player.tscn").instantiate()
	return player_
