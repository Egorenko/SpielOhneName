extends CharacterBody2D

var SPEED = 15000.0
const JUMP_VELOCITY = -400.0

#var change = true

var offset:float = 20.0
var offsetV:Vector2 = Vector2(offset, 0.0)

var start_timer:bool = true#to differentiate between 'hold' and 'release'
var start_draw:bool = true

# |PI| left ; 0 right ; PI/2 down ; -PI/2 up
# [3 .. -3]
var rotation_noise:float = 1.0

var thrust_damage:int = 3
var swipe_damage:int = 1
var block_hp:int = 2
var health:int = 10

var sprint_on:bool = true

var draw_time:float = 0.3#in seconds
var draw_timer:Timer#variable to count time

var display_mid:Vector2 = Vector2(0.0, 0.0)

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	#hold to draw attack shape
	if Input.is_action_pressed("LMB"):
		#max time for input
		if start_timer:
			draw_timer = Timer.new()
			add_child(draw_timer)
			draw_timer.connect("timeout", timer_end)
			draw_timer.start(draw_time)#zählt nur bei halten
			start_timer = false
		#when input-time startet, until end/ready again
		if start_draw:
			$find_shape.add_point(get_local_mouse_position())
	
	#if stopped hold to attack
	if Input.is_action_just_released("LMB"):
		if draw_timer:
			draw_timer.stop()
		end_draw()
		start_timer = true
		start_draw = true

##just a small brain help
func timer_end() -> void:
	start_draw = false
	#end_draw()

##if input-time is over
func end_draw() -> void:
	if $find_shape.analyse_by_distance():
		process_attack(display_mid, $find_shape.get_shape_number(), $find_shape)
	else:
		print("too short")
	$find_shape.clear_points()
	if draw_timer:
		draw_timer.queue_free()
		draw_timer = null
	

func _input(event: InputEvent) -> void:
	
	#TODO dodge / press
	if event.is_action_pressed("Ctrl") and not event.is_echo():
		print("DODGE")
		pass
	
	#TODO sprint / hold
	if event.is_action_pressed("Shift"):
		if sprint_on:
			print("SPRINT")
			#$Sprite2D_test.material.shader = load("res://shaders/test_shader.gdshader")
			SPEED = 45000
			sprint_on = false
		else:
			print("STOP SPRINT")
			#$Sprite2D_test.material.shader = null
			SPEED = 15000
			sprint_on = true
		pass
	
	#TODO use RMB i guess
	if event.is_action_pressed("RMB"):
		print("RMB")
		pass

##movement
func _physics_process(delta: float) -> void:
# Get the input direction and handle the movement/deceleration.
# As good practice, you should replace UI actions with custom gameplay actions.
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
	if new_texture and $Sprite2D_test.texture != new_texture:
		$Sprite2D_test.texture = new_texture
	if velocity:
		velocity = velocity * SPEED * delta
	else:
		velocity = Vector2(move_toward(velocity.x, 0, SPEED), move_toward(velocity.y, 0, SPEED))
	move_and_slide()

## tryes to find fitting attack for shape
func process_attack(char_pos:Vector2, atk_type:int, atk_shape:Line2D)-> void:
	
	var midLine:Vector2 = Vector2(0.0,0.0)
	var mid:Vector2 = Vector2(0.0,0.0)
	var midLine_rotation:float = 0.0
	var char_to_mid:Vector2 = Vector2(0.0,0.0)
	
	if atk_shape.points:
		midLine = atk_shape.points[0] - atk_shape.points[atk_shape.points.size()-1]#direct line from start to end -> middle line
		mid = atk_shape.points[atk_shape.points.size()-1] + midLine*0.5#middle of attackline
		midLine_rotation = atk_shape.points[0].angle_to_point(atk_shape.points[atk_shape.points.size()-1])
		char_to_mid = mid - char_pos#vector for angle player to middle of attackline
	else:
		print("NO SHAPE")
		return
	
	match atk_type:
		-1:
			print("NOT FOUND")
		0:
			print("POINT")
		1:
			print("LINE")
			#angle ray from player to line bigger 90 - noise and smaller 90 + noise
			#TODO problem when moving
			if (PI * 0.5 - rotation_noise <= abs(char_to_mid.angle_to(midLine))) and (abs(char_to_mid.angle_to(midLine)) <= PI * 0.5 + rotation_noise):
				$block.rotation = char_pos.angle_to_point(mid)
				$block.attack()
			else:
				$thrust_attack.rotation = midLine_rotation
				$thrust_attack.attack()
		2:
			print("ARCH")
			$swipe_attack.rotation = char_pos.angle_to_point(mid)
			$swipe_attack.attack()
	return

#-------------------------------------------------------------------------------
