tool
extends GridContainer

var variables : Dictionary

const VARIABLE = preload("Variable.tscn")

func build_variables(data: Dictionary, item_path: Array = []):
	# Remove all variables to make place for new ones
	for node in get_children():
		remove_child(node)
		node.queue_free()
	
	# Will be built up by something else later. 
	var new_variables = ['StackSize', "Weight", "Value"]
	
	for var_name in new_variables:
		var var_node = VARIABLE.instance()
		add_child(var_node)
		var_node.var_name = var_name
		var_node.value = data[var_name] if var_name in data else ''
		var_node.connect("value_changed", self, 'change_data')
