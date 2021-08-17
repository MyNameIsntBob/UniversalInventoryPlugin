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
	
## *****************************************************************************
##							  Manage Data
## *****************************************************************************

static func get_data(type: String, path: Array = []) -> Array:
	var item_path = get_path("RESOURCES_DIR", "items")
	var old_data = load_json(item_path)
	for val in path:
		if 'categories' in old_data:
			old_data = get_by_id(old_data.categories, val)
		
		else:
			return []
			
	if type in old_data:
		return old_data[type]
		
	return []

static func set_data(type: String, data: Dictionary, path: Array = []) -> bool:
	var item_path = get_path("RESOURCES_DIR", "items")
	var old_data = load_json(item_path)
	var sub_data = old_data
	for val in path:
		if 'categories' in sub_data:
			sub_data = get_by_id(sub_data.categories, val)

		else:
			return false

	if type in sub_data:
		var index = get_index_by_id(sub_data[type], data.id)
		if index == -1:
			sub_data[type].append(data)
		else:
			sub_data[type][index] = data

	else:
		sub_data[type] = [data]

	set_json(item_path, old_data)
	return true
	
static func delete_data(type: String, id: int, path: Array = []) -> bool:
	var item_path = get_path("RESOURCES_DIR", "items")
	var old_data = load_json(item_path)
	var sub_data = old_data
	for val in path:
		if 'categories' in sub_data:
			sub_data = get_by_id(sub_data.categories, val)

		else:
			return false

	if type in sub_data:
		sub_data[type].remove(get_index_by_id(sub_data[type], id))
	else:
		return false

	set_json(item_path, old_data)
	return true

## *****************************************************************************
##								Items
## *****************************************************************************
	
# Returns an array of item id's
static func get_items(path: Array = []) -> Array:
	return get_data('items', path)

static func get_item(item_id: int, path: Array = [], default: Dictionary={}) -> Dictionary: 
	var items = get_items(path)
	return get_by_id(items, item_id)

static func set_item(data: Dictionary, path: Array = []) -> bool:
	return set_data('items', data, path)

static func delete_item(item_id: int, path: Array = []) -> bool:
	return delete_data('items', item_id, path)

## *****************************************************************************
##								Variables
## *****************************************************************************

static func get_variables(item, path: Array = []) -> Array:
	var item_path = get_path("RESOURCES_DIR", "items")
	var data = load_json(item_path)
	var variables = []
	for val in path:
		if not val in data:
			data[val] = {}
			
		if 'variables' in data:
			variables += data.variables
		data = data[val]
	return variables

static func delete_variable(var_id: int, path: Array = []) -> bool:
	return delete_data('variables', var_id, path)

static func set_variable(data: Dictionary, path: Array = []) -> bool:
	return set_data("variables", data, path)


## *****************************************************************************
##								Others
## *****************************************************************************
	
static func get_by_id(data: Array, id: int) -> Dictionary:
	for item in data:
		if 'id' in item and item.id == id:
			return item
	return {}
	
static func get_index_by_id(data: Array, id: int) -> int:
	for i in range(len(data)):
		if 'id' in data[i] and data[i].id == id:
			return i
	return -1

# Returns an array of item id's
static func get_categories(path: Array = []) -> Array:
	return get_data('categories', path)

static func set_category(data: Dictionary, path: Array = []) -> bool:
	return set_data("categories", data, path)
#	var item_path = get_path("RESOURCES_DIR", 'items')
#	var old_data = load_json(item_path)
#	var sub_data = old_data
#	for val in path:
#		if 'categories' in sub_data:
#			sub_data = get_by_id(sub_data.categories, val)
#
#		else:
#			return false
#
#	if 'categories' in sub_data:
#		var index = get_index_by_id(sub_data.categories, data.id)
#		if index == -1:
#			sub_data.categories.append(data)
#		else:
#			sub_data.categories[index] = data
#	else:
#		sub_data.categories = [data]
#
#	set_json(item_path, old_data)
#	return true

	
#static func delete_category(id)
	
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
	
