tool
extends Node2D
class_name Inventory

enum InventoryTypes {
	Grid,
	Tetris,
	Wheel,
	List
}

var scripts = [
	load("res://addons/UniversalInventory/Nodes/Grid/GridManager.gd")#,
#	load("res://addons/UniversalInventory/Nodes/List/ListManager.gd")
]

# An array of the item groups that the inventory is limited to.
export (Array, Image) var items_path

export (InventoryTypes) var inventory_type = 0 setget set_inventory_type

func _ready():
	self.inventory_type = InventoryTypes.Grid

func set_inventory_type(type: int):
	inventory_type = type
	if type <= len(scripts) - 1:
		set_script(scripts[inventory_type])
		
	else:
		set_script(load("res://addons/UniversalInventory/Nodes/Inventory.gd"))
#	if type == InventoryTypes.Grid:
#		self.current_inventory = GRID.instance()
#	else:
#		self.current_inventory = null
#		return
	
#	self.add_child(current_inventory)
