extends Node

var SEED: int = randi();
var player_past_Overworld_position: Vector2i = Vector2i(0, 0);
var player_has_pos: bool = false;
var player_is_dead: bool = false;
var player_scene: Node2D;
