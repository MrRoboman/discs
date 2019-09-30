extends Node2D
class_name Circle

var debug_properties: Array = [
	'radius',
	'mass',
	'drag',
	'release_factor',
	'max_speed',
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

export var is_player:bool = false
export var is_ball:bool = false
export var is_collectible:bool = false setget is_collectible_set, is_collectible_get
export var can_collect:bool = false
export var grabbable:bool = true
export var color:String = '#ff0000' setget color_set
export var radius:float = 100.0 setget radius_set
export var mass:float = 100.0 setget mass_set
export var drag:float = 0.8 setget drag_set
export var release_factor:float = 40.0 setget release_factor_set
export var acceleration:Vector2 = Vector2()
export var velocity:Vector2 = Vector2() setget velocity_set
export var max_speed:float = 3000 setget max_speed_set
var grabbed:bool = false
var grabbed_offset:Vector2 = Vector2() setget grabbed_offset_set
var finger_position:Vector2 = Vector2()
var touch_index:int = -1
var last_position:Vector2 = Vector2()

func left() -> float:
	return position.x - radius
	
func right() -> float:
	return position.x + radius
	
func top() -> float:
	return position.y - radius
	
func bottom() -> float:
	return position.y + radius

func top_left() -> Vector2:
	return Vector2(position.x - radius, position.y - radius)

func top_right() -> Vector2:
	return Vector2(position.x + radius, position.y - radius)

func bottom_left() -> Vector2:
	return Vector2(position.x - radius, position.y + radius)

func bottom_right() -> Vector2:
	return Vector2(position.x + radius, position.y + radius)

func color_set(new_color:String) -> void:
	color = new_color
	update()

func has_velocity() -> bool:
	return velocity.x != 0 or velocity.y != 0

func overlaps(other:Circle) -> bool:
	if left() > other.right() or right() < other.left() or top() > other.bottom() or bottom() < other.top():
		return false
	return position.distance_to(other.position) < radius + other.radius

func ball_collide(circle:Circle) -> void:
	if is_player and circle.is_ball:
		var ball:Circle = circle
		ball.color = color
		ball.can_collect = true

func grabbed_offset_set(new_grabbed_offset:Vector2) -> void:
	grabbed_offset = new_grabbed_offset
	if position.distance_to(grabbed_offset) > radius:
		#release
		grabbed = false
		touch_index = -1
		
func velocity_set(new_velocity: Vector2) -> void:
	velocity = new_velocity
	if velocity.length() > max_speed:
		velocity = velocity.clamped(max_speed)

func is_collectible_set(collectible:bool) -> void:
	is_collectible = collectible

func is_collectible_get() -> bool:
	return is_collectible and visible

func collect(circle:Circle) -> bool:
	if can_collect and circle.is_collectible:
		circle.hide()
		return true
	return false

func radius_set(new_radius:float) -> void:
	radius = new_radius
	update()

func mass_set(new_mass:float) -> void:
	mass = new_mass

func drag_set(new_drag:float) -> void:
	drag = new_drag

func release_factor_set(new_release_factor:float) -> void:
	release_factor = new_release_factor

func max_speed_set(new_max_speed:float) -> void:
	max_speed = new_max_speed
	
func _ready():
	pass

func _draw():
	draw_circle(Vector2(), radius, Color(color))

func _process(delta):
	pass
	
func is_within_circle(point:Vector2) -> bool:
	return position.distance_squared_to(point) <= radius * radius

func collect_if_possible() -> void:
	hide()
	
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
