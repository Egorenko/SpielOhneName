extends CharacterBody2D
class_name test_player_with_stats

@export var test_stat:entity_stats = preload("res://scripts/ressources/entity_stats/test_player_stats.tres")
var health = test_stat.health
var damage = test_stat.damage
var cooldown = test_stat.cooldown
var speed = test_stat.speed
var atk_speed = test_stat.attack_speed

func _ready() -> void:
	$AnimationPlayer/Node2D/Sprite2D/pHitbox.attack(atk_speed)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB"):
		var angle = self.global_position.angle_to_point(get_global_mouse_position())
		$AnimationPlayer/Node2D.rotation = angle
		$AnimationPlayer/Node2D/Sprite2D.visible = true
		$AnimationPlayer.current_animation = "attack_test"
		$AnimationPlayer/Node2D/Sprite2D/pHitbox.attack(atk_speed)
		$AnimationPlayer.speed_scale = $AnimationPlayer.current_animation_length / atk_speed
		$AnimationPlayer.play("attack_test")
		

func _physics_process(delta: float) -> void:
	$AnimationPlayer/Node2D.global_position = self.global_position
	if not $AnimationPlayer.is_playing():
			$AnimationPlayer/Node2D/Sprite2D.visible = false
	
	velocity = Input.get_vector("A", "D", "W", "S")
	if velocity.x != 0 and velocity.y != 0:
		velocity = velocity * 0.707
	var new_texture: Texture2D
	if velocity.y < 0:
		new_texture = preload("res://assets/20251203test_charB2.png")
	elif velocity.y > 0:
		new_texture = preload("res://assets/20251203test_charF2.png")
	elif velocity.x > 0:
		new_texture = preload("res://assets/20251103test_charR.png")
	elif velocity.x < 0:
		new_texture = preload("res://assets/20251103test_charL.png")
	if new_texture and $test.texture != new_texture:
		$test.texture = new_texture
	if velocity:
		velocity = velocity * delta * speed
	else:
		velocity = Vector2(move_toward(velocity.x, 0, speed), move_toward(velocity.y, 0, speed))
	move_and_slide()
