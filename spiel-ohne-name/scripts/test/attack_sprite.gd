class_name attack_sprite extends Sprite2D

var hitbox:pHitbox
var hitbox_rotation:float = 0

func _init(_hitbox:pHitbox) -> void:
	hitbox = _hitbox
	add_child(hitbox)
	if hitbox.hitbox_lifetime > 0.0:#optional (does not delete) continues use
		var timer = Timer.new()
		add_child(timer)
		timer.timeout.connect(queue_free)
		timer.call_deferred("start", hitbox.hitbox_lifetime)

##Applies a rotation only to the hitbox, in radians, starting from its current rotation
func rotate_hitbox(radient:float):
	hitbox.rotate(radient)

##Rotades it self, in radiens, around a local pivotpoint and sets position (NOT global_position)
##if no _offset, uses distance between sprite and pivo_pos
func rotate_around_pivot(pivo_pos:Vector2, pivo_rot:float, _offset = null):
	var offset_dis:float = 0.0
	if _offset and _offset is float:
		offset_dis = _offset
	else:
		offset_dis = pivo_pos.distance_to(self.position)
	self.rotate(pivo_rot)
	var new_pos:Vector2 = Vector2(cos(pivo_rot), sin(pivo_rot)) * offset_dis
	self.position = pivo_pos + new_pos
'
##
func attack(type:int, shape:Line2D, _rotation_noise = null, _start_pos = null, _offset = null) -> void:
	#check rotatioin_noise
	var rotation_noise:float = 0.0
	if _rotation_noise and _rotation_noise is float:
		rotation_noise = _rotation_noise
	
	#check start_pos (pivot point)
	var start_pos:Vector2 = Vector2(0.0, 0.0)
	if _start_pos and _start_pos is Vector2:
		start_pos = _start_pos
	
	#check if offset
	var offset_:float = 0.0
	if _offset and _offset is float:
		offset_ = _offset
	
	var midLine:Vector2 = Vector2(0.0,0.0)
	var midLine_rotation:float = 0.0
	var mid:Vector2 = Vector2(0.0,0.0)
	var start_to_mid:Vector2 = Vector2(0.0,0.0)
	
	if shape.points:
		midLine = shape.points[0] -shape.points[shape.points.size()-1]#direct line from start to end -> middle line
		midLine_rotation = shape.points[0].angle_to_point(shape.points[shape.points.size()-1])
		mid = shape.points[shape.points.size()-1] + midLine*0.5#middle of attackline
		start_to_mid = mid - start_pos#vector for angle player to middle of attackline
	else:
		print("EMPTY SHAPE")
		return
	
	match type:
		-1:
			print("NOT FOUND")
		0:
			print("LINE")
			#angle ray from player to line bigger 90 - noise and smaller 90 + noise
			var start_attack_angle:float = abs(start_to_mid.angle_to(midLine))
			if (PI * 0.5 - rotation_noise <= start_attack_angle) and (start_attack_angle <= PI * 0.5 + rotation_noise):
				rotate_around_pivot(start_pos,start_pos.angle_to_point(mid), offset_)
				rotate(PI * -0.5)
				self.texture = load("res://pictures/20251126test_shield_smallF.png")#upper end to player
			else:
				rotate_around_pivot(start_pos, midLine_rotation, offset_)
				rotate(PI * 0.25)
				rotate_hitbox(-PI * 0.25)
				self.texture = load("res://pictures/20251201test_sword_small+diagonal_thrust.png")#handle to player
		1:
			print("ARCH")
			rotate_around_pivot(start_pos, start_pos.angle_to_point(mid), offset_)
			rotate_hitbox(PI * 0.5)
			self.texture = load("res://pictures/20251201test_sword_small+diagonal_swipe.png")
'

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
