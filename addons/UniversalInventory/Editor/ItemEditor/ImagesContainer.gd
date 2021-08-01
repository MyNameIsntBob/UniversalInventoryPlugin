extends ScrollContainer

# An array of the images that will be used to
var images : Array = []

const IMAGE = preload("Image.tscn")

func new_image(name: String, path: String):
	var new_image = IMAGE.instance()
	$MainContainer/ItemContainer.add_child(new_image)

# Open an option and allow the user to select what file they want to add.
func _on_NewButton_pressed():
	pass
