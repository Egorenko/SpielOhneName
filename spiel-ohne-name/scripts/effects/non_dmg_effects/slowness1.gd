extends effects
class_name slowness1

var slow:float

func _init(_slow:float) -> void:
	self.priority = 1
	
	slow = _slow

func activate_effect():
	dur_start()
	#TODO char.SPEED * slow
