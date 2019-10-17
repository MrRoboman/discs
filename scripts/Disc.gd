extends Node2D
class_name Disc


export var x:float setget x_set, x_get
export var y:float setget y_set, y_get
export var radius:float setget radius_set

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


func _draw() -> void:
	draw_circle(Vector2(), self.radius, Color(1,0,0))

func init(data:Dictionary) -> Disc:
	for key in data.keys():
		var val = data[key]
		self.set(key, val)
	return self


func get_data() -> Dictionary:
	return {
		'x': self.position.x,
		'y': self.position.y,
		'radius': self.radius,
	}

func get_rect() -> Rect2:
	return Rect2(position.x - radius, position.y - radius, radius * 2, radius * 2)

func point_overlaps(point:Vector2) -> bool:
	if get_rect().has_point(point):
		return position.distance_to(point) <= radius
	return false