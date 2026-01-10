@abstract
class_name effects

var priority:int
var damage:float
var duration:float

var dur_timer:Timer = Timer.new()

func dur_start() -> void:
	dur_timer.one_shot = true
	dur_timer.timeout.connect(dur_end)
	dur_timer.call_deferred("start", duration)

func dur_end() -> void:
	self.free()

@abstract func _init()
@abstract func activate_effect()
