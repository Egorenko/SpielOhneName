extends Resource
class_name find_shape_stats

##max distance a vertex can diviate from start-end-line
@export var line_noise:float = 0-0
##percentage of equality between start/end (1 -> perfect in middle | 0.0 -> distance to sstart/end irrelevant)
@export var middle_noise:float = 0.0
##min distance most closest vertex (out of line_noise) needs to have
##do be accepted
@export var min_dis_border:float = 0.0
##max distance most farthest away vertex is allowed to have
##to be accepted
@export var max_dis_border:float = 0.0
##one point has to be atleast this far away
@export var max_dis_not_allowed:float = 0.0
