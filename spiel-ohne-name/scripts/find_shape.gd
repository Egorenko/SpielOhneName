class_name find_shape extends Line2D

enum SHAPES{
	line = 0,
	arch = 1,
	
	undefined = -1,
}

var line_noise:float
var middle_noise:float

var min_dis_border:float
var max_dis_border:float

var max_dis_not_allowed:float

var start_vertex:Vector2
var end_vertex:Vector2
var help_vector:Vector2

var max_dis:float = 0
var max_dis_vertex:Vector2 = Vector2(0.0, 0.0)
var max_dis_pos:float = 0
var max_dis_pos_vertex:Vector2 = Vector2(0.0, 0.0)
var max_dis_neg:float = 0
var max_dis_neg_vertex:Vector2 = Vector2(0.0, 0.0)

func _init(_line_noise:float, _middle_noise:float, _min_dis_border:float, _max_dis_border:float, _max_dis_not_allowed:float) -> void:
	line_noise = _line_noise
	middle_noise = _middle_noise
	min_dis_border = _min_dis_border
	max_dis_border = _max_dis_border
	max_dis_not_allowed = _max_dis_not_allowed
	analyse_by_distance()
	return

##Return, if it could be analysed
##Safes the max distance of all Points to a Line, formed by the first and last Point
##Safes:
##The Point with the absolut max distance (and its distance)
## max_dis_vertex (max_dis)
##The Point with the max positive distance (and its distance)
## max_dis_pos_vertex (max_dis_pos)
##The Point with the max negative distance (and its distance)
## max_dis_neg_vertex (max_dis_neg)
##WARNIG: these values are only reset, if this method is reused
func analyse_by_distance() -> bool:
	#reset all dis
	max_dis = 0.0
	max_dis_vertex = Vector2(0.0, 0.0)
	max_dis_pos = 0.0
	max_dis_pos_vertex = Vector2(0.0, 0.0)
	max_dis_neg = 0.0
	max_dis_neg_vertex = Vector2(0.0, 0.0)
	
	if not self.points:
		return false
	
	start_vertex = self.points[0]
	end_vertex = self.points[self.points.size()-1]
	help_vector = end_vertex - start_vertex
	
	#red line; visual help
	var help:Line2D = Line2D.new()
	help.points = self.points
	help.width = 1
	help.default_color = Color(255.0, 0.0, 0.0, 255.0)
	add_child(help)
	
	var y2y1:float = (end_vertex.y - start_vertex.y)
	var x2x1:float = (end_vertex.x - start_vertex.x)
	var dis_to_help:float = pow(pow(y2y1, 2) + pow(x2x1, 2), 1.0/2.0)#distance of start-end-line
	
	#get diatance all vertices to line from help_vector(start to end of vertices)
	for vertex:Vector2 in self.points:
		#get distance
		var dis:float = (
			(y2y1 * vertex.x - x2x1 * vertex.y
			+ (end_vertex.x * start_vertex.y)
			- (end_vertex.y * start_vertex.x))
			/dis_to_help
			)
		#safe biggest distance
		if(dis >= 0) and (dis >= max_dis_pos):
			max_dis_pos = dis
			max_dis_pos_vertex = vertex
		#in other direction 
		if(dis <= 0) and (dis <= max_dis_neg):
			max_dis_neg = dis
			max_dis_neg_vertex = vertex
	#get overall max distance
	if max_dis_pos > abs(max_dis_neg):
		max_dis = max_dis_pos
		max_dis_vertex = max_dis_pos_vertex
	else:
		max_dis = abs(max_dis_neg)
		max_dis_vertex = max_dis_neg_vertex
	return max_dis >= max_dis_not_allowed

#all distance smaller noise
func has_all_in_noise() -> bool:
	return (abs(max_dis_neg) <= line_noise) and (max_dis_pos <= line_noise)

func has_max_in_borders() -> bool:
	return (min_dis_border <= max_dis) and (max_dis <= max_dis_border)

func has_max_pos_and_neg() -> bool:
	return (abs(max_dis_neg) > line_noise ) and (abs(max_dis_pos) > line_noise)

func get_dis_start_to_vertex(vertex:Vector2) -> float:
	return start_vertex.distance_to(vertex)

func get_dis_end_to_vertex(vertex:Vector2) -> float:
	return end_vertex.distance_to(vertex)

func has_max_dis_in_middle() -> bool:
	return (get_dis_start_to_vertex(max_dis_vertex) * middle_noise <= get_dis_end_to_vertex(max_dis_vertex))and(get_dis_end_to_vertex(max_dis_vertex) * middle_noise <= get_dis_start_to_vertex(max_dis_vertex))

##returns -1, if shape is not declared
func get_shape_number() -> int:
	if not self.points:
		print("NOTHING") 
		return SHAPES.undefined
	if is_line(): 
		return SHAPES.line
	if is_arch(): 
		return SHAPES.arch
	return SHAPES.undefined

#equal to "has no out of noise"
func is_line() -> bool:
	return has_all_in_noise()

#if one* vertex(in only one direction) too far away -> line has to bend
func is_arch() -> bool:
	return (has_max_dis_in_middle()) and (not has_max_pos_and_neg()) and (has_max_in_borders())
