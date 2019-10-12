extends Node2D
class_name Circle

var debug_properties: Array = [
	'radius',
	'mass',
	'drag',
	'release_factor',
	'max_speed',
#	'acceleration',
	'velocity',
#	'release_factor',
#	'grabbed',
#	'grabbed_offset',
#	'finger_position',
#	'touch_index',
#	'last_position',
#	'position',
]
signal kill

onready var Game = $'..'

export var texture:String setget texture_set, texture_get
export var sprite_offset:Vector2 setget sprite_offset_set, sprite_offset_get

export var is_powerdown:bool = false
export var is_powerup:bool = false
export var is_slingshot:bool = false
export var is_goal:bool = false
export var is_player:bool = false
export var is_ball:bool = false
export var is_collectible:bool = false setget is_collectible_set, is_collectible_get
export var can_collect:bool = false
export var is_grabbable:bool = true
export var color:String setget color_set
export var max_radius:float setget max_radius_set
export var og_radius:float setget og_radius_set
export var radius:float = 100.0 setget radius_set
export var mass:float = 100.0 setget mass_set
export var drag:float = 0.4 setget drag_set
export var release_factor:float = 10.0 setget release_factor_set
export var acceleration:Vector2 = Vector2()
export var velocity:Vector2 = Vector2() setget velocity_set
export var max_speed:float = 3000 setget max_speed_set
var grabbed:bool = false
var grabbed_offset:Vector2 = Vector2() setget grabbed_offset_set
var sling_offset:Vector2 = Vector2()
var finger_position:Vector2 = Vector2()
var touch_index:int = -1
var last_position:Vector2 = Vector2()
var in_play = false
var shrink_factor = 201/ 3
var can_shrink = true
var can_grow = true
export var max_health = 5 setget max_health_set
export var health = 5 setget health_set

func max_health_set(new_max_health):
	max_health = new_max_health
	self.health = health

func og_radius_set(new_og_radius):
	og_radius = new_og_radius
	self.max_radius = og_radius
	self.radius = max_radius

func max_radius_set(new_max_radius):
	max_radius = new_max_radius
	var perc_health = float(health) / max_health
	var perc_radius = max_radius / og_radius
	self.radius = (perc_health * max_radius)
	$Sprite.set_scale(Vector2(1.1,1.1) * perc_radius)
	

func sprite_offset_set(new_offset):
	$Sprite.position = new_offset

func sprite_offset_get():
	return $Sprite.position

func texture_set(new_texture):
	$Sprite.texture = load(new_texture)

func texture_get():
	return $Sprite.texture

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

func overlaps_goal(other):
	return (is_goal or other.is_goal) and overlaps(other)

func health_set(new_health):
	health = new_health
	if max_health == 0:
		return
	var percent_health = float(health) / max_health
	radius = percent_health * max_radius
	var perc_radius = max_radius / og_radius
	$Sprite.set_scale(Vector2(1.1,1.1) * perc_radius * percent_health)
	update()

func ball_collide(circle:Circle) -> void:
	if self.is_ball and circle.is_goal:
		circle.shrink()
	elif self.is_goal and circle.is_ball:
		shrink()
		
	if is_player and circle.is_ball:
		var ball:Circle = circle
		ball.color = color
		ball.can_collect = true

func powerup_collide(circle):
	if self.is_powerup:
		circle.grow()
		emit_signal("kill", self)
	elif circle.is_powerup:
		self.grow()
		emit_signal("kill", circle)

func powerdown_collide(circle):
	if self.is_powerdown:
		circle.shrink()
	elif circle.is_powerdown:
		self.shrink()

func shrink():
	if can_shrink:
		can_shrink = false
		$Timer.start()
		self.health -= 1
		self.max_radius -= 40
		radius = max_radius
		if radius <= 0:
			hide()
#		$Sprite.set_scale(Vector2(1,1) * percent_health)
#		$Sprite.transform.scale = Vector2(1,1) * percent_health
#		radius -= shrink_factor

func grow():
	if can_grow:
		can_grow = false
		$Timer.start()
		self.max_radius += 20
		radius = max_radius
		if radius <= 0:
			hide()
		

func grabbed_offset_set(new_grabbed_offset:Vector2) -> void:
	grabbed_offset = new_grabbed_offset
#	if position.distance_to(grabbed_offset) > radius:
#		#release
#		grabbed = false
#		touch_index = -1
		
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
#	var perc_health = float(health) / max_health
	var perc_radius = radius / og_radius
#	self.radius = (perc_health * max_radius)
	$Sprite.set_scale(Vector2(1.1,1.1) * perc_radius)
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
	if color:
		draw_circle(Vector2(), radius, Color(color))
	if is_slingshot and grabbed:
		var arrowhead
		if Game.forward_slingshot:
			arrowhead = sling_offset - position
		else:
			arrowhead = Vector2() + (position - sling_offset)
		draw_line(Vector2(), arrowhead, Color('#00ff00'), 4)
		var angle = PI * .05
		var wing:Vector2 = arrowhead * .8 
#		if Game.forward_slingshot:
#			wing = arrowhead * .8 
#		else:
#			wing = -arrowhead * 0.80 * 0.90
		draw_line(arrowhead, wing.rotated(angle), Color('#00ff00'), 4)
		draw_line(arrowhead, wing.rotated(-angle), Color('#00ff00'), 4)

func _process(delta):
	pass
	
func is_within_circle(point:Vector2) -> bool:
	return position.distance_squared_to(point) <= radius * radius

func collect_if_possible() -> void:
	hide()
	
func grab_if_possible(event:InputEventScreenTouch) -> Circle:
	if not is_grabbable or grabbed:
		return null
	if is_within_circle(event.position):
		grabbed = true
		finger_position = event.position
		grabbed_offset = position - finger_position
		touch_index = event.index
		velocity = Vector2()
		return self
	return null
		
func release(event) -> void:
	if event.index == touch_index:
		grabbed = false
		touch_index = -1
		if is_slingshot:
			if Game.forward_slingshot:
				velocity = (sling_offset - position) * release_factor
			else:
				velocity = (position - sling_offset) * release_factor 
			update()


func move(event:InputEventScreenDrag) -> Circle:
	if grabbed and event.index == touch_index:
		if is_slingshot:
#			$Arrow.show()
			sling_offset = event.position
			update()
		else:
			finger_position = event.position
			last_position = position
		return self

	return null


func _on_Timer_timeout():
	can_shrink = true
	can_grow = true
