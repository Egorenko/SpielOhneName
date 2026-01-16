extends entity
var healthbar:Healthbar = Healthbar.new()

func _ready() -> void:
	healthbar = $healthbar
	pass

func on_interact() -> void:
	print("interact")

func on_death() -> void:
	$AnimationPlayer.play("char_body/death")
