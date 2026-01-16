extends CharacterBody2D
@export var speed = 40
var screen_size


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("player")
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direktion = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	if direktion:
		velocity = direktion * speed
	else:
		velocity = Vector2(move_toward(velocity.x, 0, speed),move_toward(velocity.y, 0, speed))
	move_and_slide()
