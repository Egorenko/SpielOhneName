extends Area2D
class_name pHitbox


var damage:int
var cooldown:float
var cooldown_over:bool = true

func _process(_delta: float) -> void:
	'if area_entered:
		print("STILL IN")'
	'if area_shape_entered:
		print("?")'
	pass

func attack(_damage:int, hitbox_lifetime:float, _cooldown = null) -> void:
	damage = _damage
	if _cooldown and _cooldown is float:
		cooldown = _cooldown
	else:
		cooldown = 0.0
	
	if not cooldown_over:
		print("-------------------------------------")
		return
	print("attack")
	on()
	cooldown_start()
	#is active as long as
	if hitbox_lifetime > 0.0:
		var timer = Timer.new()
		add_child(timer)
		timer.one_shot = true
		timer.timeout.connect(off)
		timer.call_deferred("start", hitbox_lifetime)
		
	#unable to activate as long as
	if cooldown > 0.0:
		var ctimer = Timer.new()
		add_child(ctimer)
		ctimer.one_shot = true
		ctimer.timeout.connect(cooldown_end)
		ctimer.call_deferred("start", cooldown)
	else:
		cooldown_end()

#see if hit?
func _ready() -> void:
	off()
	area_entered.connect(_on_area_entered)
	
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, true)

#
func off() -> void:
	#print("OFF")
	for node:Object in self.get_children():
		if node is Timer:
			continue
		if node is CanvasItem:
			node.disabled = true
	monitoring = false
	monitorable = false

#
func on() -> void:
	#print("ON")
	for node:Object in self.get_children():
		if node is Timer:
			continue
		if node is CanvasItem:
			node.disabled = false
	monitoring = true
	monitorable = true

#
func cooldown_end() -> void:
	cooldown_over = true

#
func cooldown_start() -> void:
	cooldown_over = false

func set_damage(dmg:int) -> void:
	damage = dmg

#do when hit
func _on_area_entered(area:Area2D) -> void:
	if self.owner == area.owner:
		print("CAN'T HIT IT SELF")
		return
	print(self.owner)
	print(area.owner)
	if not area.has_method("take_damage"):#equals "check if hurtbox"
		return
	print("---------------------HIT-------------------")
	area.take_damage(damage)
