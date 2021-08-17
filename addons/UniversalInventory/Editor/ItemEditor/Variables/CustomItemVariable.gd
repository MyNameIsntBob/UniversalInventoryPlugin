tool
extends HBoxContainer

enum VariableTypes {
	Number, 
	Text,
	Boolean,
	Option # Will be used to allow the user to give the item a variable that gets selected an option type.
}

var var_name : String setget set_name
var value setget set_value

signal change_name(old_name, new_name)
signal change_value(var_name, value)

func _ready():
	$DeleteButton.icon = get_icon("Remove", "EditorIcons")
	set_boolean_button_types()
	set_option_button_types()
	change_type($OptionButton.selected)

# Set the boolean options button options
func set_boolean_button_types():
	$BooleanValue.clear()
	$BooleanValue.add_item("False", 0)
	$BooleanValue.add_item("True", 1)

# Set the option buttion options to be equal to the variable types
func set_option_button_types():
	$OptionButton.clear()
	for type in VariableTypes.keys():
		$OptionButton.add_item(type, VariableTypes[type])

# When ever the type if changes we'll change the showing type to match
func change_type(type: int):
	self.value = null
	$NumberValue.visible = type == VariableTypes.Number
	$StringValue.visible = type == VariableTypes.Text
	$BooleanValue.visible = type == VariableTypes.Boolean
	

# Handle Setting the name. Name field is connected to this.
func set_name(value: String):
	# Emit the old and new names to allow the parent to change the key in the dictionary.
	emit_signal('change_name', var_name, value)
	var_name = value
	
# Handle Setting the value
# All the value fields are connected to this through signals. Except the boolean. 
func set_value(new_value):
	emit_signal("change_value", var_name, value)
	value = new_value

# 0 is false, 1 is true, not not should turn the int into a boolean
func _on_BooleanValue_item_selected(index):
	self.value = !!index
