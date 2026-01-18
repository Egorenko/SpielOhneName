extends Node

var stats:entity_stats

func get_stats() -> entity_stats:
	if not stats:
		print("default stats")
		stats = preload("res://scripts/stats/entity_stats/player_stats.tres")
	return stats
