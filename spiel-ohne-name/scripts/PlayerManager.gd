extends Node

var player_:player

func get_player() -> player:
	if player_ == null:
		player_ = preload("res://scenes/player.tscn").instantiate()
		player_.SEED = randi()
	if player_.get_parent():
		player_.inventory_ui.update_slots()
		player_.healthbar.update()
	return player_
