extends Control

onready var game: Game = $"../.."
onready var variable_display = $"../VariableDisplay"
var variable_display_visible
var x: float = 60
var y: float = 60


func _ready():
	pass

func toggle():
	visible = !visible
	if visible:
		variable_display_visible = variable_display.visible
		variable_display.visible = true
	else:
		variable_display.visible = variable_display_visible
	
func create_panel(node: Circle) -> void:
	var label: Label = load('res://scenes/Control/DebugLabel.tscn').instance()
	label.text = node.name
	label.rect_position = Vector2(x, y)
	add_child(label)
	y += 70
	for prop in node.debug_properties:
		var variable_control: VariableControl = load('res://scenes/VariableControl.tscn').instance()
		variable_control.init(node, prop)
		variable_control.rect_position = Vector2(x, y)
		add_child(variable_control)
		y += 150
	
	

func _on_Game_created_circle(node: Circle):
	create_panel(node)
