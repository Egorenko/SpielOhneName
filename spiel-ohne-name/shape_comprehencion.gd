extends CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# finds what shape array could make
func processShape(array:Array[Vector2], line_noise:float, ex_noise:float, minDis_shape:float, maxDis_shape:float) -> int:
	var start:Vector2 = array.front()
	var end:Vector2 = array.back()
	var y2y1:float = (end[1]-start[1])
	var x2x1:float = (end[0]-start[0])
	
#visual help ->
	var correctLine = Line2D.new()
	correctLine.points = array
	correctLine.width = 1.0
#<- visual help

	var maxDis_vector_positive:Vector3#safe vertex[0][1] AND its distance to line[2]
	var maxDis_vector_negative:Vector3
	
	var start_end_dis:float = pow(pow(y2y1, 2) + pow(x2x1, 2), 1.0/2.0)#distance of start-end-line
	var maxDis:float = 0.0
	var maxDisV:Vector2 = Vector2(0.0, 0.0)
	
#test nois per vertex ->
	for vertex in array:
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
	if maxDis > maxDis_shape:
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
	if maxDis >= line_noise and maxDis >= minDis_shape:
		correctLine.default_color = Color(0.0,255.0,0.0,255.0)
		get_parent().add_child(correctLine)
		print("ARCH")
		return 1#1 = NOT straight
	print("DID NOT FIND SHAPE")
	return -1
