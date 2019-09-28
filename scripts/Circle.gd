extends Node2D
class_name Circle

var debug_properties: Array = [
	'radius',
	'mass',
	'drag',
	'release_factor',
#	'acceleration',
#	'velocity',
#	'release_factor',
#	'grabbed',
#	'grabbed_offset',
#	'finger_position',
#	'touch_index',
#	'last_position',
#	'position',
]

export var grabbable:bool = true
export var color:String = '#ff0000'
export var radius:float = 100.0 setget radius_set
export var mass:float = 100.0 setget mass_set
export var drag:float = 0.8 setget drag_set
export var release_factor:float = 40.0 setget release_factor_set
export var acceleration:Vector2 = Vector2()
export var velocity:Vector2 = Vector2()
var grabbed:bool = false
var grabbed_offset:Vector2 = Vector2()
var finger_position:Vector2 = Vector2()
var touch_index:int = -1
var last_position:Vector2 = Vector2()

func radius_set(new_radius:float) -> void:
	radius = new_radius
	update()

func mass_set(new_mass:float) -> void:
	mass = new_mass

func drag_set(new_drag:float) -> void:
	drag = new_drag

func release_factor_set(new_release_factor:float) -> void:
	release_factor = new_release_factor
	
func _ready():
	pass

func _draw():
	draw_circle(Vector2(), radius, Color(color))

func _process(delta):
	pass
	
func is_within_circle(point:Vector2) -> bool:
	return position.distance_to(point) <= radius
	
func grab_if_possible(event:InputEventScreenTouch) -> void:
	if not grabbable or grabbed:
		return
	if is_within_circle(event.position):
		grabbed = true
		finger_position = event.position
		grabbed_offset = position - finger_position
		touch_index = event.index
		velocity = Vector2()
		
func release(event:InputEventScreenTouch) -> void:
	if event.index == touch_index:
		grabbed = false
		touch_index = -1


func move(event:InputEventScreenDrag) -> void:
	if grabbed and event.index == touch_index:
		finger_position = event.position
		last_position = position
