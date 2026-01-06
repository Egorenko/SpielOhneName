extends Line2D
class_name line_shape

##Is the noise in degree between
##line1 (p[n-1] - p[n]) and line2 (p[n] - p[n+1])
var degree_noise:float
##Contains all angles, that are bigger, 
##then the degree_noise
##Vec3 = Vec2 (vertex,where th angle is) + float (angle)
var angles:Array[Vector3]

var core_vectors:Array[Vector2]
##wip
var core_starts:Array[Vector2]
var core_end:Array[Vector2]

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func normalize() -> void:
	pass

#from points[1] to points[points.size-1]
func compute_core() -> void:
	pass
