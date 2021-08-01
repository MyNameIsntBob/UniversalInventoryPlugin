#extends '../Inventory.gd'
extends '../Inventory.gd'

var GRID = preload("GridInventory.tscn")

# Grid inventory values, Find out how to not show them when not grid
export var slot_image : StyleBox setget set_slot_image 
export var inventory_size : int = 8 setget set_inventory_size
export var columns : int = 4 setget set_columns
export var slot_size : Vector2 = Vector2(10, 10) setget set_slot_size
export var spacing : Vector2 = Vector2(5, 5) setget set_spacing

func _ready():
	print("ready")
	pass
	
func _enter_tree():
	print("enter_tree")

func set_spacing(value: Vector2):
	
#	get_child(0).set_spacing(value)
	spacing = value
	
func set_slot_size(value: Vector2):
#	get_child(0).set_slot_size(value)
	slot_size = value

func set_inventory_size(value: int):
#	get_child(0).set_inventory_size(value)
	inventory_size = value

func set_columns(value: int):
#	get_child(0).columns = value
	columns = value

func set_slot_image(value: StyleBox):
#	get_child(0).set_slot_image(value)
	slot_image = value
