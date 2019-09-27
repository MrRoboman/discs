extends Control
class_name VariableControl

var instance:Circle
var property:String

func init(node:Circle, prop:String):
	instance = node
	property = prop
	$Label.text = prop
	$LineEdit.text = String(node.get(prop))
	$LineEdit.connect('text_changed', self, '_on_LineEdit_text_changed')


func _on_LineEdit_text_changed(new_text):
	instance.set(property, float(new_text))
