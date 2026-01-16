extends Sprite2D

func _process(delta: float) -> void:
	if position.y < -900:
		position.y =930;
	position.y -= 4;
	
