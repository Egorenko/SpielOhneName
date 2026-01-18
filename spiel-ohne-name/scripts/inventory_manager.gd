extends Node

var inventory:Inventory

func get_inventory() -> Inventory:
	if inventory == null:
		inventory = preload("res://scripts/inventory/inventory_types/inventory_12slots.tres")
		inventory.ready()
	return inventory
