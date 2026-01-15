class_name Cooldown_Area extends Area2D
#defaults
var lifetime:float = 0.001
var cooldown:float = 0.0

var cooldown_over:bool = true

func _ready() -> void:
	off()
	area_entered.connect(_on_area_entered)

##returns if acceptable area is found
func _on_area_entered(area:Area2D) -> bool:
	assert(false, "_on_area_entered() must be implemented in a subclass");
	return false;


func off() -> void:
	#print("OFF")
	for node:Object in self.get_children():
		if node is Timer:
			continue
		if node is CanvasItem:
			node.disabled = true
	monitoring = false
	monitorable = false

func on() -> void:
	#print("ON")
	for node:Object in self.get_children():
		if node is Timer:
			continue
		if node is CanvasItem:
			node.disabled = false
	monitoring = true
	monitorable = true

func cooldown_end() -> void:
	cooldown_over = true

#
func cooldown_start() -> void:
	cooldown_over = false
