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

func _init():
	assert(false, "_init() must be implemented in a subclass");

func activate_effect():
	assert(false, "activate_effect() must be implemented in a subclass");
