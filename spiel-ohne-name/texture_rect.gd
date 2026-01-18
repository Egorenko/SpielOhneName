extends Sprite2D

func _process(delta: float) -> void:
	if position.y < -400:
		position.y =1008;
	position.y -= 4;
	
