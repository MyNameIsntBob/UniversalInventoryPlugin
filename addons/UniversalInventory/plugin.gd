tool
extends EditorPlugin

const InventoryScreen = preload("Editor/InventoryEditor/InventoryScreen.tscn")
var inventory_screen

const InventoryNode = preload("Nodes/Inventory.gd")

func _enter_tree():
	inventory_screen = InventoryScreen.instance()
	get_editor_interface().get_editor_viewport().add_child(inventory_screen)
	make_visible(false)
	
	add_custom_type(
		"Inventory", 
		"Node2D", 
		InventoryNode, 
		get_editor_interface().get_base_control().get_icon("Node2D", "EditorIcons")
	)

	InventoryResources.init_dialog_files()
#	InventoryResources.set_item({'id': 2, 'Name': "Long Bow", 'hp': 6}, [1])
#	InventoryResources.set_item({'id': 1, 'Name': "Chest Plate", 'Armor': 3}, [1, 1])


func _exit_tree():
	if inventory_screen:
		inventory_screen.queue_free()

	remove_custom_type("Inventory")

func make_visible(visible):
	if inventory_screen:
		inventory_screen.visible = visible
		
func has_main_screen():
	return true

func get_plugin_name():
	return "Universal Inventory"

func get_plugin_icon():
	return get_editor_interface().get_base_control().get_icon("Node", "EditorIcons")
