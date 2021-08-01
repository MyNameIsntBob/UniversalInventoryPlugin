tool
extends AcceptDialog

var path : Array 

export (NodePath) var name_node_path

var name_node

signal folder_created()

func _ready():
	name_node = get_node(name_node_path)

func request_confirm(path: Array = []):
	self.rect_size = Vector2.ZERO
	self.path = path
	self.rect_position = get_viewport().get_mouse_position() - (rect_size / 2)
	self.popup()

func notify(message):
	$Notification.popup()
	$Notification.dialog_text = message
	$Notification.window_title = "Unable to Save"
	$Notification.rect_position = get_viewport().get_mouse_position() - ($Notification.rect_size / 2)
	$Notification.rect_size = Vector2.ZERO


func _on_CreateFolder_confirmed():
	var text = name_node.text if is_instance_valid(name_node) else ''
	if text.trim_prefix(' ') == '':
		notify("You must give a name for the category.")
		return
	
	if InventoryResources.add_category(text, path):
		emit_signal('folder_created')
		hide()
	else:
		notify("This folder already exists at the given path.")
