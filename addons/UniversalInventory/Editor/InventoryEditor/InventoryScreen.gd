tool
extends MarginContainer

var item_editor
var empty_screen

# Called when the node enters the scene tree for the first time.
func _ready():
	item_editor = $HSplitContainer/Item
	item_editor.hide()
	
	empty_screen = $HSplitContainer/CenterContainer
	empty_screen.show()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_Tree_select_item(data, path):
	item_editor.show()
	empty_screen.hide()
	item_editor.data = data
	item_editor.path = path
	

# Close the item that's open if it's a sub of the category closed or if it's the item deleted 
# (currently doesn't work right)
func _on_DeleteItem_delete_item(path, id = null):
	var item = $HSplitContainer/Item
	var in_path = true
	for i in range(len(path)):
		if item.path[i] != path[i]:
			in_path = false
	
	if (id == item.data.id or id == null) and in_path:
		item_editor.hide()
		empty_screen.show()
		item_editor.data = {}
		item_editor.path = [] 
