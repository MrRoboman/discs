extends Panel

signal value_updated

onready var Tap = get_node('/root/Tap')

var tap_index:int = -1
var og_value:int
var tap_origin:Vector2


func init(attribute_key:String, attribute_value:float) -> void:
	$Label.text = attribute_key
	$LineEdit.text = String(attribute_value)


func _input(event):
	if !visible:
		return
		
	if tap_index == -1 and Tap.is_down(event):
		if point_in_label(event.position):
			tap_index = event.index
			tap_origin = event.position
			og_value = int($LineEdit.text)
	
	if Tap.is_up_index(event, tap_index):
		tap_index = -1
	
	if Tap.is_drag_index(event, tap_index):
		var drag_dist = event.position.x - tap_origin.x
		var new_value = int(og_value + drag_dist)
		$LineEdit.text = String(new_value)
		emit_signal('value_updated', [$Label.text, new_value])
		
func point_in_label(point:Vector2) -> bool:
	return $Label.get_global_rect().has_point(point)
