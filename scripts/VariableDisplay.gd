extends Node2D

var game: Node2D
var labels: Dictionary = {}

func _ready():
	# Make better
	game = $'../..'

func _process(delta):
	if not visible:
		return
	var nodes: Array = game.get_children()
	for node in nodes:
		if node is Circle:
			write_label(node)
			position_label(node)
	
	# Clean up any labels of nodes that were deleted

func get_label(node: Circle) -> Label:
	if not node:
		return null
	
	var label: Label = labels.get(node.name)
	if !label:
		label = load('res://scenes/Control/DebugLabel.tscn').instance()
		label.add_color_override('font_color', Color(0,1,0))
		labels[node.name] = label
		add_child(label)
	return label

func position_label(node: Circle) -> void:
	var label: Label = get_label(node)
	label.rect_position.x = node.position.x + node.radius
	label.rect_position.y = node.position.y - node.radius

func write_label(node: Circle) -> void:
	if !node || !node.get('debug_properties'):
		return
	var label: Label = get_label(node)
	var text: String = '%s\n' % node.name	
	for property in node.debug_properties:
		text = '%s%s: %s\n' % [text, property, node.get(property)]
	
	label.text = text
		
	
