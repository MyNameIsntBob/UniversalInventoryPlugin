extends Panel

var data : Dictionary setget set_data
var path : Array setget set_path
var id : String setget set_id

export (NodePath) var path_node_path
export (NodePath) var id_node_path
export (NodePath) var name_node_path
export (NodePath) var description_node_path
export (NodePath) var stack_size_node_path
export (NodePath) var weight_node_path
export (NodePath) var value_node_path

var path_node
var id_node
var name_node
var description_node
var stack_size_node
var weight_node
var value_node

signal item_saved()

func _ready():
	path_node = get_node(path_node_path)
	id_node = get_node(id_node_path)
	name_node = get_node(name_node_path)
	description_node = get_node(description_node_path)
	stack_size_node = get_node(stack_size_node_path)
	weight_node = get_node(weight_node_path)
	value_node = get_node(value_node_path)


func set_id(new_id):
	if is_instance_valid(id_node):
		id_node.text = new_id
	id = new_id


func set_path(new_path):
	if is_instance_valid(path_node):
		path_node.text = 'Path: ' + PoolStringArray(new_path).join('/')
	path = new_path


# Doesn't call change data as that will cause a loop
func change_data(value, data_name):
	print("Name: ", data_name)
	print("Value: ", value)
	data[data_name] = value


func set_data(new_data):
	if is_instance_valid(name_node):
		name_node.text = new_data.name if 'name' in new_data else ''
	if is_instance_valid(description_node):
		description_node.text = new_data.description if 'description' in new_data else ''
#	if is_instance_valid(stack_size_node):
#		stack_size_node.value = new_data.stack_size if 'stack_size' in new_data else ''
#	if is_instance_valid(weight_node):
#		weight_node.text = new_data.weight if 'weight' in new_data else ''
#	if is_instance_valid(value_node):
#		value_node.text = new_data.value if 'value' in new_data else ''


func save_data():
	InventoryResources.set_item(id, data, path)
	emit_signal("item_saved")

func _on_TextEdit_text_changed():
	if is_instance_valid(description_node):
		change_data(description_node.text, 'description')


func delete_item():
	InventoryResources.delete_item(id, path)
