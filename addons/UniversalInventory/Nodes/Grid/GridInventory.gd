tool
extends GridContainer

var item : Dictionary

var SLOT = preload("Slot.tscn")

func set_inventory_size(value: int):
	var children = get_children()
	while len(children) > value:
		children.pop_front().queue_free()
	
	while len(children) < value:
		var new_slot = SLOT.instance()
		self.add_child(new_slot)
		children.push_back(new_slot)
	
	self.rect_size = Vector2(0, 0)

func set_spacing(value: Vector2):
	add_constant_override("hseparation", value[0])
	add_constant_override("vseparation", value[1])

func set_slot_size(value: Vector2):
	
	for child in get_children():
		child.rect_min_size = value
		child.rect_size = value

func set_slot_image(value: StyleBox):
	for slot in get_children():
		slot.set_stylebox('panel', '', value)
