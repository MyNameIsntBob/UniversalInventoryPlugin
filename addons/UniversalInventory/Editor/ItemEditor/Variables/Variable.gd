tool
extends HBoxContainer

var var_name setget set_var_name
var value setget set_value
var deletable : bool = false setget set_deletable

signal value_changed(value, var_name)


func set_deletable(new_value: bool):
	deletable = new_value 
	$Button.visible = new_value

func set_var_name(new_name):
	$Label.text = new_name + ":"
	var_name = new_name
	
func set_value(new_value):
	value = new_value
	
	# Might be a bad idea, we'll see
	$LineEdit.text = new_value
	
	emit_signal("value_changed", new_value, var_name)


func _on_LineEdit_text_changed(new_text):
	self.value = new_text
