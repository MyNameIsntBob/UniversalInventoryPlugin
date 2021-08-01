tool
extends ConfirmationDialog

var path : Array
var item_name : String

signal delete_item(id, path)

func request_confirm(path: Array = [], item_name: String = '', type: String = ''):
	self.rect_size = Vector2.ZERO 
	
	if type == 'Item':
		window_title = 'Delete Item?'
		dialog_text = 'Are you sure you wish to delete this item? \n This can\'t be undone!'
	if type == "Folder":
		window_title = 'Delete Category?'
		dialog_text = "Are you sure you wish to delete this category? \n All items in this category will also be deleted."
	
	self.path = path
	self.item_name = item_name
	self.rect_position = get_viewport().get_mouse_position() - (rect_size / 2)
	self.popup()

# Should be able to delete categories too
func _on_DeleteItem_confirmed():
	emit_signal("delete_item", item_name, path)
