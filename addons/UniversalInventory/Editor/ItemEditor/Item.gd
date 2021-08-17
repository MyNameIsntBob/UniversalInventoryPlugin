tool
extends Panel

var data : Dictionary setget set_data
var path : Array setget set_path

export (NodePath) var path_node_path
export (NodePath) var id_node_path
export (NodePath) var name_node_path
export (NodePath) var description_node_path
export (NodePath) var variables_nodes_path

var path_node
var id_node
var name_node
var description_node
var variables_node

signal item_saved()
signal delete_item(path, item_name, type)

func _ready():
	path_node = get_node(path_node_path)
	id_node = get_node(id_node_path)
	name_node = get_node(name_node_path)
	description_node = get_node(description_node_path)
	variables_node = get_node(variables_nodes_path)
#	build_variables()


func set_path(new_path):
	if is_instance_valid(path_node):
		path_node.text = 'Path: ' + PoolStringArray(new_path).join('/')
	path = new_path


# Doesn't call change data as that will cause a loop
func change_data(value, data_name):
	data[data_name] = value


func set_data(new_data):
	if is_instance_valid(name_node):
		name_node.text = new_data.name if 'name' in new_data else ''
	if is_instance_valid(description_node):
		description_node.text = new_data.description if 'description' in new_data else ''

#	for key in variables.keys():
#		if key in data:
#			variables[key]

	if is_instance_valid(id_node) and 'id' in new_data:
		id_node.text = str(new_data.id)

#	for node in variables_node.get_children():
#		var val_node = node.get_node("SpinBox")
#		if node.name in new_data:
#			val_node.value = new_data[node.name]
		
	data = new_data
	
	variables_node.build_variables(data, path)
#	if is_instance_valid(stack_size_node):
#		stack_size_node.value = new_data.stack_size if 'stack_size' in new_data else ''
#	if is_instance_valid(weight_node):
#		weight_node.text = new_data.weight if 'weight' in new_data else ''
#	if is_instance_valid(value_node):
#		value_node.text = new_data.value if 'value' in new_data else ''


func save_data():
	InventoryResources.set_item(data, path)
	emit_signal("item_saved")

func _on_TextEdit_text_changed():
	if is_instance_valid(description_node):
		change_data(description_node.text, 'description')


func delete_item():
	emit_signal('delete_item', path, data.id, 'Items')
#	InventoryResources.delete_item(data.id, path)

