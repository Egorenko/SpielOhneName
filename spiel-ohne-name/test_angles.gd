extends Node2D

var line:Line2D = Line2D.new()
var timer:Timer = Timer.new()
var start:bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(line)
	add_child(timer)
	timer.timeout.connect(collect)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if start:
			$help.clear_points()
			timer.call_deferred("start", 0.01)
		start = false
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if not start:
			timer.stop()
			start = true
			$find_shape.points = line.points
			line.clear_points()
			$find_shape.analyse_by_degree()
			print($find_shape.big_degrees , "\n")
			$help.points = $find_shape.test
	pass

func collect() -> void:
	line.add_point(get_global_mouse_position())
	start = true
