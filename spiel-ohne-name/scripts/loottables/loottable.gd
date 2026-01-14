##Saves Items with their amount and chance to drop
class_name Loot_Table extends Resource

@export var loot:Array[Inventory_item]
@export var quantity:Array[int]
##Fills all missing propabilitys so, that they combine to 100%
@export var fill_propability:bool = true
@export var propability:Array[float]
var overall_propability:float = 0.0
var prop_given:int = 0

func ready() -> void:
	clean()
	get_overall_propability()
	complete_propability()
	get_overall_propability()

func get_overall_propability() -> float:
	prop_given = 0
	overall_propability = 0.0
	for el in propability:
		if el:
			prop_given += 1
			overall_propability += el
	return overall_propability

func clean() -> void:
	var max_size:int = maxi(loot.size(), maxi(quantity.size(), propability.size()))
	loot.resize(max_size)
	quantity.resize(max_size)
	propability.resize(max_size)
	#find uncomplete/empty lines
	for i in range(loot.size()):
		if not loot[i]:
			quantity[i] = -1
			propability[i] = -1.0
		if quantity[i] <= 0:
			loot[i] = null
			quantity[i] = -1
			propability[i] = -1
	#delete empty line
	loot.erase(null)
	quantity.erase(-1)
	propability.erase(-1)
	#extracheck if all are same size
	if loot.size() == quantity.size() and loot.size() == propability.size():
		#print("all same length")
		pass

func complete_propability() -> void:
	if not fill_propability:
		return
	#get propability of all missing values
	var missing_prop:float = (100.0 - overall_propability) / (propability.size() - prop_given)
	for i in range(loot.size()):
		if loot[i] and quantity[i] > 0 and propability[i] == 0:
			propability[i] = missing_prop

func choose_item() -> Inventory_stack:
	if overall_propability <= 0.0:
		print("overall 0 or negative propability")
		return null
	var r := randf() * overall_propability
	var acc := 0.0
	#go throu every chance until the chance is higher then the random number
	for i in range(loot.size()):
		acc += propability[i]
		if r <= acc:
			var stack:Inventory_stack = Inventory_stack.new(loot[i], quantity[i])
			return stack
	return null
