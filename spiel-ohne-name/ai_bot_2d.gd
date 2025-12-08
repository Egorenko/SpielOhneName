extends CharacterBody2D
class_name Enemy

@export var speed: float = 50.0

@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var player: CharacterBody2D = %player


func _ready() -> void:
	call_deferred("_setup_navigation")
	nav.velocity_computed.connect(_velocity_computed)


func _setup_navigation() -> void:
	# NavigationServer muss erst einen Frame syncen
	await get_tree().physics_frame
	if player:
		nav.target_position = player.global_position


func _physics_process(delta: float) -> void:
	if not player:
		return

	# Ziel jedes Frame aktualisieren
	nav.target_position = player.global_position

	if not nav.is_navigation_finished():
		_move_towards_target()
	else:
		velocity = Vector2.ZERO

	move_and_slide()


func _move_towards_target() -> void:
	var next_point := nav.get_next_path_position()
	var direction := (next_point - global_position).normalized()
	var desired_velocity := direction * speed

	if nav.avoidance_enabled:
		nav.set_velocity(desired_velocity)
	else:
		_velocity_computed(desired_velocity)


func _velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
