extends Sprite2D

var ai:UtilityAIAgent
var sensor_distance_to_target:UtilityAISensor
var current_action:UtilityAIAction
var speed:float
var target_position:Vector2

signal picked_up_item


func _ready():
	ai = $UtilityAIAgent
	sensor_distance_to_target = $UtilityAIAgent/DistanceToTarget
	current_action = null
	speed = 0.0
	target_position = Vector2.ZERO


func _process(delta):
	# Sense
	var vec_to_target = target_position - position 
	var distance = vec_to_target.length()
	sensor_distance_to_target.sensor_value = distance / 1000.0
	
	# Think
	ai.evaluate_options(delta)
	ai.update_current_behaviour()
	
	# Act
	if current_action == null:
		return
	
	# Update the position
	position += delta * speed * vec_to_target.normalized()
	
	# Update otherwise based on current action.
	if current_action.name == "Move":
		if distance <= 4.0:
			current_action.is_finished = true
	elif current_action.name == "Pickup":
		emit_signal("picked_up_item")
		current_action.is_finished = true



func _on_utility_ai_agent_action_changed(action_node):
	if action_node == current_action:
		return
	if current_action != null:
		end_action(current_action)
	current_action = action_node
	if current_action != null:
		start_action(current_action)


func start_action(action_node):
	if action_node.name == "Beweg":
		speed = 100.0
	elif action_node.name == "Kampf":
		speed = 0.0


func end_action(action_node):
	if action_node.name == "Beweg":
		pass
	elif action_node.name == "Kampf":
		pass
