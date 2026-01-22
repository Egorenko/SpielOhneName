extends entity
class_name NPC

##WIP
@export var Quests:Array[Quest]
##WIP to connect to quest/quest_item
@export var QuestId:int = 0

##return if quest could be given
func give_quest(to:entity) -> bool:
	if "Quests" in to:
		to.Quests.append_array(Quests)
		return true
	return false

##return if quest could be taken
func take_quest(from:entity) -> bool:
	if "Quests" in from:
		Quests.append_array(from.Quests)
		return true
	return false

func on_quest_accept() -> void:
	pass

func on_quest_reject() -> void:
	pass

func on_quest_complete() -> void:
	pass

func on_quest_fail() -> void:
	pass
