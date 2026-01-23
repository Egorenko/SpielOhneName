extends Node2D

@onready var tileMap: TileMap = $TileMap;

func _enter_tree() -> void:
	var player_ = PlayerManager.get_player()
	if player_.get_parent():
		player_.get_parent().remove_child(player_)
	await get_tree().process_frame
	get_tree().current_scene.add_child(player_)

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	var tileData: TileData = tileMap.get_cell_tile_data(2, tileMap.local_to_map(PlayerManager.player_.position));
	if (tileData == null):
		PlayerManager.player_.can_teleport = true;
		return;
	if (tileData.get_custom_data("Teleporter") and PlayerManager.player_.can_teleport):
		PlayerManager.player_.can_teleport = false;
		PlayerManager.player_.past_Overworld_position = PlayerManager.player_.global_position;
		get_tree().change_scene_to_file("res://scenes/dungeon_room_manager.tscn");
