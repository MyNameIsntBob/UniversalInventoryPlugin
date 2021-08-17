tool
extends ConfirmationDialog

var path : Array
var item_id : int
var type

signal delete_item()
signal close_item(path, id)

func request_confirm(path: Array = [], id: int = 0, type: String = 'Items'):
	self.rect_size = Vector2.ZERO 

	if type == 'Item' or type == 'Items':
		self.type = 'items'
		window_title = 'Delete Item?'
		dialog_text = 'Are you sure you wish to delete this item? \n This can\'t be undone!'
	if type == "Folder":
		self.type = 'categories'
		window_title = 'Delete Category?'
		dialog_text = "Are you sure you wish to delete this category? \n All items in this category will also be deleted."

	self.path = path
	self.item_id = id
	self.rect_position = get_viewport().get_mouse_position() - (rect_size / 2)
	self.popup()

# Should be able to delete categories too
func _on_DeleteItem_confirmed():
	InventoryResources.delete_data(type, item_id, path)
	emit_signal("delete_item")
	path.append(item_id)
	emit_signal("close_item", path, item_id if type == 'items' else null)
	
