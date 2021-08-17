tool
extends Tree

var rmb_popup_menus = {}

var character_icon
var topic_icon
var conversation_icon

signal select_item(data, path)

signal create_item(path)
signal delete_item(path, item_name, type)

func _ready():
	
	create_rmb_context_menus()
	
	var modifier = ''
	var _scale = get_constant("inspector_margin", "Editor")
	_scale = _scale * 0.125
	rect_min_size.x = 150
	if _scale == 1.25:
		modifier = '-1.25'
		rect_min_size.x = 180
	if _scale == 1.5:
		modifier = '-1.25'
		rect_min_size.x = 250
	if _scale == 1.75:
		modifier = '-1.25'
		rect_min_size.x = 250
	if _scale == 2:
		modifier = '-2'
		rect_min_size.x = 360
	rect_size.x = 0
	
	build_folders()

func build_files(data, folder, file_path = []):
	if 'categories' in data:
		for category in data.categories:
			var new_folder = create_item(folder)
			new_folder.set_icon(0, get_icon("Folder", "EditorIcons"))
			new_folder.set_metadata(0, {'path': file_path, 'id': category.id, 'type': 'Folder'})
			new_folder.set_text(0, category.name if 'name' in category else '')
			
			var new_path = file_path.duplicate()
			new_path.push_back(category.id)
			build_files(category, new_folder, new_path)
			
	if 'items' in data:
		for item in data.items:
			var item_node = create_item(folder)
			item_node.set_icon(0, get_icon("Bone2D", "EditorIcons"))
			item_node.set_metadata(0, {"data": item, 'path': file_path, 'type': 'Item'})
			item_node.set_text(0, item.name if 'name' in item else 'No Name')
	
#	Do variables in the drop down menu 
#	if 'variables' in data:
#		var variables_node = create_item(folder)
#		variables_node.set_icon(0, get_icon("TileMap", "EditorIcons"))
#		variables_node.set_metadata(0, {'data': data.variables, 'path': file_path, 'type': 'Variables'})
#		variables_node.set_text(0, 'Variables')


func build_folders():
	self.clear()
	var root = create_item()
	
	# Build Items that are 
	var items = create_item(root)
	items.set_metadata(0, {'type': "Root"})
	items.set_text(0, "Items")
	
	var items_data = InventoryResources.load_json(
		InventoryResources.get_path("RESOURCES_DIR", 'items')
	)
	
	build_files(items_data, items)


# Menus that pull up when right mouce button is pressed
func create_rmb_context_menus():
	var root_popup = PopupMenu.new()
	root_popup.add_icon_item(get_icon("Filesystem", "EditorIcons"), "Show in File Manager")
	root_popup.add_icon_item(get_icon("Add", "EditorIcons"), "Add Category")
	root_popup.add_icon_item(get_icon("Add", "EditorIcons"), "Add Item")
	add_child(root_popup)
	rmb_popup_menus["Root"] = root_popup
	root_popup.connect("id_pressed", self, "_on_root_menu_item_pressed")
	
	var item_popup = PopupMenu.new()
	item_popup.add_icon_item(get_icon("Edit", "EditorIcons"), "Edit Item")
	item_popup.add_icon_item(get_icon("Remove", "EditorIcons"), "Delete Item")
	add_child(item_popup)
	rmb_popup_menus["Item"] = item_popup
	item_popup.connect("id_pressed", self, "_on_item_menu_item_pressed")
	
	var folder_popup = PopupMenu.new()
	folder_popup.add_icon_item(get_icon("Add", "EditorIcons"), "Add Category")
	folder_popup.add_icon_item(get_icon("Add", "EditorIcons"), "Add Item")
	folder_popup.add_icon_item(get_icon("Remove", "EditorIcons"), "Delete Category")
	add_child(folder_popup)
	rmb_popup_menus["Folder"] = folder_popup
	folder_popup.connect("id_pressed", self, "_on_folder_menu_item_pressed")

func create_new_item(path: Array = []):
	var item_id = 0
	var items = InventoryResources.get_items(path)
	var ids = []
	
	# Ew you loop it 2 times, when that's a bit pointless
	for item in items:
		if 'id' in item:
			ids.append(int(item.id))
	while true:
		if item_id in ids:
			item_id += 1
		else:
			break
	InventoryResources.set_item({'id': item_id}, path)
	build_folders()
	
func _on_root_menu_item_pressed(id):
	var item = get_selected()
	var data = item.get_metadata(0) if item != null else ''

	# If it's show in file manager
	if id == 0:
		view_in_file_manager()
	
	# If it's add category
	elif id == 1:
		emit_signal('create_item')
	
	# If it's add item
	else:
		create_new_item()

func _on_item_menu_item_pressed(id):
	var item = get_selected()
	var data = item.get_metadata(0) if item != null else ''
	
	# Edit item is clicked
	if id == 0:
		_on_Tree_item_activated()
		
	# If remove item is clicked and then rebuild the folders
	else:
		emit_signal('delete_item', data.path, data.data.id, 'Items')
	
func _on_folder_menu_item_pressed(id):
	var item = get_selected()
	var data = item.get_metadata(0) if item != null else ''
	
	# If add category is pressed 
	if id == 0:
		var new_path = data.path.duplicate()
		new_path.append(data.id)
		emit_signal('create_item', new_path)

	# If add item is pressed
	elif id == 1:
		var new_path = data.path.duplicate()
		new_path.append(data.id)
		create_new_item(new_path)
	
	# If Delete is pressed
	else:
		emit_signal("delete_item", data.path, data.id, 'Folder')

func view_in_file_manager():
	var item = get_selected()
	var data = item.get_metadata(0) if item != null else ''
	OS.shell_open(String('file://') + 
		ProjectSettings.globalize_path(
			InventoryResources.get_path("RESOURCES_DIR")
		)
	)

# When an item is selected check to see if it
func _on_Tree_item_activated():
	var item = get_selected()
	var data = item.get_metadata(0) if item != null else ''
	
	if 'type' in data and data.type == 'Item':
		emit_signal('select_item', data.data, data.path)


func _on_Tree_item_rmb_selected(position):
	var item = get_selected()
	var data = item.get_metadata(0) if item != null else ''
	
	if data and 'type' in data:
		rmb_popup_menus[data.type].rect_position = get_viewport().get_mouse_position()
		rmb_popup_menus[data.type].popup()
		
