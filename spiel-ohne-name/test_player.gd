extends CharacterBody2D
class_name test_player_with_stats

@export var stats:entity_stats = preload("res://scripts/ressources/entity_stats/test_player_stats.tres")
'var _health:Health = stats.health
var damage = stats.damage
var cooldown = stats.cooldown
var speed = stats.speed
var atk_speed = stats.attack_speed'

var local_position:Vector2 = Vector2(0.0, 0.0) 

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB"):
		$Interact_Area.position = get_local_mouse_position()
		$Interact_Area.interact(0.5)
		#$attack2.rotation = local_position.angle_to_point(get_local_mouse_position())
		#$attack2.attack()
	if event.is_action_pressed("RMB"):
		$attack.rotation = local_position.angle_to_point(get_local_mouse_position())
		$attack.attack()
	if event.is_action_pressed("Ctrl"):
		print($attack.hitbox.diabled)

@onready var new_texture:AtlasTexture = $test.texture as AtlasTexture

func _physics_process(delta: float) -> void:
	'$AnimationPlayer/Node2D.global_position = self.global_position
	if not $AnimationPlayer.is_playing():
		$AnimationPlayer/Node2D/Sprite2D.visible = false'
	
	velocity = Input.get_vector("A", "D", "W", "S")
	if velocity.x != 0 and velocity.y != 0:
		velocity = velocity * 0.707
	
	if velocity.y < 0:
		new_texture.region = Rect2(60.0, 5.0, 17.0, 22.0)
	elif velocity.y > 0:
		new_texture.region = Rect2(40.0, 5.0, 17.0, 22.0)
	elif velocity.x > 0:
		new_texture.region = Rect2(22.0, 5.0, 17.0, 22.0)
	elif velocity.x < 0:
		new_texture.region = Rect2(4.0, 5.0, 17.0, 22.0)
	if new_texture and $test.texture != new_texture:
		$test.texture = new_texture
	if velocity:
		velocity = velocity * delta * stats.speed
	else:
		velocity = Vector2(move_toward(velocity.x, 0, stats.speed), move_toward(velocity.y, 0, stats.speed))
	move_and_slide()
