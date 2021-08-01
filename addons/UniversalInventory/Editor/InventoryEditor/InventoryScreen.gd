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



func _on_Tree_select_item(data, path, id):
	item_editor.show()
	empty_screen.hide()
	item_editor.data = data
	item_editor.path = path
	item_editor.id = id

