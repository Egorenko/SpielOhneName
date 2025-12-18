class_name effects

var dmg:float
var duration:float

var dur_timer:Timer = Timer.new()
func dur_start() -> void:
	dur_timer.one_shot = true
	dur_timer.timeout.connect(dur_end)
	dur_timer.call_deferred("start", duration)

func dur_end() -> void:
	#TODO end effect
	return
