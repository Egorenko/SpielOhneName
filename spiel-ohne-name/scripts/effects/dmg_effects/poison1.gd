extends effects
class_name poison1

var tick_time:float = 0.0
var tick_timer:Timer = Timer.new()

##_tick default = 0.1
func _init(_dmg:int, _dur:float, _tick = null) -> void:
	self.priority = 2
	
	damage = _dmg
	duration = _dur
	if _tick and _tick is float:
		tick_time = _tick
	else:
		tick_time = 0.1

func tick(tick_time) -> void:
	#TODO deal damage
	print("deal tick", self.damage)
	

func activate_effect():
	dur_start()
	#if not one-shot -> activates and restarts
	tick_timer.timeout.connect(tick)
