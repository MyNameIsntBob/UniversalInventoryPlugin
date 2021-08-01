extends HBoxContainer

var data : Dictionary = {} setget set_data
var id : int

signal data_changed(data, id)
signal image_removed(id)

func _ready():
	$DeleteButton.icon = get_icon("Remove", "EditorIcons")

# If Delete is pressed delete this item
func _on_DeleteButton_pressed():
	self.queue_free()
	
# Handled like this just incase anything else tells it to delete it's self. 
func queue_free():
	emit_signal('image_removed', id)
	.queue_free()

# When the name is changed set it
func _on_NameEdit_text_changed(new_text):
	self.data['name'] = new_text
	

func _on_PathEdit_text_changed(new_text):
	self.data['path'] = new_text
	

func _on_CheckBox_toggled(button_pressed):
	self.data["primary"] = button_pressed


func set_data(value):
	data = value
	
	emit_signal('data_changed', value, id)


