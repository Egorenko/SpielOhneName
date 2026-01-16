class_name Health extends  Resource

@export var max_hp:float = 10
@export var hp:float = 10
#just to find changes
var last_hp:float = hp
var last_max_hp:float = max_hp
##If hp is <= min_hp the object is dead
@export var min_hp:float = 0.0

##Border for max_hp
@export var _max:float = TYPE_MAX#max value for float
##Border for max_hp
@export var _min:float = 0.0
#just to find changes

func clamb_hp() -> void:
	hp = minf(max_hp, maxf(hp, min_hp))

func clamb_max_hp() -> void:
	max_hp = minf(_max, maxf(max_hp, _min))

func get_max_hp() -> float:
	return max_hp

func get_hp() -> float:
	return hp

##if mutl == null: "+" else "*"
func increase_max_hp(x:float, mult = null) -> void:
	last_max_hp = max_hp
	if mult:
		max_hp *= x
	else:
		max_hp += x
	clamb_max_hp()

##if mutl == null: "-" else "/"
func decrease_max_hp(x:float, mult = null) -> void:
	last_max_hp = max_hp
	if mult:
		max_hp /= x
	else:
		max_hp -= x
	clamb_max_hp()

##if mutl == null: "+" else "*"
func increase_hp(x:float, mult = null) -> void:
	last_hp = hp
	if mult:
		hp *= x
	else:
		hp += x
	clamb_hp()

##if mutl == null: "-" else "/"
func decrease_hp(x:float, mult = null) -> void:
	last_hp = hp
	if mult:
		hp /= x
	else:
		hp -= x
	clamb_hp()

func is_dead()-> bool:
	return is_equal_approx(hp, min_hp)

func got_changed() -> bool:
	return not (is_equal_approx(hp, last_hp) and is_equal_approx(max_hp, last_max_hp))
