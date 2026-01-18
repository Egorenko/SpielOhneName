extends Node2D


func _on_button_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/map.tscn");


func _on_credit_button_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/credits.tscn");
