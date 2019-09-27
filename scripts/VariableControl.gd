extends Control

export (NodePath) var instance_path
export (String) var variable_name
var instance

func _ready():
	instance = get_node(instance_path)
	$Label.text = '%s: %s' % [instance.name, variable_name]
	$LineEdit.text = '%s' % instance.get(variable_name)
	pass


func _on_LineEdit_text_changed(new_text):
	instance.set(variable_name, int(new_text))
	pass # Replace with function body.
