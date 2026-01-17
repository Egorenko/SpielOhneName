extends entity
class_name player1 

@onready var inventory_ui:Control = $Inventory_UI

'###'
var can_teleport:bool = true
var SEED:int = randi();
'###'

var SPEED = 15000.0
var sprint_on:bool = true
var display_mid:Vector2 = Vector2(0.0, 0.0)
# |PI| left ; 0 right ; PI/2 down ; -PI/2 up
# [3 .. -3]
var rotation_noise:float = 1.0

var healthbar:Healthbar = Healthbar.new()

func _ready() -> void:
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
	if event.is_action_pressed("Alt") and not event.is_echo():
		if $Inventory_UI.is_open:
			$Inventory_UI.close()
		else:
			$Inventory_UI.open()
	
	if event.is_action_pressed("LMB") and not event.is_echo() and not $Inventory_UI.mouse_inside:
		draw_timer.start(draw_time)
		vertex_timer.start(vertex_time)
	
	if event.is_action_pressed("LMB"):
		hold = true
	
	if event.is_action_released("LMB"):
		hold = false
	
	#TODO dodge / press
	if event.is_action_pressed("Ctrl") and not event.is_echo():
		print("DODGE")
		pass
	
	#TODO sprint / hold
	if event.is_action_pressed("Shift"):
		if sprint_on:
			print("SPRINT")
			#$Sprite2D_test.material.shader = load("res://shaders/test_shader.gdshader")
			stats.speed = 45000
			sprint_on = false
		else:
			print("STOP SPRINT")
			#$Sprite2D_test.material.shader = null
			stats.speed = 15000
			sprint_on = true
		pass
	
	#TODO use RMB i guess
	if event.is_action_pressed("RMB"):
		print("RMB")
		pass

func _process(_delta: float) -> void:
	teleport();

@onready var new_texture:AtlasTexture = $Sprite2D_test.texture as AtlasTexture
##movement
func _physics_process(delta: float) -> void:
	'###'
	#teleport()
	'###'
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
		velocity = velocity * stats.speed * delta
	else:
		velocity = Vector2(move_toward(velocity.x, 0, stats.speed), move_toward(velocity.y, 0, stats.speed))
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

#-------------------------------------------------------------------------------
func teleport()-> bool:
	var tile_pos = $"../TileMap".local_to_map(global_position)
	var cell_data = $"../TileMap".get_cell_tile_data(0, tile_pos)
	var cell_data_door = $"../TileMap".get_cell_tile_data(2, tile_pos)
	
	if (!can_teleport):
		if (cell_data.get_custom_data("teleport_tile")): return false;
		if (cell_data_door != null): if (cell_data_door.get_custom_data("Teleporter")): return false;
		can_teleport = true;
		return false;
	
	if cell_data and cell_data.get_custom_data("teleport_tile"):
		print("teleport");
		for a: Vector4i in $"../TileMap".teleport_tiles:
			if (a[0] == tile_pos[0] and a[1] == tile_pos[1]):
				var b = $"../TileMap".map_to_local(Vector2i(a[2], a[3]));
				global_position = b;
				can_teleport = false;
				return true;
	
	if cell_data_door and cell_data_door.get_custom_data("Teleporter"):
		print("Door Teleport");
		can_teleport = false;
		get_tree().change_scene_to_file("res://scenes/dungeon_map.tscn");
		return true;
	return false;
