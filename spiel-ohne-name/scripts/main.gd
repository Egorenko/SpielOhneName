extends Node2D
@export var mob_scene: PackedScene
@onready var mobtimer = $MobTimer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mobtimer.start()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_mob_timer_timeout() -> void:
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath2D/MobSpawnLocation2D
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	#mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(100.0, 150.0), randf_range(100.0, 150.0))
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
