extends Control
class_name VariableControl

var instance:Circle
var property:String
var instances:Array = []
export var instance_name:String
export var prop_name:String
export var prop_val:float
export var prop_min:float
export var prop_max:float
var game

func setup():
	game = $'../../../..'
	for node in game.get_children():
		if node.name.find(instance_name) > -1:
			instances.push_back(node)
	$Label.text = prop_name
	$LineEdit.text = String(instances[0].get(prop_name))
	$LineEdit.connect('text_changed', self, '_on_LineEdit_text_changed')

func init(node:Circle, prop:String):
	instance = node
	property = prop
	$Label.text = prop
	$LineEdit.text = String(node.get(prop))
	$LineEdit.connect('text_changed', self, '_on_LineEdit_text_changed')

func add_instances(_instances):
	instances = _instances

func _on_LineEdit_text_changed(new_text):
	if instances:
		for inst in instances:
			inst.set(prop_name, float(new_text))
	else:
		instance.set(property, float(new_text))
