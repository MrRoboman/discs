extends WindowDialog

signal value_updated

onready var AttributeEdit = load('res://scenes/AttributeEdit.tscn')

func open(data:Dictionary) -> void:
	clear_attribute_edits()
	add_attribute_edits(data)
	show()

func close() -> void:
	clear_attribute_edits()
	hide()

func clear_attribute_edits() -> void:
	var attribute_edits = get_children()
	for ae in attribute_edits:
		remove_child(ae)
		ae.disconnect('value_updated', self, 'on_value_updated')

func add_attribute_edits(data:Dictionary) -> void:
	var y = 0
	for key in data:
		var ae = AttributeEdit.instance()
		ae.init(key, data[key])

		ae.rect_position.y = y
		y = y + ae.rect_size.y

		add_child(ae)
		ae.connect('value_updated', self, 'on_value_updated')
	
	rect_size.y = y

func on_value_updated(args):
	emit_signal('value_updated', args)

func has_point(point:Vector2) -> bool:
	var rect = get_global_rect()
	# HACK: rect should include the title bar.
	rect.position.y -= 20
	rect.size.y += 30
	return rect.has_point(point)

