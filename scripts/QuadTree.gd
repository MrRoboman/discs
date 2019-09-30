extends Node2D
class_name QuadTree

var center:Vector2
var half_width:float
var half_height:float
var children
var nodes:Array
var max_nodes_in_quad:int

func init(_center:Vector2, _width:float, _height:float, _nodes:Array = [], _max_nodes_in_quad:int = 4) -> QuadTree:
	center = _center
	half_width = _width / 2
	half_height = _height / 2
	nodes = []
	children = null
	max_nodes_in_quad = _max_nodes_in_quad
	
	add_nodes(_nodes)
	
	return self

func add_nodes(_nodes:Array) -> void:
	for node in _nodes:
		add_node(node)

func add_node(_node) -> void:
	if children:
		for child in children:
			if child.contains(_node):
				child.add_node(_node)
	else:
		nodes.push_back(_node)
	
	if nodes.size() > max_nodes_in_quad:
		divide()

func divide() -> void:
	var quad_tree_class = load(get_script().resource_path)
	children = [
		quad_tree_class.new().init(Vector2(center.x - half_width / 2, center.y - half_height / 2), half_width, half_height),
		quad_tree_class.new().init(Vector2(center.x + half_width / 2, center.y - half_height / 2), half_width, half_height),
		quad_tree_class.new().init(Vector2(center.x - half_width / 2, center.y + half_height / 2), half_width, half_height),
		quad_tree_class.new().init(Vector2(center.x + half_width / 2, center.y + half_height / 2), half_width, half_height),
	]
	
	while nodes.size():
		var node = nodes.pop_back()
		add_node(node)

func contains_point(point:Vector2) -> bool:
	return (
		point.x >= center.x - half_width and 
		point.x <= center.x + half_width and 
		point.y >= center.y - half_height and 
		point.y <= center.y + half_height
	)

func contains(node) -> bool:
	return (
		contains_point(node.top_left()) or 
		contains_point(node.top_right()) or
		contains_point(node.bottom_left()) or
		contains_point(node.bottom_right())
	)

func get_node_groups() -> Array:
	var node_groups = []
	if nodes.size():
		node_groups.push_back(nodes)
	elif children:
		for child in children:
			var child_node_groups = child.get_node_groups()
			for group in child_node_groups:
				if group.size():
					node_groups.push_back(group)
	
	return node_groups

func get_rects() -> Rect2:
	var rects = [Rect2(center.x - half_width + 1, center.y - half_height + 1, half_width * 2 - 2, half_height * 2 - 2)]
	if children:
		for child in children:
			var child_rects = child.get_rects()
			for rect in child_rects:
				if children:
					rects.push_back(rect)
				elif nodes.size():
					for node in nodes:
						rects.push_back(rect)
	return rects

func print_tree(i = 0):
	if children:
		for child in children:
			child.print_tree(i+1)
	else:
		print(i)
		for n in nodes:
			print(n.name)

func clear() -> void:
	if children:
		for child in children:
			child.clear()
	else:
		nodes = []