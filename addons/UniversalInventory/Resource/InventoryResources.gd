tool
class_name InventoryResources

const RESOURCES_DIR: String = 'res://UniversalInventory'

## *****************************************************************************
##								Save and Load files
## *****************************************************************************

static func load_json(path: String, default: Dictionary={}) -> Dictionary:
	var file := File.new()
	if file.open(path, File.READ) != OK:
		file.close()
		return default
	var data_text: String = file.get_as_text()
	file.close()
	if data_text.empty():
		return default
	var data_parse: JSONParseResult = JSON.parse(data_text)
	if data_parse.error != OK:
		return default
		
	var final_data = data_parse.result
	if typeof(final_data) == TYPE_DICTIONARY:
		return final_data
		
	# If all else fails load the default data
	return default
	
static func set_json(path: String, data: Dictionary):
	var file = File.new()
	var err = file.open(path, File.WRITE)
	if err == OK:
		file.store_line(JSON.print(data, '\t', true))
		file.close()
	return err
	
# Returns an array of item id's
static func get_items(path: Array = []) -> Array:
	var item_path = get_path("RESOURCES_DIR", "items")
	var old_data = load_json(item_path)
	for val in path:
		if not val in old_data:
			return []
			
		old_data = old_data[val]
	return old_data.keys()

static func get_item(item_id: String, default: Dictionary={}) -> Dictionary: 
	item_id = str(item_id)
	var item_path = get_path("RESOURCES_DIR", 'items')
	var data = load_json(item_path)
	return data[item_id] if item_id in data else default

static func set_item(item_id, data: Dictionary, path: Array = []):
	data.type = "item"
	item_id = str(item_id)
	var item_path = get_path("RESOURCES_DIR", 'items')
	var old_data = load_json(item_path)
	var sub_data = old_data
	for val in path:
		if not val in sub_data:
			sub_data[val] = {}
		
		sub_data = sub_data[val]
	sub_data[item_id] = data
	set_json(item_path, old_data)
	
static func add_category(name, path: Array = []) -> bool:
	var item_path = get_path("RESOURCES_DIR", 'items')
	var old_data = load_json(item_path)
	var sub_data = old_data
	for val in path:
		if not val in sub_data:
			sub_data[val] = {}
		
		sub_data = sub_data[val]
	var success = false
	if ! name in sub_data:
		sub_data[name] = {}
		success = true

	set_json(item_path, old_data)
	return success
	
static func delete_item(item_id, path: Array = []):
	var item_path = get_path("RESOURCES_DIR", 'items')
	var old_data = load_json(item_path)
	var sub_data = old_data
	for val in path:
		sub_data = sub_data[val]
	sub_data.erase(item_id)
	set_json(item_path, old_data)
	
## *****************************************************************************
##								Get Paths
## *****************************************************************************

static func get_path(name: String, extra: String = '') -> String:
	var paths: Dictionary = get_working_directories()
	if extra != '':
		return paths[name] + '/' + extra
	else:
		return paths[name]
	
static func init_dialog_files() -> void:
	var directory = Directory.new()
	var paths = get_working_directories()
	
	for dir in paths:
		if not directory.dir_exists(paths[dir]):
			directory.make_dir_recursive(paths[dir])

static func get_working_directories() -> Dictionary:
	return {
		'RESOURCES_DIR': RESOURCES_DIR,
#		'CHAR_DIR': RESOURCES_DIR + '/characters'
	}
	
