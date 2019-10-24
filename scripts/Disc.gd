extends Node2D
class_name Disc

signal clicked

var tap_index:int = -1
var tap_offset:Vector2
var prev_position:Vector2
var is_grabbed:bool = false

var acceleration:Vector2
var velocity:Vector2
var velocity_clamp:float = 0.01

var attributes = [
	'x',
	'y',
	'radius',
	'mass',
	'release_factor',
	'decceleration',
]
export var x:float setget x_set, x_get
export var y:float setget y_set, y_get
export var radius:float setget radius_set
export var mass:float setget mass_set
export var release_factor:float setget release_factor_set
export var decceleration:float setget decceleration_set

func x_set(new_x:float) -> void:
	self.position.x = new_x

func x_get() -> float:
	return self.position.x

func y_set(new_y:float) -> void:
	self.position.y = new_y

func y_get() -> float:
	return self.position.y

func radius_set(new_radius:float) -> void:
	radius = new_radius
	update()

func mass_set(new_mass:float) -> void:
	mass = new_mass

func release_factor_set(new_release_factor:float) -> void:
	release_factor = new_release_factor

func decceleration_set(new_decceleration:float) -> void:
	decceleration = new_decceleration


func get_data() -> Dictionary:
	var data = {}
	for key in attributes:
		data[key] = self.get(key)
	return data


func _draw() -> void:
	draw_circle(Vector2(), self.radius, Color(1,0,0))

func init(data:Dictionary) -> Disc:
	for key in data.keys():
		var val = data[key]
		self.set(key, val)
	return self


###### Input #######
func tap(event):
	if tap_index == -1 and has_point(event.position):
		tap_index = event.index
		grab(event.position)

func untap(event):
	if event.index == tap_index:
		tap_index = -1
		release()

func drag(event):
	if event.index == tap_index:
		prev_position = position
		position = event.position - tap_offset


func grab(tap_position):
	is_grabbed = true
	prev_position = position
	tap_offset = tap_position - position
	velocity = Vector2()
	
func release():
	is_grabbed = false
	velocity = (position - prev_position) * release_factor

func move(delta):
	if is_grabbed:
		return
	acceleration = -velocity * decceleration
	velocity += acceleration * delta
	if velocity.length_squared() < velocity_clamp:
		velocity = Vector2()
	position += velocity * delta

func handle_collision(other_disc):
	if is_grabbed or other_disc.is_grabbed:
		return false
	if overlaps_disc(other_disc):
		return true # do other effects
	return false

#func process(delta):
	



func left() -> int:
	return int(position.x - radius)

func right() -> int:
	return int(position.x + radius)

func top() -> int:
	return int(position.y - radius)

func bottom() -> int:
	return int(position.y + radius)

func get_rect() -> Rect2:
	return Rect2(position.x - radius, position.y - radius, radius * 2, radius * 2)

func has_point(point:Vector2) -> bool:
	if get_rect().has_point(point):
		return position.distance_to(point) <= radius
	return false

func overlaps_disc(other_disc):
	if get_rect().intersects(other_disc.get_rect()):
		return position.distance_to(other_disc.position) < radius + other_disc.radius
	return false