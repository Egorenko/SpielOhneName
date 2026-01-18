extends Area2D
class_name Interactable 

#actually no clue what that does
func _ready() -> void:
	monitoring = false#?

##TODO returns if activated?
func interact_(activator:Node) -> bool:
	if owner.has_method("on_interact"):#use custom method if available
		owner.on_interact(activator)
	else:
		print("INTERACT WITH ", self.owner)
	return false
