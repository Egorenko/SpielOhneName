<<<<<<< .merge_file_qxA0ft
#@abstract
##abstract should declare func _on_area_entered -> bool
<<<<<<< HEAD
=======
>>>>>>> .merge_file_r4VSzO
class_name Cooldown_Area extends Area2D
=======
extends Area2D
class_name Cooldown_Area 
>>>>>>> 34e55daba267030e6fabd64699a53e06e2b5f5a2
#defaults
var lifetime:float = 0.001
var cooldown:float = 0.0

var cooldown_over:bool = true

func _ready() -> void:
	off()
	area_entered.connect(_on_area_entered)

##returns if acceptable area is found
<<<<<<< .merge_file_qxA0ft
#@abstract 
func _on_area_entered(_area:Area2D) -> bool:
	print("base _ona_area_entered")
	return false
=======
func _on_area_entered(area:Area2D) -> bool:
	assert(false, "_on_area_entered() must be implemented in a subclass");
	return false;

>>>>>>> .merge_file_r4VSzO

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
