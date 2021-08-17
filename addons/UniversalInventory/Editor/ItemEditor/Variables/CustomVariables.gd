tool
extends ScrollContainer

const VAR_ITEM = preload("CustomItemVariable.tscn")

var variables : Array = [] setget set_variables

signal change_variables(variables)


func _on_Button_pressed():
	var new_item = VAR_ITEM.instance()
	$VBoxContainer.add_child(new_item)
	$VBoxContainer.move_child($VBoxContainer/ButtonContainer, $VBoxContainer.get_child_count() - 1)

func set_variables(values):
	variables = values
	
	emit_signal('change_variables', variables)
