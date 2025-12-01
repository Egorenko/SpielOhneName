extends CharacterBody2D

var SPEED = 200.0
const JUMP_VELOCITY = -400.0

var change = true

var offset:float = 15.0
var offsetV:Vector2 = Vector2(offset, 0.0)

var timerDef:int = 61
var timerAction:float = 0.9
var tickTimer: int = timerDef#timer per frames

var test_tick:int = 30
var check :bool = true#to differentiate between 'hold' and 'release'

var atk_vertces:Array[Vector2]#collection os vertces for mouse swipe
var atk_vertces_count_min:int = 3 #at least n vertces in 'atk_vertces'
var atk_vertces_count_max:int = 30#at most n vertces in 'atk_vertces'
var atk_noise:float = 2.5#max distance a vertex can diviate from start-end-line
var atk_ex_noise:float = 0.6#percentage of equality between start/end (1 -> perfect in middle | 0.0 -> distance to sstart/end irrelevant)
var atk_ex_maxDis:float = 50#max distance most farthest away vertex is allowed to have
var atk_ex_minDis:float = 10#min distance most closest vertex needs to have (seperate from atk_noise)

# |PI| left ; 0 right ; PI/2 down ; -PI/2 up
# [3 .. -3]
var rotation_noise:float = 0.7

func _physics_process(delta: float) -> void:

#TODO dodge
	if Input.is_action_just_pressed("Ctrl"):
		pass

#attack
	if Input.is_action_just_released("LMB"):#if stop reset
		print("STOP")
		if atk_vertces_count_min <= atk_vertces.size():#try process
			print("WORK EARLY")
			$atk_area/atk_view.visible = false
			var i:int = processShape(atk_vertces, atk_noise, atk_ex_noise)
			process_attack($Sprite2D_test.global_position, i, atk_vertces)
		else :
			print("CLEAR")
		atk_vertces.clear()
		test_tick = 30
		check = true
		$atk_area/atk_ray.clear_points()
		#add to line
	if Input.is_action_pressed("LMB") and check:#while hold
		test_tick-= 1#count timer
		if(test_tick >= 0):#if timer not end
			atk_vertces.append(to_local(get_global_mouse_position()))#collect vertex
			$atk_area/atk_ray.add_point(to_local(get_global_mouse_position()))

		#too many -> end?
		if atk_vertces.size() >= atk_vertces_count_max:#force end
			print("WORK LATE")
			check = false
			$atk_area/atk_view.visible = false
			var i:int = processShape(atk_vertces, atk_noise, atk_ex_noise)
			process_attack($Sprite2D_test.global_position, i, atk_vertces)

# Get the input direction and handle the movement/deceleration.
# As good practice, you should replace UI actions with custom gameplay actions.
	var direction: Vector2 = Vector2(Input.get_axis("A", "D"), Input.get_axis("W", "S"))
	if direction.x and direction.y != 0:
		direction = direction * 0.707
	var new_texture: Texture2D
	if direction.y < 0:
		new_texture = preload("res://assets/20251103test_charB.png")
	elif direction.y > 0:
		new_texture = preload("res://assets/20251103test_charF.png")
	elif direction.x > 0:
		new_texture = preload("res://assets/20251103test_charR.png")
	elif direction.x < 0:
		new_texture = preload("res://assets/20251103test_charL.png")
	if new_texture and $Sprite2D_test.texture != new_texture:
		$Sprite2D_test.texture = new_texture
	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector2(move_toward(velocity.x, 0, SPEED), move_toward(velocity.y, 0, SPEED))

# TODO sprint
	if Input.is_action_just_pressed("Shift"):
		if change :
			#$Sprite2D_test.material.shader = load("res://assets/test_shader.gdshader")
			'var test = sprite.get_instance_shader_parameter("colors")
			#test[2] = 255.0
			print(test)
			#clampVec3(test, 255.0, 0.0)
			#print(test)
			sprite.set_instance_shader_parameter("colors", test)'
			SPEED = 300 #150%
			change = false
			print("activate")
		else :
			$Sprite2D_test.material.shader = null #unload/reset shader
			SPEED = 200
			change = true
			print("deactivate")

	move_and_slide()

#-------------------------------------------------------------------------------
# finds what shape array could make
func processShape(line:Array[Vector2], line_noise:float, ex_noise:float) -> int:
	var start:Vector2 = line.front()
	var end:Vector2 = line.back()
	var y2y1:float = (end[1]-start[1])
	var x2x1:float = (end[0]-start[0])
	
#visual help ->
	var correctLine = Line2D.new()
	correctLine.points = line
	correctLine.width = 1.0
#<- visual help

	var maxDis_vector_positive:Vector3#safe vertex[0][1] AND its distance to line[2]
	var maxDis_vector_negative:Vector3
	
	var start_end_dis:float = pow(pow(y2y1, 2) + pow(x2x1, 2), 1.0/2.0)#distance of start-end-line
	var maxDis:float = 0.0
	var maxDisV:Vector2 = Vector2(0.0, 0.0)
	
#test nois per vertex ->
	for vertex in line:
		var dis:float = (
			(y2y1 * vertex[0] - x2x1*vertex[1] + (end[0] * start[1]) - (end[1] * start[0]))
			/start_end_dis
			)
		if(dis >= maxDis_vector_positive[2]):#safe most farthest away
			maxDis_vector_positive[0] = vertex[0]
			maxDis_vector_positive[1] = vertex[1]
			maxDis_vector_positive[2] = dis
		if(dis <= maxDis_vector_negative[2]):#same but negative
			maxDis_vector_negative[0] = vertex[0]
			maxDis_vector_negative[1] = vertex[1]
			maxDis_vector_negative[2] = dis
#<- test nois per vertex

	if  abs(maxDis_vector_negative[2]) < abs(maxDis_vector_positive[2]):
		maxDis = abs(maxDis_vector_positive[2])
		maxDisV = Vector2(maxDis_vector_positive[0],maxDis_vector_positive[1])
	else:
		maxDis = abs(maxDis_vector_negative[2])
		maxDisV = Vector2(maxDis_vector_negative[0],maxDis_vector_negative[1])

#no vertces too far away -> should be line
	if maxDis_vector_positive[2] < line_noise and abs(maxDis_vector_negative[2]) < line_noise :
		correctLine.default_color = Color(0.0,0.0,255.0,255.0)
		get_parent().add_child(correctLine)
		print("Line")
		return 0#0 = straight

#further away then allowed
	if maxDis > atk_ex_maxDis:
		print("TOO FAR AWAY")
		return -1

	if maxDis_vector_positive[2] >= line_noise and abs(maxDis_vector_negative[2]) >= line_noise :#if extrema in two directions -> neither line nore arch
		print("EXTREME IN POS AND NEG")
		return -1#polygon

	var StoEX:float = abs(start.distance_to(maxDisV))#length |start->extrema|
	var EtoEX:float = abs(end.distance_to(maxDisV))#length |end->extrema|
	if (EtoEX * ex_noise <= StoEX and StoEX <= EtoEX) or (StoEX * ex_noise <= EtoEX and EtoEX <= StoEX) :#one side between o.side and acceptable length o.side 
		print("IN MIDDLE")
	else : 
		print("NOT MIDDLE")
		return -1

#if one* vertex too far away -> line has to bend -> not (straight) line
	if maxDis >= line_noise and maxDis >= atk_ex_minDis:
		correctLine.default_color = Color(0.0,255.0,0.0,255.0)
		get_parent().add_child(correctLine)
		print("ARCH")
		return 1#1 = NOT straight
	print("DID NOT FIND SHAPE")
	return -1

#-------------------------------------------------------------------------------
# tryes to find fitting attack for shape
func process_attack(startPos:Vector2, atk_type:int, atk_shape:Array[Vector2])-> void:
	$atk_area/atk_view.visible = true
	$atk_area/atk_view.rotation = 0#reset Sprite
	var midLine:Vector2 = atk_shape[0] -  atk_shape[atk_shape.size()-1]#direct line from start to end -> middle line
	var mid:Vector2 = atk_shape[atk_shape.size()-1] + midLine*0.5#middle of attackline
	var midLine_rotation:float = atk_shape[0].angle_to_point(atk_shape[atk_shape.size()-1])
	var char_to_mid:Vector2 = mid - startPos#vector for angle player to middle of attackline
	var angle_char_to_Line:float = abs(char_to_mid.angle_to(midLine))

#line
	match atk_type:
		0:#line
			if (PI * 0.5 - rotation_noise <= angle_char_to_Line) and (angle_char_to_Line <= PI * 0.5 + rotation_noise):
				move_rotate_sprite($atk_area/atk_view, $Sprite2D_test.global_position, offset, $Sprite2D_test.get_angle_to(mid), PI * -0.5)
				$atk_area/atk_view.texture = load("res://assets/20251126test_shield_smallF.png")#upper end to player
			else:
				move_rotate_sprite($atk_area/atk_view, $Sprite2D_test.global_position, offset, midLine_rotation, PI * 0.25)
				$atk_area/atk_view.texture = load("res://assets/20251126test_swort_small+diagonal.png")#handle to player
			return
		1:#arch
			move_rotate_sprite($atk_area/atk_view, $Sprite2D_test.global_position, offset, $Sprite2D_test.get_angle_to(mid), PI * 0.25)
			$atk_area/atk_view.texture = load("res://assets/20251126test_wand_nature_blue_small+diagonal.png")
			return
	print("NOT FOUND")
	$atk_area/atk_view.visible = false
	return

#-------------------------------------------------------------------------------
# rotate a sprite around a pivot point with an offset, 
# so that the right of the sprite allways looks in the direction of the pivo_rot + self_rot
# self_rot = - pivo_rot sprite stays right to right
func move_rotate_sprite(sprite:Sprite2D, pivo_pos:Vector2, offset_:float, pivo_rot:float, self_rot:float):
	sprite.rotate(pivo_rot)
	var new_pos= Vector2(cos(pivo_rot), sin(pivo_rot)) * offset_
	sprite.global_position = pivo_pos + new_pos
	sprite.rotate(self_rot)
