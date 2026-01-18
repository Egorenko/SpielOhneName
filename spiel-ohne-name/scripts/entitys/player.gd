extends entity
class_name player1 

@onready var inventory_ui:Control = $Inventory_UI

'###'
var can_teleport:bool = false;
var SEED:int = Seed.SEED;
var past_Overworld_position: Vector2i = Vector2i(0, 0);
'###'

@export var speed_mult:float = 1.5
@onready var SPEED:float = stats.speed
var sprint_on:bool = true
var display_mid:Vector2 = Vector2(0.0, 0.0)
# |PI| left ; 0 right ; PI/2 down ; -PI/2 up
# [3 .. -3]
var rotation_noise:float = 1.0
var healthbar:Healthbar = Healthbar.new()

func _ready() -> void:
	add_to_group("player")
	healthbar = $healthbar
	#setup area infinite
	$Pickup_Area.interact(-1)
	#start stats for healthbar
	healthbar.max_value = stats.health.get_max_hp()
	healthbar.value = stats.health.get_hp()
	#timer for drawing
	add_child(draw_timer)
	draw_timer.connect("timeout", end)
	add_child(vertex_timer)
	vertex_timer.connect("timeout", per_vertex)

var draw_timer:Timer = Timer.new()
var draw_time:float = 0.3
var vertex_timer:Timer = Timer.new()
var vertex_time:float = draw_time * 0.1
var hold:bool = false

func per_vertex() -> void:
	if hold:
		$find_shape.add_point(get_local_mouse_position())
	else:
		vertex_timer.stop()
func end() -> void:
	vertex_timer.stop()
	draw_timer.stop()
	hold = false
	if $find_shape.analyse_by_distance():
		process_attack(display_mid, $find_shape.get_shape_number(), $find_shape)
	else:
		print("too short")
	$find_shape.clear_points()

func _input(event: InputEvent) -> void:
	#open inventory
	if event.is_action_pressed("Alt") and not event.is_echo():
		if inventory_ui.is_open:
			inventory_ui.close()
		else:
			inventory_ui.open()
	#start hold to attack
	if event.is_action_pressed("LMB") and not event.is_echo() and not inventory_ui.mouse_inside:
		draw_timer.start(draw_time)
		vertex_timer.start(vertex_time)
	#hold to draw attack
	if event.is_action_pressed("LMB"):
		hold = true
	#release to cancel
	if event.is_action_released("LMB"):
		hold = false
	#TODO dodge / press
	if event.is_action_pressed("Ctrl") and not event.is_echo():
		print("DODGE")
		pass
	#TODO sprint / hold
	if event.is_action_pressed("Shift"):
		print("SPRINT")
		#$Sprite2D_test.material.shader = load("res://shaders/test_shader.gdshader")
		SPEED = stats.speed * speed_mult
		sprint_on = false
	if event.is_action_released("Shift"):
		print("STOP SPRINT")
		#$Sprite2D_test.material.shader = null
		SPEED = stats.speed
	#TODO use RMB i guess
	if event.is_action_pressed("RMB"):
		print("RMB")
		pass

@onready var new_texture:AtlasTexture = $Sprite2D_test.texture as AtlasTexture
##movement
func _physics_process(delta: float) -> void:
# Get the input direction and handle the movement/deceleration.
# As good practice, you should replace UI actions with custom gameplay actions.
	velocity = Input.get_vector("move_left","move_right", "move_up", "move_down")
	if velocity.x != 0 and velocity.y != 0:
		velocity = velocity * 0.707107
	if velocity.y < 0:
		new_texture.region = Rect2(60.0, 5.0, 17.0, 22.0)
	elif velocity.y > 0:
		new_texture.region = Rect2(40.0, 5.0, 17.0, 22.0)
	elif velocity.x > 0:
		new_texture.region = Rect2(22.0, 5.0, 17.0, 22.0)
	elif velocity.x < 0:
		new_texture.region = Rect2(4.0, 5.0, 17.0, 22.0)
	if new_texture and $Sprite2D_test.texture != new_texture:
		$Sprite2D_test.texture = new_texture
	if velocity:
		velocity = velocity * SPEED * delta
	else:
		velocity = Vector2(move_toward(velocity.x, 0, SPEED), move_toward(velocity.y, 0, SPEED))
	move_and_slide()

var knock_back:float = 100.0

func on_hit(_damage:float, attacker:Node2D) -> void:
	var attack_dir = position - attacker.position
	velocity = attack_dir / attack_dir.length() * knock_back
	move_and_slide()
	stats.health.decrease_hp(_damage)
	healthbar.update()
	pass

func on_death() -> void:
	$Sprite2D_test.modulate = Color(255.0, 255.0, 255.0, 0.2)
	pass

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
			$Interact_Area.position = get_local_mouse_position()
			$Interact_Area.interact(0.1)
		1:
			print("LINE")
			#angle ray from player to line bigger 90 - noise and smaller 90 + noise
			#TODO problem when moving
			if (PI * 0.5 - rotation_noise <= abs(char_to_mid.angle_to(midLine))) and (abs(char_to_mid.angle_to(midLine)) <= PI * 0.5 + rotation_noise):
				#block
				$attack.rotation = char_pos.angle_to_point(mid)
				$attack.attack(attacks[0])
			else:
				#thrust
				$attack.rotation = midLine_rotation
				$attack.attack(attacks[1])
		2:
			print("ARCH")
			#swipe
			$attack.rotation = mid.angle_to_point($find_shape.max_dis_vertex)
			$attack.attack(attacks[2])
	return
